import 'package:bible_app/saved_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Make sure these point to wherever your tabs are stored!
import 'main.dart';

class MainScreen extends StatefulWidget {
  final int initialTab;
  const MainScreen({super.key, this.initialTab = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 1. App State
  late int _currentIndex;
  String _currentBook = "Genesis";
  int? _currentVerse;
  int _currentChapter = 1;
  bool _isLoading = true;

  // 🎵 AUDIO STATE 🎵
  final FlutterTts _flutterTts = FlutterTts();
  bool _isAudioPlaying = false;
  String _audioTitle = "";
  String _audioSubtitle = "";

  // 🧠 Memory for the Karaoke Loop
  List<dynamic> _audioVerses = [];
  int _audioIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
    _loadLastReadLocation();
    _initTts();
  }

  // 🧠 Initialize default TTS settings and force it to wait
  Future<void> _initTts() async {
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setPitch(1.0);

    // 👇 THE MAGIC FIX: Forces the app to wait until the voice finishes speaking!
    await _flutterTts.awaitSpeakCompletion(true);
  }

  // 🧠 Helper to keep the UI and Scrolling in sync
  void _updateAudioUI() {
    final verseData = _audioVerses[_audioIndex];
    _audioTitle = "$_currentBook $_currentChapter:${verseData['v']}";
    _audioSubtitle = verseData['text'];

    // Changing this triggers ReaderTab to auto-scroll to the new verse!
    _currentVerse = int.parse(verseData['v'].toString());
  }

  Future<void> _loadLastReadLocation() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _currentBook = prefs.getString('last_read_book') ?? "Genesis";
      _currentChapter = prefs.getInt('last_read_chapter') ?? 1;

      if (prefs.containsKey('last_read_verse')) {
        _currentVerse = prefs.getInt('last_read_verse');
      }

      _isLoading = false;
    });
  }

  void _navigateToChapter(String book, int chapter, [int? verse]) {
    debugPrint("🧠 MAIN: Navigating -> $book $chapter:$verse");
    setState(() {
      _currentBook = book;
      _currentChapter = chapter;
      _currentVerse = verse;
      _currentIndex = 2;
    });

    _saveToHistory(book, chapter);
  }

  Future<void> _saveToHistory(String book, int chapter) async {
    final newHistory = SavedItem()
      ..book = book
      ..chapter = chapter
      ..verse = 1
      ..type = "history"
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.savedItems.put(newHistory);
    });
  }

  void _goToReader() {
    setState(() {
      _currentIndex = 2;
    });
  }

  // 🎵 AUDIO FUNCTIONS 🎵
  Future<void> _playAudio(
      int startIndex, String languageCode, List<dynamic> verses) async {
    await _flutterTts.setLanguage(languageCode);

    setState(() {
      _isAudioPlaying = true;
      _audioVerses = verses;
      _audioIndex = startIndex;
    });

    // 🔄 THE NEW BULLETPROOF LOOP
    while (_isAudioPlaying && _audioIndex < _audioVerses.length) {
      setState(() {
        _updateAudioUI(); // Updates the mini-player and triggers the scroll!
      });

      // 🛑 The code pauses right here until the voice finishes reading the verse
      await _flutterTts.speak(_audioVerses[_audioIndex]['text']);

      // ✅ Verse finished! Move to the next one
      if (_isAudioPlaying) {
        _audioIndex++;
      }
    }

    // If it finishes the whole chapter, turn off the player
    if (mounted && _audioIndex >= _audioVerses.length) {
      setState(() {
        _isAudioPlaying = false;
      });
    }
  }

  Future<void> _stopAudio() async {
    // Setting this to false instantly breaks the while loop above!
    setState(() {
      _isAudioPlaying = false;
    });
    await _flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> screens = [
      // 👇 NEW: We are now passing the current book and chapter to the HomeTab!
      HomeTab(
          currentBook: _currentBook,
          currentChapter: _currentChapter,
          onNavigate: _navigateToChapter,
          onReadNow: _goToReader),
      LibraryTab(onNavigate: _navigateToChapter),
      ReaderTab(
        book: _currentBook,
        chapter: _currentChapter,
        initialVerse: _currentVerse,
        isAutoPlaying: _isAudioPlaying,
        onNavigate: _navigateToChapter,
        onBack: () => setState(() => _currentIndex = 0),
        onPlayAudio: _playAudio,
        onStopAudio: _stopAudio,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🎵 GLOBAL MINI-PLAYER 🎵
          if (_isAudioPlaying)
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFF2C2C2E),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, -2))
                  ]),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SafeArea(
                top: false,
                bottom: false,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(CupertinoIcons.speaker_2_fill,
                          color: Colors.blue, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_audioTitle,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(
                            _audioSubtitle,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.stop_circle_fill,
                          color: Colors.white, size: 32),
                      onPressed: _stopAudio,
                    ),
                  ],
                ),
              ),
            ),

          // Navigation Bar
          NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) =>
                setState(() => _currentIndex = index),
            destinations: const [
              NavigationDestination(
                  icon: Icon(CupertinoIcons.home), label: 'Home'),
              NavigationDestination(
                  icon: Icon(CupertinoIcons.book), label: 'Library'),
              NavigationDestination(
                  icon: Icon(CupertinoIcons.book_solid), label: 'Read'),
            ],
          ),
        ],
      ),
    );
  }
}
