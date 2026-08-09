import 'dart:ui';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/bookmark.dart';
import 'models/history_log.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';
import 'saved_item.dart';
import 'streak_manager.dart';
import 'isar_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wakelock_plus/wakelock_plus.dart'; // 👈 Add this to your imports at the top!
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
part 'main.g.dart';

late Isar isar; // Your global variable

// 🌍 GLOBAL LANGUAGE TRACKER
final ValueNotifier<String> globalAppLanguage = ValueNotifier<String>('en');
final ValueNotifier<bool> globalIsUIVisible = ValueNotifier(true);
final ValueNotifier<bool> globalAutoHideSetting = ValueNotifier(true);
final ScrollController _scrollController = ScrollController();
double _scrollPercent = 0.0;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  // 🌍 Initialize timezones
  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleDailyVerseNotification() async {
  // 1. Clear out any old instances to prevent duplicate alarms
  await flutterLocalNotificationsPlugin.cancel(0);

  // 2. Calculate exactly when 8:00 AM local time is
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 8, 0);

  // If it's already past 8:00 AM today, set it for 8:00 AM tomorrow
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  // 3. Schedule the repeating engine
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    '📖 Verse of the Day',
    'Your word is a lamp to my feet and a light to my path. (Psalms 119:105)',
    scheduledDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_verse_channel',
        'Daily Verse',
        channelDescription: 'Your daily scripture reminder',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents
        .time, // 👈 This forces it to repeat every single day at 8 AM!
  );
}

// Function to kill the reminder if they toggle the switch off
Future<void> cancelDailyNotifications() async {
  await flutterLocalNotificationsPlugin.cancel(0);
}

// 📖 OUR UI DICTIONARY
class AppStrings {
  static const Map<String, Map<String, String>> _dict = {
    'en': {
      // Nav Bar
      'nav_home': 'Home',
      'nav_read': 'Read',
      'nav_plans': 'Plans',
      'nav_search': 'Search',
      'nav_settings': 'Settings',

      // Home Tab
      'verse_of_the_day': 'Verse of the Day',
      'continue_reading': 'Continue Reading',
      'daily_devotional': 'Daily Devotional',
      'good_morning': 'Good Morning',
      'good_afternoon': 'Good Afternoon',
      'good_evening': 'Good Evening',

      // Search Tab
      'search_hint': 'Search the Bible...',
      'no_results': 'No results found',
      'recent_searches': 'Recent Searches',
      'old_testament': 'Old Testament',
      'new_testament': 'New Testament',
      'clear_all': 'Clear All',

      // Plans Tab
      'reading_plans': 'Reading Plans',
      'my_plans': 'My Plans',
      'discover_plans': 'Discover',
      'start_plan': 'Start Plan',
      'continue_plan': 'Continue',

      // Reader Tab UI (Not the actual Bible text)
      'chapter': 'Chapter',
      'book': 'Book',
      'font_size': 'Font Size',
      'appearance': 'Appearance',

      // Settings Tab
      'settings': 'Settings',
      'my_stuff': 'My Stuff',
      'my_library': 'My Library',
      'history_bookmarks': 'History & Bookmarks',
      'notes': 'Notes',
      'view_notes': 'View your saved notes',
      'preferences': 'Preferences',
      'app_language': 'App Language / అనువర్తన భాష',
      'dark_mode': 'Dark Mode',
      'notifications': 'Notifications',
      'offline_versions': 'Offline Versions',
      'edit_profile': 'Edit Profile Name',
      'cancel': 'Cancel',
      'save': 'Save',
      'today': 'Today',
      'days': 'days',
      'discover': 'Discover',
      'devotional': 'Devotional',
      'anxiety_peace': 'Anxiety & Peace',
      'study': 'Study',
      'book_of_john': 'The Book of John',
      'start_action': 'Start',
      'the_beginning': 'The Beginning',
      'type_to_search': 'Type to search the Bible...',
      'day': 'Day',
      'read_action': 'Read',

      // Plans Data
      'plan1_title': 'New Believer Course',
      'plan1_desc':
          'Just starting your walk with God? This 7-day journey covers the fundamental promises of scripture. You will learn about salvation, prayer, and how to read the Bible effectively.',
      'plan2_title': 'Overcoming Anxiety',
      'plan2_desc':
          'In a chaotic world, finding peace can seem impossible. This study walks through Philippians and Psalms to help you cast your cares on Him.',
      'plan3_title': 'Gospel of John',
      'plan3_desc':
          'Discover the life of Jesus through the eyes of the disciple whom He loved. A perfect study for understanding the divinity of Christ.',

      // Plan Days
      'day_the_fall': 'The Fall',
      'day_the_promise': 'The Promise',
      'day_faith': 'Faith',
      'day_prayer': 'Prayer',
      'day_the_church': 'The Church',
      'day_new_life': 'New Life',
      'day_peace_of_god': 'Peace of God',
      'day_the_shepherd': 'The Shepherd',
      'day_no_fear': 'No Fear',
      'day_cast_cares': 'Cast Cares',
      'day_rest': 'Rest',
      'day_the_word': 'The Word',
      'day_wedding': 'Wedding at Cana',
      'day_new_birth': 'New Birth',
      'day_living_water': 'Living Water',
      'day_healing': 'Healing',

      // THE UPDATED DAILY VERSES (All 4 are here now!)
      'dv1_text': 'I can do all things through Christ which strengtheneth me.',
      'dv1_ref': 'Philippians 4:13',

      'dv2_text':
          'Trust in the LORD with all thine heart; and lean not unto thine own understanding.',
      'dv2_ref': 'Proverbs 3:5',

      'dv3_text':
          'For God hath not given us the spirit of fear; but of power, and of love, and of a sound mind.',
      'dv3_ref': '2 Timothy 1:7',

      'dv4_text':
          'Be still, and know that I am God: I will be exalted among the heathen, I will be exalted in the earth.',
      'dv4_ref': 'Psalm 46:10',

      // 🌍 NEW FEATURE TRANSLATIONS (ENGLISH)
      'keep_screen_awake': 'Keep Screen Awake',
      'screen_awake_subtitle': 'Prevent screen from sleeping',
      'show_icon_labels': 'Show Icon Labels',
      'icon_labels_subtitle': 'Display text under Bible menu icons',
      'immersive_reading': 'Immersive Reading Mode',
      'immersive_subtitle': 'Auto-hide bottom menu while reading',
      'send_feedback': 'Send Beta Feedback',
      'feedback_subtitle': 'Report bugs directly from your device',
      'reminder_at_8': 'Daily reminder at 8:00 AM',
      'reminders_off': 'Reminders are turned off',
      'startup_tab': 'Startup Tab',
      'startup_tab_subtitle': 'Choose which tab opens first',

      'how_to_use_title': 'App Features & Tips',
      'how_to_use_subtitle': 'App gestures, search, and sharing tips',
      'pinch_zoom_title': 'Pinch to Zoom',
      'pinch_zoom_desc':
          'Pinch your fingers on the screen to change text size. Double tap to reset to normal size.',
      'adv_search_title': 'Advanced Search Scopes',
      'adv_search_desc':
          'Tap the filter icon in the search tab to search for a single term, a specific book, or an exact chapter.',
      'share_title': 'Sharing Options',
      'share_desc':
          'Tap on a verse to copy text or generate a beautiful verse image layout to share on social media.',
      'notes_title': 'Notes & Bookmarks',
      'notes_desc':
          'Add personal notes and bookmarks to specific verses, which update instantly in your workspace.',
      'lang_title': 'Bilingual Support',
      'lang_desc':
          'Switch configurations between English, Telugu, or parallel side-by-side display modes directly from the reader action layout.',
    },
    'te': {
      // Nav Bar
      'nav_home': 'హోమ్',
      'nav_read': 'చదవండి',
      'nav_plans': 'ప్రణాళికలు',
      'nav_search': 'శోధన',
      'nav_settings': 'సెట్టింగ్‌లు',

      // Home Tab
      'verse_of_the_day': 'ఈనాటి వాక్యం',
      'continue_reading': 'చదవడం కొనసాగించండి',
      'daily_devotional': 'రోజువారీ భక్తి',
      'good_morning': 'శుభోదయం',
      'good_afternoon': 'శుభ మధ్యాహ్నం',
      'good_evening': 'శుభ సాయంత్రం',

      // Search Tab
      'search_hint': 'బైబిల్లో వెతకండి...',
      'no_results': 'ఫలితాలు కనుగొనబడలేదు',
      'recent_searches': 'ఇటీవలి శోధనలు',
      'old_testament': 'పాత నిబంధన',
      'new_testament': 'క్రొత్త నిబంధన',
      'clear_all': 'అన్నీ క్లియర్ చేయండి',

      // Plans Tab
      'reading_plans': 'పఠన ప్రణాళికలు',
      'my_plans': 'నా ప్రణాళికలు',
      'discover_plans': 'కనుగొనండి',
      'start_plan': 'ప్రణాళికను ప్రారంభించండి',
      'continue_plan': 'కొనసాగించండి',

      // Reader Tab UI
      'chapter': 'అధ్యాయం',
      'book': 'పుస్తకం',
      'font_size': 'ఫాంట్ పరిమాణం',
      'appearance': 'స్వరూపం',

      // Settings Tab
      'settings': 'సెట్టింగ్‌లు',
      'my_stuff': 'నా అంశాలు',
      'my_library': 'నా లైబ్రరీ',
      'history_bookmarks': 'చరిత్ర & బుక్‌మార్క్‌లు',
      'notes': 'గమనికలు',
      'view_notes': 'మీరు సేవ్ చేసిన గమనికలు',
      'preferences': 'ప్రాధాన్యతలు',
      'app_language': 'App Language / అనుверతన భాష',
      'dark_mode': 'డార్క్ మోడ్',
      'notifications': 'నోటిఫికేషన్‌లు',
      'offline_versions': 'ఆఫ్‌లైన్ వెర్షన్లు',
      'edit_profile': 'ప్రొఫైల్ పేరు మార్చండి',
      'cancel': 'రద్దు చేయి',
      'save': 'సేవ్ చేయండి',
      'today': 'ఈరోజు',
      'days': 'రోజులు',
      'discover': 'కనుగొనండి',
      'devotional': 'భక్తి',
      'anxiety_peace': 'ఆందోళన & శాంతి',
      'study': 'అధ్యయనం',
      'book_of_john': 'యోహాను సువార్త',
      'start_action': 'ప్రారంభించండి',
      'the_beginning': 'ప్రారంభం',
      'type_to_search': 'బైబిల్ లో వెతకడానికి టైప్ చేయండి...',
      'day': 'రోజు',
      'read_action': 'చదవండి',
      // Add these exact key-value pairs inside your Telugu ('te') map:
      'how_to_use_title': 'యాప్ ఫీచర్లు & చిట్కాలు',
      'how_to_use_subtitle': 'యాప్ హావభావాలు, సెర్చ్ మరియు షేరింగ్ చిట్కాలు',
      'pinch_zoom_title': 'పించ్ టు జూమ్',
      'pinch_zoom_desc':
          'టెక్స్ట్ సైజును మార్చడానికి స్క్రీన్‌పై మీ వేళ్లను పించ్ చేయండి. సాధారణ సైజుకు రీసెట్ చేయడానికి డబుల్ టాప్ చేయండి.',
      'adv_search_title': 'అడ్వాన్స్డ్ సెర్చ్ స్కోప్స్',
      'adv_search_desc':
          'ఒకే నిబంధన, ఒక నిర్దిష్ట పుస్తకం లేదా ఖచ్చితమైన అధ్యాయంలో వెతకడానికి సెర్చ్ ట్యాబ్‌లోని ఫిల్టర్ ఐకాన్‌ను నొక్కండి.',
      'share_title': 'షేరింగ్ విధానాలు',
      'share_desc':
          'టెక్స్ట్‌ను కాపీ చేయడానికి లేదా సోషల్ మీడియాలో షేర్ చేయడానికి ఒక అందమైన వర్స్ ఇమేజ్ లేఅవుట్‌ను రూపొందించడానికి వాక్యంపై నొక్కండి.',
      'notes_title': 'నోట్స్ & బుక్‌మార్క్‌లు',
      'notes_desc':
          'నిర్దిష్ట వాక్యాలకు వ్యక్తిగత నోట్స్ మరియు బుక్‌మార్క్‌లను జోడించండి, ఇవి మీ వర్క్‌స్పేస్‌లో వెంటనే అప్‌డేట్ అవుతాయి.',
      'lang_title': 'ద్విభాషా మద్దతు',
      'lang_desc':
          'రీడర్ యాక్షన్ లేఅవుట్ నుండి నేరుగా ఇంగ్లీష్, తెలుగు లేదా పారలల్ సైడ్-బై-సైడ్ డిస్‌ప్లే మోడ్‌ల మధ్య కాన్ఫిగరేషన్‌లను మార్చుకోండి.',

      // Plans Data
      'plan1_title': 'కొత్త విశ్వాసి కోర్సు',
      'plan1_desc':
          'దేవునితో మీ ప్రయాణం ఇప్పుడే మొదలుపెడుతున్నారా? ఈ 7-రోజుల ప్రయాణం లేఖనాల ప్రాథమిక వాగ్దానాలను వివరిస్తుంది. మీరు రక్షణ, ప్రార్థన మరియు బైబిల్ ఎలా సమర్థవంతంగా చదవాలో నేర్చుకుంటారు.',
      'plan2_title': 'ఆందోళనను జయించడం',
      'plan2_desc':
          'ఈ అస్తవ్యస్తమైన ప్రపంచంలో, శాంతిని కనుగొనడం అసాధ్యంగా అనిపించవచ్చు. ఈ అధ్యయనం మీ చింతలను ఆయనపై వేయడానికి ఫిలిప్పీయులు మరియు కీర్తనల ద్వారా నడుపుతుంది.',
      'plan3_title': 'యోహాను సువార్త',
      'plan3_desc':
          'యేసును ప్రేమించిన శిష్యుని కళ్ళ ద్వారా ఆయన జీవితాన్ని కనుగొనండి. క్రీస్తు దైవత్వాన్ని అర్థం చేసుకోవడానికి ఇది ఒక పరిపూర్ణ అధ్యయనం.',

      // Plan Days
      'day_the_fall': 'పతనం',
      'day_the_promise': 'వాగ్దానం',
      'day_faith': 'విశ్వాసం',
      'day_prayer': 'ప్రార్థన',
      'day_the_church': 'సంఘం',
      'day_new_life': 'కొత్త జీవితం',
      'day_peace_of_god': 'దేవుని శాంతి',
      'day_the_shepherd': 'కాపరి',
      'day_no_fear': 'భయం లేదు',
      'day_cast_cares': 'చింతలను వేయండి',
      'day_rest': 'విశ్రాంతి',
      'day_the_word': 'వాక్యం',
      'day_wedding': 'కానాలో వివాహం',
      'day_new_birth': 'కొత్త జన్మ',
      'day_living_water': 'జీవజలం',
      'day_healing': 'స్వస్థత',

      // THE UPDATED DAILY VERSES IN TELUGU (All 4 are here now!)
      'dv1_text': 'నన్ను బలపరచువానియందే నేను సమస్తమును చేయగలను.',
      'dv1_ref': 'ఫిలిప్పీయులకు 4:13',

      'dv2_text':
          'నీ స్వబుద్ధిని ఆధారము చేసికొనక నీ పూర్ణహృదయముతో యెహోవాయందు నమ్మికయుంచుము.',
      'dv2_ref': 'సామెతలు 3:5',

      'dv3_text':
          'దేవుడు మనకు శక్తియు ప్రేమయు, సుబుద్ధియుగల ఆత్మనే యిచ్చెను గాని పిరికితనముగల ఆత్మనియ్యలేదు.',
      'dv3_ref': '2 తిమోతికి 1:7',

      'dv4_text':
          'ఊరకుండుడి, నేనే దేవుడనని తెలిసికొనుడి, అన్యజనులలో నేను బహుమానము పొందుదును, భూమిలో నేను బహుమానము పొందుదును.',
      'dv4_ref': 'కీర్తనలు 46:10',

      // 🌍 NEW FEATURE TRANSLATIONS (TELUGU)
      'keep_screen_awake': 'స్క్రీన్ ఎల్లప్పుడూ ఆన్‌లో ఉంచండి',
      'screen_awake_subtitle':
          'స్క్రీన్ స్లీప్ మోడ్‌లోకి వెళ్లకుండా నిరోధించండి',
      'show_icon_labels': 'ఐకాన్ లేబుల్‌లను చూపించు',
      'icon_labels_subtitle':
          'బైబిల్ మెను ఐకాన్‌ల క్రింద వచనాన్ని ప్రదర్శించండి',
      'immersive_reading': 'ఇమ్మర్సివ్ రీడింగ్ మోడ్',
      'immersive_subtitle': 'చదివేటప్పుడు క్రింది మెనూని ఆటో-హైడ్ చేయండి',
      'send_feedback': 'బీటా ఫీడ్‌బ్యాక్ పంపండి',
      'feedback_subtitle': 'మీ పరికరం నుండి నేరుగా బగ్‌లను నివేదించండి',
      'reminder_at_8': 'ప్రతిరోజూ ఉదయం 8:00 గంటలకు రిమైండర్',
      'reminders_off': 'రిమైండర్‌లు ఆఫ్ చేయబడ్డాయి',
      'startup_tab': 'ప్రారంభ ట్యాబ్',
      'startup_tab_subtitle': 'మొదట ఏ ట్యాబ్ తెరిచాలో ఎంచుకోండి',
    }
  };

  static String get(String key) {
    final lang = globalAppLanguage.value;
    return _dict[lang]?[key] ?? _dict['en']?[key] ?? key;
  }
}

void main() async {
  // 1. Ensure Flutter bindings are ready before loading storage
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Open up SharedPreferences at the absolute starting line
  final prefs = await SharedPreferences.getInstance();

  // 3. Read the saved language. If it doesn't exist yet, default to English ('en')
  final String savedLang = prefs.getString('app_lang') ?? 'en';

  // 4. Update your global variable immediately before running the app layout
  globalAppLanguage.value = savedLang;

  // 5. Run your app like normal
  runApp(const AppBootstrapper());
}

// 🌟 THE FAST "SPOTIFY-STYLE" BOOTSTRAPPER 🌟
class AppBootstrapper extends StatefulWidget {
  const AppBootstrapper({super.key});

  @override
  State<AppBootstrapper> createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<AppBootstrapper> {
  bool _isLoaded = false;
  late Widget _mainApp;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Drop the native screen instantly. Our identical Flutter screen is underneath.
    FlutterNativeSplash.remove();

    try {
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
        [HistoryLogSchema, SavedItemSchema, SavedVerseSchema],
        directory: dir.path,
      );

      await StreakManager.init();
      await BibleData.init();

      final prefs = await SharedPreferences.getInstance();
      final startWithDarkMode = prefs.getBool('isDarkMode') ?? true;
      globalAutoHideSetting.value = prefs.getBool('auto_hide_ui') ?? true;

      final startingTab = prefs.getInt('default_startup_tab') ?? 0;
      final String lastBook = prefs.getString('last_read_book') ?? "Genesis";
      final int lastChapter = prefs.getInt('last_read_chapter') ?? 1;
      final int? lastVerse = prefs.getInt('last_read_verse');

      _mainApp = DailyBibleApp(
        startingTab: startingTab,
        startBook: lastBook,
        startChapter: lastChapter,
        startVerse: lastVerse,
        isDarkMode: startWithDarkMode, // 👈 PASS IT INTO YOUR APP HERE!
      );

      // 👇 The "Spotify Hold": Keep the clean logo on screen for 1.5 seconds
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _isLoaded = true; // Trigger the smooth fade to the main app
        });
      }
    } catch (e) {
      print('🚨 ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Snappy 400ms fade directly into the app
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _isLoaded
          ? KeyedSubtree(key: const ValueKey('MainApp'), child: _mainApp)
          : MaterialApp(
              // 👈 Update this block
              key: const ValueKey('SplashScreen'),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor:
                    const Color(0xFF282a2a), // Kills the white flash
                canvasColor: const Color(0xFF282a2a),
              ),
              home: const CustomSplashScreen(),
            ),
    );
  }
}

// 🌟 THE IDENTICAL CLONE SPLASH SCREEN 🌟
class CustomSplashScreen extends StatelessWidget {
  const CustomSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282a2a),
      body: Center(
        // 👇 Removed width and height completely!
        child: Image.asset(
          'assets/logo-modified.png',
          width: 255,
          height: 255,
        ),
      ),
    );
  }
}

Future<void> _loadDataAndStartApp() async {
  try {
    // 👇 ADD THIS LINE! It gives Flutter 100 milliseconds to actually draw
    // the logo on the screen before the database locks up the system.
    await Future.delayed(const Duration(milliseconds: 2000));

    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [HistoryLogSchema, SavedItemSchema, SavedVerseSchema],
      directory: dir.path,
    );

    await StreakManager.init();
    await BibleData.init();

    final prefs = await SharedPreferences.getInstance();
    final bool startWithDarkMode = prefs.getBool('isDarkMode') ?? true;
    final int startingTab = prefs.getInt('default_startup_tab') ?? 0;
    final String lastBook = prefs.getString('last_read_book') ?? "Genesis";
    final int lastChapter = prefs.getInt('last_read_chapter') ?? 1;
    final int? lastVerse = prefs.getInt('last_read_verse');

    runApp(DailyBibleApp(
      startingTab: startingTab,
      startBook: lastBook,
      startChapter: lastChapter,
      startVerse: lastVerse,
      isDarkMode: startWithDarkMode,
    ));
  } catch (e, stacktrace) {
    print('🚨🚨🚨 ERROR DURING BACKGROUND LOAD 🚨🚨🚨');
    print('ERROR: $e');
    print('STACKTRACE: $stacktrace');
  }
}
// ==============================================================================
// 2. DATA CENTER
// ==============================================================================

@collection
class BibleVerse {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String bookName;

  @Index(type: IndexType.value)
  late int chapter;

  late int verseNumber;

  // 🇺🇸 English Text
  late String textEnglish;

  // 🇮🇳 Telugu Text
  String? textTelugu;
}

// ... Keep your existing BibleData class right below this!

class BibleData {
  // 1. Core Data
  static Map<String, dynamic> _englishData = {};
  static Map<String, dynamic> _teluguData = {};
  static bool isLoaded = false;

  // 2. Reconstructed Library Data
  static final List<String> _books = [];
  static final Map<String, int> _bookChapters = {};

  // 3. Initialization & Auto-Parsing
  static Future<void> init() async {
    try {
      final engString = await rootBundle.loadString('assets/bibles/kjv.json');
      _englishData = json.decode(engString);

      final telString = await rootBundle.loadString('assets/bibles/bible.json');
      _teluguData = json.decode(telString);

      Set<String> bookSet = {};
      for (var key in _englishData.keys) {
        var parts = key.split(':');
        if (parts.isNotEmpty) {
          int lastSpace = parts[0].lastIndexOf(' ');
          if (lastSpace != -1) {
            String bookName = parts[0].substring(0, lastSpace);
            int chapNum = int.tryParse(parts[0].substring(lastSpace + 1)) ?? 1;

            bookSet.add(bookName);
            if ((_bookChapters[bookName] ?? 0) < chapNum) {
              _bookChapters[bookName] = chapNum;
            }
          }
        }
      }

      _books.addAll(bookSet);
      isLoaded = true;
    } catch (e) {
      debugPrint("Database Init Error: $e");
    }
  }

  // --- DAILY VERSE DATA ---
  static final List<Map<String, String>> _dailyVerses = [
    {
      "reference": "dv1_ref",
      "text": "dv1_text",
      "image":
          "https://images.unsplash.com/photo-1504052434569-70ad5836ab65?auto=format&fit=crop&q=80&w=2670"
    },
    {
      "reference": "dv2_ref",
      "text": "dv2_text",
      "image":
          "https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?auto=format&fit=crop&q=80&w=2670"
    },
    {
      "reference": "dv3_ref",
      "text": "dv3_text",
      "image":
          "https://images.unsplash.com/photo-1491841550275-ad7854e35ca6?auto=format&fit=crop&q=80&w=2574"
    }
  ];

  static Map<String, String> getDailyVerse() {
    int dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return _dailyVerses[dayOfYear % _dailyVerses.length];
  }

  // --- USER DATA ---
  static final Map<String, String> _bookmarks = {};
  static final Map<String, String> _notes = {};
  static const int _streakDays = 12;

  // --- STATIC CONTENT ---
  static final Map<String, List<Map<String, String>>> _wordStudies = {
    "Genesis_1_1": [
      {
        "word": "In the beginning",
        "original": "בְּרֵאשִׁית",
        "transliteration": "Bereshit",
        "pronunciation": "bay-ray-sheeth'",
        "definition":
            "The first word of the Bible. It refers to the absolute beginning of time and space.",
        "strongs": "H7225"
      },
      // ... (Rest of your word studies)
    ],
  };

  static final Map<String, String> _aiInsights = {
    "Genesis_1_1":
        "This verse establishes the foundation of a biblical worldview...",
    "Philippians_4_13": "Context is key: Paul wrote this from prison..."
  };

  static final List<Map<String, dynamic>> plans = [
    {
      "title": "plan1_title",
      "desc": "plan1_desc",
      "image":
          "https://images.unsplash.com/photo-1504052434569-70ad5836ab65?auto=format&fit=crop&q=80&w=600",
      "progress": 0.0,
      "schedule": [
        {"day": 1, "title": "day_the_fall", "read": "Genesis 3", "done": false},
        {
          "day": 2,
          "title": "day_the_promise",
          "read": "Genesis 12",
          "done": false
        },
        {"day": 3, "title": "day_faith", "read": "Hebrews 11", "done": false}
      ]
    },
    {
      "title": "plan3_title",
      "desc": "plan3_desc",
      "image":
          "https://images.unsplash.com/photo-1491841550275-ad7854e35ca6?auto=format&fit=crop&q=80&w=600",
      "progress": 0.0,
      "schedule": [
        {"day": 1, "title": "day_the_word", "read": "John 1", "done": false},
        {"day": 2, "title": "day_wedding", "read": "John 2", "done": false},
        {"day": 3, "title": "day_new_birth", "read": "John 3", "done": false}
      ]
    }
  ];

  static final Map<String, int> bookChapters = {
    "Genesis": 50,
    "Exodus": 40,
    "Leviticus": 27,
    "Numbers": 36,
    "Deuteronomy": 34,
    "Joshua": 24,
    "Judges": 21,
    "Ruth": 4,
    "1 Samuel": 31,
    "2 Samuel": 24,
    "1 Kings": 22,
    "2 Kings": 25,
    "1 Chronicles": 29,
    "2 Chronicles": 36,
    "Ezra": 10,
    "Nehemiah": 13,
    "Esther": 10,
    "Job": 42,
    "Psalms": 150,
    "Proverbs": 31,
    "Ecclesiastes": 12,
    "Song of Solomon": 8,
    "Isaiah": 66,
    "Jeremiah": 52,
    "Lamentations": 5,
    "Ezekiel": 48,
    "Daniel": 12,
    "Hosea": 14,
    "Joel": 3,
    "Amos": 9,
    "Obadiah": 1,
    "Jonah": 4,
    "Micah": 7,
    "Nahum": 3,
    "Habakkuk": 3,
    "Zephaniah": 3,
    "Haggai": 2,
    "Zechariah": 14,
    "Malachi": 4,
    "Matthew": 28,
    "Mark": 16,
    "Luke": 24,
    "John": 21,
    "Acts": 28,
    "Romans": 16,
    "1 Corinthians": 16,
    "2 Corinthians": 13,
    "Galatians": 6,
    "Ephesians": 6,
    "Philippians": 4,
    "Colossians": 4,
    "1 Thessalonians": 5,
    "2 Thessalonians": 3,
    "1 Timothy": 6,
    "2 Timothy": 4,
    "Titus": 3,
    "Philemon": 1,
    "Hebrews": 13,
    "James": 5,
    "1 Peter": 5,
    "2 Peter": 3,
    "1 John": 5,
    "2 John": 1,
    "3 John": 1,
    "Jude": 1,
    "Revelation": 22
  };

  static List<String> get books => bookChapters.keys.toList();

// 🌟 THE BULLETPROOF TELUGU HELPER v4 (With Ultimate Fallback)
  static String _getTeluguVerse(String bookName, int chapterNum, int verseNum) {
    try {
      int bookIdx =
          books.indexWhere((b) => b.toLowerCase() == bookName.toLowerCase());
      if (bookIdx == -1) return '';

      var bookList = _teluguData['Book'];
      if (bookIdx >= bookList.length) return '';

      var chapterList = bookList[bookIdx]['Chapter'];
      if (chapterNum - 1 >= chapterList.length) return '';

      List<dynamic> verseList = chapterList[chapterNum - 1]['Verse'];
      if (verseList.isEmpty) return '';

      // 1. Try finding by the exact 3-digit ID suffix
      // 👇 THE FIX: Subtract 1 because Telugu IDs start at "000" for Verse 1!
      String targetSuffix = (verseNum - 1).toString().padLeft(3, '0');

      var matchedVerse = verseList.firstWhere(
        (v) => v['Verseid'].toString().endsWith(targetSuffix),
        orElse: () => null,
      );

      if (matchedVerse != null) {
        return matchedVerse['Verse'].toString();
      }

      // 2. ULTIMATE FALLBACK: Direct index lookup
      // 👇 THE FIX: Just subtract 1. Lists are 0-indexed.
      // If we want Verse 1, we look at Index 0.
      int targetIndex = verseNum - 1;

      // Clamp the index to prevent out-of-bounds crashes
      if (targetIndex >= verseList.length) {
        targetIndex = verseList.length - 1;
      }
      // Safety check in case verseNum was somehow 0 or negative
      if (targetIndex < 0) {
        targetIndex = 0;
      }

      return verseList[targetIndex]['Verse'].toString();
    } catch (e) {
      return '';
    }
  }

  static List<Map<String, dynamic>> getVerses(String book, int chapter) {
    if (!isLoaded) return [];

    List<Map<String, dynamic>> combined = [];

    // 🛡️ THE FIX: Two separate keys for two separate databases!
    // KJV JSON needs "Solomon's Song"
    String englishBookKey =
        (book == "Song of Solomon") ? "Solomon's Song" : book;

    // Telugu JSON (and our index list) needs "Song of Solomon"
    String teluguBookKey =
        (book == "Solomon's Song") ? "Song of Solomon" : book;

    String safeSearchPrefix =
        "${englishBookKey.replaceAll(' ', '').toLowerCase()}$chapter:";

    var matchingKeys = _englishData.keys.where((k) {
      String safeKey = k.replaceAll(' ', '').toLowerCase();
      return safeKey.startsWith(safeSearchPrefix);
    }).toList();

    matchingKeys.sort((a, b) {
      int vA = int.parse(a.split(':')[1]);
      int vB = int.parse(b.split(':')[1]);
      return vA.compareTo(vB);
    });

    for (String key in matchingKeys) {
      int verseNum = int.parse(key.split(':')[1]);
      String engText = _englishData[key] ?? "";

      // We feed the Telugu helper the specific Telugu book key
      String telText = _getTeluguVerse(teluguBookKey, chapter, verseNum);

      combined.add({
        'b': book, // We keep this original so your bookmarks don't break!
        'c': chapter,
        'v': verseNum,
        'text': engText,
        'tel': telText.isEmpty ? "Telugu translation unavailable" : telText
      });
    }

    return combined;
  }

  static Map<String, dynamic>? getVerseById(String id) {
    if (!isLoaded) return null;
    try {
      final parts = id.split('_');
      String book = parts[0];
      int chapter = int.parse(parts[1]);
      int verse = int.parse(parts[2]);

      // Apply the same split-key fix here for bookmarks!
      String englishBookKey =
          (book == "Song of Solomon") ? "Solomon's Song" : book;
      String teluguBookKey =
          (book == "Solomon's Song") ? "Song of Solomon" : book;

      String searchKey = "$englishBookKey $chapter:$verse";
      String? engText = _englishData[searchKey];
      if (engText == null) return null;

      String telText = _getTeluguVerse(teluguBookKey, chapter, verse);

      return {
        'b': book,
        'c': chapter,
        'v': verse,
        'text': engText,
        'tel': telText.isEmpty ? "Telugu translation unavailable" : telText
      };
    } catch (e) {
      return null;
    }
  }

  static List<Map<String, dynamic>> searchVerses(String query) {
    if (query.isEmpty || !isLoaded) return [];

    List<Map<String, dynamic>> results = [];
    // Convert query to lowercase once to save processing power
    String lowerQuery = query.toLowerCase();

    for (var entry in _englishData.entries) {
      String key = entry.key;
      String engText = entry.value.toString().toLowerCase();

      // 1. Parse the book, chapter, and verse immediately
      int colonIdx = key.lastIndexOf(':');
      int spaceIdx = key.lastIndexOf(' ', colonIdx);

      String book = key.substring(0, spaceIdx);
      int chapter = int.parse(key.substring(spaceIdx + 1, colonIdx));
      int verse = int.parse(key.substring(colonIdx + 1));

      // 2. Fetch the Telugu text so we can actually search it
      String telText = _getTeluguVerse(book, chapter, verse);
      String telTextLower = telText.toLowerCase();

      // 3. Check if the query exists in English, the Reference, OR Telugu!
      if (engText.contains(lowerQuery) ||
          key.toLowerCase().contains(lowerQuery) ||
          telTextLower.contains(lowerQuery)) {
        results.add({
          'b': book,
          'c': chapter,
          'v': verse,
          'text': entry.value,
          'tel': telText.isEmpty ? "Telugu translation unavailable" : telText
        });

        // 🎯 LIMIT REMOVED: Let it gather all matches across OT and NT!
      }
    }
    return results;
  }

  // Highlights
  static final Map<String, Color> _highlights = {};
  static void toggleHighlight(String id, Color color) {
    if (_highlights.containsKey(id) && _highlights[id] == color) {
      _highlights.remove(id);
    } else {
      _highlights[id] = color;
    }
  }

  static Color? getHighlight(String id) => _highlights[id];
  static bool isBookmarked(String id) => _bookmarks.containsKey(id);
  static void renameBookmark(String id, String label) {
    if (_bookmarks.containsKey(id)) _bookmarks[id] = label;
  }

  static String getBookmarkLabel(String id) => _bookmarks[id] ?? "";
  static Map<String, String> getBookmarks() => _bookmarks;
  static String? getNote(String id) => _notes[id];

  static void saveNote(String id, String content) {
    if (content.trim().isEmpty) {
      _notes.remove(id);
    } else {
      _notes[id] = content;
    }
  }

  static Map<String, String> getNotes() => _notes;
  static int getStreak() => _streakDays;
  static List<Map<String, String>>? getWordStudy(String id) => _wordStudies[id];
  static String? getAiInsight(String id) => _aiInsights[id];

  // NOTE: 'isar' needs to be globally available or passed in for this to work!
  Future<void> toggleBookmark(
      String book, int chapter, int verse, String text) async {
    final existingBookmark = await isar.bookmarks
        .filter()
        .bookNameEqualTo(book)
        .chapterEqualTo(chapter)
        .verseNumberEqualTo(verse)
        .findFirst();

    await isar.writeTxn(() async {
      if (existingBookmark != null) {
        await isar.bookmarks.delete(existingBookmark.id);
        debugPrint("🗑️ Bookmark removed!");
      } else {
        final newBookmark = Bookmark()
          ..bookName = book
          ..chapter = chapter
          ..verseNumber = verse
          ..verseText = text
          ..savedAt = DateTime.now();

        await isar.bookmarks.put(newBookmark);
        debugPrint("💖 Bookmark saved securely!");
      }
    });
  }
}

class BibleStructure {
  static const List<Map<String, dynamic>> oldTestament = [
    {"name": "Genesis", "chapters": 50},
    {"name": "Exodus", "chapters": 40},
    {"name": "Leviticus", "chapters": 27},
    // ... (You can add the rest of the 39 OT books here)
    {"name": "Psalms", "chapters": 150},
  ];

  static const List<Map<String, dynamic>> newTestament = [
    {"name": "Matthew", "chapters": 28},
    {"name": "Mark", "chapters": 16},
    {"name": "Luke", "chapters": 24},
    {"name": "John", "chapters": 21},
    {"name": "Acts", "chapters": 28},
    {"name": "Romans", "chapters": 16},
    // ... (You can add the rest of the 27 NT books here)
    {"name": "Revelation", "chapters": 22},
  ];
}

class BibleBooksScreen extends StatelessWidget {
  final Function(String, int) onNavigate;

  const BibleBooksScreen({super.key, required this.onNavigate});

  List<Map<String, dynamic>> _getBooks(int start, int end) {
    return BibleData.books
        .sublist(start, end)
        .map((b) => {"name": b, "chapters": BibleData.bookChapters[b] ?? 1})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Read the Bible"),

          // --- NEW BUTTONS ADDED HERE ---
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              tooltip: 'Bookmarks',
              onPressed: () {
                print("Bookmarks clicked");
                // Later, we will add navigation to the Bookmarks screen here
              },
            ),
            IconButton(
              icon: const Icon(Icons.notes),
              tooltip: 'Notes',
              onPressed: () {
                print("Notes clicked");
                // Later, we will add navigation to the Notes screen here
              },
            ),
          ],
          // ------------------------------

          bottom: const TabBar(
            tabs: [
              Tab(text: "OLD TESTAMENT"),
              Tab(text: "NEW TESTAMENT"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BookListView(books: _getBooks(0, 39), onNavigate: onNavigate),
            BookListView(books: _getBooks(39, 66), onNavigate: onNavigate),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 🔍 SEARCH TAB
// ==========================================

class SearchTab extends StatefulWidget {
  // 👇 FIXED: Added an optional [int? verse] so it can finally send the verse number!
  final Function(String book, int chapter, [int? verse]) onNavigate;

  const SearchTab({super.key, required this.onNavigate});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String _searchQuery = "";
  List<Map<String, dynamic>> _allResults = [];
  List<Map<String, dynamic>> _filteredResults = [];

  List<String> _recentSearches = [];
  String _selectedFilter = "All"; // Can be "All", "OT", or "NT"

  final TextEditingController _searchController = TextEditingController();

  // 🎯 NEW: Scoping controllers for Book and Chapter scoping
  final TextEditingController _bookScopeController = TextEditingController();
  final TextEditingController _chapterScopeController = TextEditingController();
  bool _isAdvancedSearchOpen = false;

  int _visibleCount = 30;

  final Set<String> _otBooks = {
    "Genesis",
    "Exodus",
    "Leviticus",
    "Numbers",
    "Deuteronomy",
    "Joshua",
    "Judges",
    "Ruth",
    "1 Samuel",
    "2 Samuel",
    "1 Kings",
    "2 Kings",
    "1 Chronicles",
    "2 Chronicles",
    "Ezra",
    "Nehemiah",
    "Esther",
    "Job",
    "Psalms",
    "Proverbs",
    "Ecclesiastes",
    "Song of Solomon",
    "Isaiah",
    "Jeremiah",
    "Lamentations",
    "Ezekiel",
    "Daniel",
    "Hosea",
    "Joel",
    "Amos",
    "Obadiah",
    "Jonah",
    "Micah",
    "Nahum",
    "Habakkuk",
    "Zephaniah",
    "Haggai",
    "Zechariah",
    "Malachi"
  };

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.removeWhere((q) => q.toLowerCase() == query.toLowerCase());
    _recentSearches.insert(0, query.trim());
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.sublist(0, 10);
    }
    await prefs.setStringList('recent_searches', _recentSearches);
    setState(() {});
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _visibleCount = 30;
      if (query.isEmpty) {
        _allResults = [];
        _filteredResults = [];
      } else {
        _allResults = BibleData.searchVerses(query);
        _applyFilter();
      }
    });
  }

  // 🎛️ ADVANCED FILTER: Handles OT/NT tabs AND Scope rules
  void _applyFilter() {
    final normalizedEnglishOt =
        _otBooks.map((b) => b.trim().toLowerCase()).toSet();

    // Read user inputs for target book/chapter scopes
    final targetBook = _bookScopeController.text.trim().toLowerCase();
    final targetChapter = int.tryParse(_chapterScopeController.text.trim());

    // 1. Process Testament Filter (OT/NT/All)
    List<Map<String, dynamic>> stage1 = [];
    if (_selectedFilter == "All") {
      stage1 = List.from(_allResults);
    } else {
      stage1 = _allResults.where((r) {
        final bookName = r['b']?.toString().trim().toLowerCase() ?? "";
        final bool isOt = normalizedEnglishOt.contains(bookName);
        return _selectedFilter == "OT" ? isOt : !isOt;
      }).toList();
    }

    // 2. Process Custom Book and Chapter scopes dynamically
    _filteredResults = stage1.where((r) {
      final itemBook = r['b']?.toString().trim().toLowerCase() ?? "";
      final itemChapter = int.tryParse(r['c'].toString()) ?? -1;

      // Match custom book text if typed
      if (targetBook.isNotEmpty && !itemBook.contains(targetBook)) {
        return false;
      }
      // Match custom chapter if typed
      if (targetChapter != null && itemChapter != targetChapter) {
        return false;
      }
      return true;
    }).toList();

    setState(() {});
  }

  void _loadMoreResults() {
    setState(() => _visibleCount += 30);
  }

  Widget _buildHighlightedText(String text, String query, TextStyle baseStyle) {
    if (query.isEmpty) return Text(text, style: baseStyle);
    final matches =
        RegExp(RegExp.escape(query), caseSensitive: false).allMatches(text);
    if (matches.isEmpty) return Text(text, style: baseStyle);

    List<TextSpan> spans = [];
    int currentIndex = 0;
    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: const TextStyle(
            backgroundColor: Colors.yellow,
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ));
      currentIndex = match.end;
    }
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }
    return RichText(text: TextSpan(children: spans, style: baseStyle));
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMoreToLoad = _filteredResults.length > _visibleCount;
    final int itemRenderCount =
        hasMoreToLoad ? _visibleCount + 1 : _filteredResults.length;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppStrings.get('nav_search') ?? "Search"),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔎 SEARCH INPUT ROW WITH TOGGLE BUTTON
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 12.0, bottom: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _performSearch,
                    onSubmitted: (val) {
                      _saveRecentSearch(val);
                      FocusScope.of(context).unfocus();
                    },
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                    decoration: InputDecoration(
                      hintText:
                          AppStrings.get('search_hint') ?? "Search verses...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch("");
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isAdvancedSearchOpen
                        ? Icons.filter_list_off
                        : Icons.filter_list,
                    color:
                        _isAdvancedSearchOpen ? Colors.blueAccent : Colors.grey,
                  ),
                  onPressed: () {
                    setState(
                        () => _isAdvancedSearchOpen = !_isAdvancedSearchOpen);
                  },
                )
              ],
            ),
          ),

          // 🎛️ NEW ADVANCED TARGET SCOPE CONTAINER
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _isAdvancedSearchOpen
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _bookScopeController,
                            onChanged: (_) => _applyFilter(),
                            decoration: InputDecoration(
                              hintText: "Specific Book (e.g. John)",
                              isDense: true,
                              filled: true,
                              fillColor: Colors.grey.withValues(alpha: 0.08),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _chapterScopeController,
                            onChanged: (_) => _applyFilter(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Ch.",
                              isDense: true,
                              filled: true,
                              fillColor: Colors.grey.withValues(alpha: 0.08),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // 🎛️ FILTER CHIPS
          if (_searchQuery.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: ["All", "OT", "NT"].map((filter) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: _selectedFilter == filter,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFilter = filter;
                            _visibleCount = 30;
                          });
                          _applyFilter();
                        }
                      },
                      selectedColor: Colors.blueAccent.withValues(alpha: 0.3),
                      labelStyle: TextStyle(
                        color: _selectedFilter == filter
                            ? Colors.blueAccent
                            : Colors.grey,
                        fontWeight: _selectedFilter == filter
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 4),

          // 📄 CONTENT AREA (Independent Tab Scrolling Restored)
          Expanded(
            child: _searchQuery.isEmpty
                ? (_recentSearches.isEmpty
                    ? Center(
                        child: Text(AppStrings.get('type_to_search') ??
                            "Type to search..."))
                    : ListView.builder(
                        itemCount: _recentSearches.length,
                        itemBuilder: (context, index) {
                          final recent = _recentSearches[index];
                          return ListTile(
                            leading:
                                const Icon(Icons.history, color: Colors.grey),
                            title: Text(recent,
                                style: const TextStyle(fontSize: 16)),
                            onTap: () {
                              _searchController.text = recent;
                              _performSearch(recent);
                            },
                          );
                        },
                      ))
                : _filteredResults.isEmpty
                    ? Center(
                        child: Text(AppStrings.get('no_results') ??
                            "No results found."))
                    : ListView.builder(
                        key: PageStorageKey(
                            "search_result_${_selectedFilter}"), // 🎯 FIXED SCROLL HERE
                        itemCount: itemRenderCount,
                        itemBuilder: (context, index) {
                          if (hasMoreToLoad && index == _visibleCount) {
                            final totalRemaining =
                                _filteredResults.length - _visibleCount;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      Colors.blueAccent.withValues(alpha: 0.15),
                                  foregroundColor: Colors.blueAccent,
                                  elevation: 0,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: _loadMoreResults,
                                icon: const Icon(Icons.expand_more),
                                label: Text(
                                    "View More ($totalRemaining Results Left)",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ),
                            );
                          }

                          final result = _filteredResults[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: ListTile(
                              onTap: () {
                                widget.onNavigate(
                                    result['b'],
                                    int.parse(result['c'].toString()),
                                    int.parse(result['v'].toString()));
                              },
                              title: Text(
                                "${result['b']} ${result['c']}:${result['v']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildHighlightedText(
                                        result['text'],
                                        _searchQuery,
                                        TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color)),
                                    const SizedBox(height: 6),
                                    _buildHighlightedText(
                                        result['tel'],
                                        _searchQuery,
                                        TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color ??
                                                Colors.grey.shade700)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 📅 PLANS TAB
// ==========================================
class PlansTab extends StatefulWidget {
  final Function(String book, int chapter) onNavigate;

  const PlansTab({super.key, required this.onNavigate});

  @override
  State<PlansTab> createState() => _PlansTabState();
}

class _PlansTabState extends State<PlansTab> {
  // 👇 NEW: This runs the moment the Plans tab is opened to load saved progress!
  @override
  void initState() {
    super.initState();
    _loadPlanProgress();
  }

  // 👇 NEW: Function to load the saved completion status from SharedPreferences
  Future<void> _loadPlanProgress() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      for (var plan in BibleData.plans) {
        List schedule = plan['schedule'];
        int completedDays = 0;

        for (var dayData in schedule) {
          // Creates a unique save key like: "plan_Genesis_day_1"
          String key = "plan_${plan['title']}_day_${dayData['day']}";

          // Load the boolean, defaulting to false if not found
          dayData['done'] = prefs.getBool(key) ?? false;

          if (dayData['done']) completedDays++;
        }
        // Recalculate the overall progress bar
        plan['progress'] = completedDays / schedule.length;
      }
    });
  }

  void _openPlanDetails(BuildContext context, Map<String, dynamic> plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        List schedule = plan['schedule'];
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return ListView.builder(
              controller: controller,
              padding: const EdgeInsets.all(16),
              itemCount: schedule.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      AppStrings.get(plan['title']),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                final dayData = schedule[index - 1];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        dayData['done'] ? Colors.green : Colors.grey.shade300,
                    child: Icon(dayData['done'] ? Icons.check : Icons.book,
                        color: Colors.white, size: 18),
                  ),
                  title: Text(
                      "${AppStrings.get('day')} ${dayData['day']}: ${AppStrings.get(dayData['title'])}"),
                  subtitle: Text(
                      "${AppStrings.get('read_action')} ${dayData['read']}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    // 👇 CHANGED: Update the state in memory first
                    setState(() {
                      dayData['done'] = true;
                      int completedDays =
                          schedule.where((d) => d['done'] == true).length;
                      plan['progress'] = completedDays / schedule.length;
                    });

                    // 👇 NEW: Save that progress permanently!
                    final prefs = await SharedPreferences.getInstance();
                    String key = "plan_${plan['title']}_day_${dayData['day']}";
                    await prefs.setBool(key, true);

                    // We need to check if the context is still mounted after an async gap
                    if (!context.mounted) return;
                    Navigator.pop(context);

                    List<String> parts = dayData['read'].split(' ');
                    String book = parts.sublist(0, parts.length - 1).join(' ');
                    if (book == "Psalm") {
                      book = "Psalms";
                    }
                    int chapter = int.parse(parts.last);
                    widget.onNavigate(book, chapter);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AppStrings.get('reading_plans')), elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: BibleData.plans.length,
        itemBuilder: (context, index) {
          final plan = BibleData.plans[index];

          // 👇 ADD THIS LINE: Safely default to 0.0 if progress hasn't loaded yet!
          double currentProgress = (plan['progress'] ?? 0.0).toDouble();

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: InkWell(
              onTap: () => _openPlanDetails(context, plan),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(plan['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.get(plan['title']),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(AppStrings.get(plan['desc']),
                            style: TextStyle(color: Colors.grey.shade700)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value:
                                    currentProgress, // 👈 USE SAFE VARIABLE HERE
                                backgroundColor: Colors.grey.shade200,
                                color: Colors.blueAccent,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 👈 USE SAFE VARIABLE HERE TOO
                            Text("${(currentProgress * 100).toInt()}%"),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookListView extends StatelessWidget {
  final List<Map<String, dynamic>> books;
  final Function(String, int) onNavigate;

  const BookListView({
    super.key,
    required this.books,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          title: Text(
            book["name"],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text("${book["chapters"]} Chapters"),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChapterSelectionScreen(
                  bookName: book["name"],
                  chapterCount: book["chapters"],
                  onNavigate: onNavigate,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChapterSelectionScreen extends StatelessWidget {
  final String bookName;
  final int chapterCount;
  final Function(String, int) onNavigate;

  const ChapterSelectionScreen({
    super.key,
    required this.bookName,
    required this.chapterCount,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookName)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: chapterCount,
        itemBuilder: (context, index) {
          final chapterNumber = index + 1;
          return InkWell(
            onTap: () {
              onNavigate(bookName, chapterNumber);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "$chapterNumber",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReadingScreen extends StatelessWidget {
  final String bookName;
  final int chapterNumber;

  const ReadingScreen({
    super.key,
    required this.bookName,
    required this.chapterNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$bookName $chapterNumber"),
      ),
      body: Center(
        child: Text(
          "This is where the English/Telugu text for $bookName $chapterNumber will go once we load the full database!",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// ==============================================================================
// 2. THEME ENGINE
// ==============================================================================

class AppTheme {
  static const primary = Color(0xFFC79246); // Muted Gold
  static const secondary = Color(0xFF2D3436); // Slate

  static const lightBg = Color(0xFFF9F9F9);
  static const darkBg = Color(0xFF121212);

  static const lightCard = Colors.white;
  static const darkCard = Color(0xFF1E1E1E);

  static ThemeData build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? darkBg : lightBg,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        surface: isDark ? darkCard : lightCard,
      ),
      fontFamily: '.SF Pro Text',
      appBarTheme: AppBarTheme(
        backgroundColor: (isDark ? darkBg : lightBg).withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3),
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      cardTheme: CardThemeData(
        color: isDark ? darkCard : lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        thickness: 1,
      ),
    );
  }
}

// ==============================================================================
// DATABASE SEEDING LOGIC
// ==============================================================================
// ==============================================================================
// BILINGUAL DATABASE SEEDING LOGIC
// ==============================================================================
Future<void> importBibleToIsar() async {
  var count;
  if (count > 0) {
    return;
  }

  debugPrint(
      "Starting bilingual Bible import. This might take a few seconds...");

  try {
    // 1. Load BOTH JSON files
    final String engResponse =
        await rootBundle.loadString('assets/bibles/kjv.json');
    // 👇 Change 'telugu.json' if your file is named something else!
    final String telResponse =
        await rootBundle.loadString('assets/bibles/telugu.json');

    final Map<String, dynamic> engData = json.decode(engResponse);
    final Map<String, dynamic> telData = json.decode(telResponse);

    List<BibleVerse> versesToInsert = [];

    // 2. Loop through the English data
    engData.forEach((key, value) {
      final match = RegExp(r'^(.+) (\d+):(\d+)$').firstMatch(key);

      if (match != null) {
        final book = match.group(1)!;
        final chapter = int.parse(match.group(2)!);
        final verseNum = int.parse(match.group(3)!);

        String cleanEng = value.toString();
        if (cleanEng.startsWith('# ')) cleanEng = cleanEng.substring(2);

        // 3. Grab the exact same verse key from the Telugu file!
        String? matchingTelugu = telData[key]?.toString();

        final verse = BibleVerse()
          ..bookName = book
          ..chapter = chapter
          ..verseNumber = verseNum
          ..textEnglish = cleanEng
          ..textTelugu =
              matchingTelugu; // Saves the Telugu text right next to it!

        versesToInsert.add(verse);
      }
    });

    // 4. Save all of them to Isar
    await isar.writeTxn(() async {});

    debugPrint("Import complete! Bilingual database ready.");
  } catch (e) {
    debugPrint("Uh oh! Error importing the Bibles: $e");
  }
}

class DailyBibleApp extends StatefulWidget {
  final int startingTab;
  final String startBook; // 👈 1. Add this
  final int startChapter; // 👈 2. Add this
  final int? startVerse; // 👈 1. Add this!
  final bool isDarkMode;

  const DailyBibleApp({
    super.key,
    this.startingTab = 0,
    this.startBook = "Genesis", // 👈 Fallback
    this.startChapter = 1, // 👈 Fallback
    this.startVerse, // 👈 2. Add this!
    required this.isDarkMode,
  });

  @override
  State<DailyBibleApp> createState() => _DailyBibleAppState();
}

class _DailyBibleAppState extends State<DailyBibleApp> {
  late ThemeMode _themeMode; // 👈 1. Change this!
  // 👇 3. Change all three of these to 'late'!
  late int _tabIndex;
  late String _book;
  late int _chapter;
  int? _initialVerse;

  // 🗣️ GLOBAL AUDIO ENGINE: Lifted up so it never dies!
  final FlutterTts _flutterTts = FlutterTts();
  bool _isAutoPlaying = false;
  int _currentPlayingIndex = -1;
  String _currentAudioLang = "en-US";
  List<dynamic> _currentChapterVerses = [];

  // 🔑 Global key for safe navigation
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    _themeMode = widget.isDarkMode ? ThemeMode.dark : ThemeMode.light;

    // 🚀 4. Instantly set the exact position before the screen draws!
    _tabIndex = widget.startingTab;
    _book = widget.startBook;
    _chapter = widget.startChapter;
    _initialVerse = widget.startVerse; // 👈 4. Add this!

    // 🚀 THE GLOBAL DOMINO EFFECT: Plays the next verse across any tab!
    _flutterTts.setCompletionHandler(() {
      if (_isAutoPlaying && _currentChapterVerses.isNotEmpty) {
        int nextIndex = _currentPlayingIndex + 1;
        if (nextIndex < _currentChapterVerses.length) {
          _playGlobalVerse(nextIndex, _currentAudioLang, _currentChapterVerses);
        } else {
          _stopGlobalAudio();
        }
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  // ... Keep the rest of your DailyBibleApp code exactly the same! ...

  // 🕒 History Logger
  Future<void> _logHistory(String book, int chapter) async {
    final entry = HistoryLog()
      ..bookName = book
      ..chapter = chapter
      ..readAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.historyLogs.put(entry);
    });
  }

  void toggleTheme() => setState(() => _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);

  void _goToReader(String book, int chapter, [int? verse]) {
    setState(() {
      _book = book;
      _chapter = chapter;
      _initialVerse = verse;
      _tabIndex = 1;
    });

    // 👇 💾 NOW WE SAVE THE VERSE TOO!
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('last_read_book', book);
      prefs.setInt('last_read_chapter', chapter);

      // If a specific verse was passed in, save it!
      // If not, remove the old saved verse so it starts at the top of the chapter.
      if (verse != null) {
        prefs.setInt('last_read_verse', verse);
      } else {
        prefs.remove('last_read_verse');
      }
    });
  }

// 🗣️ THE GLOBAL PLAY FUNCTION
  void _playGlobalVerse(
      int index, String languageCode, List<dynamic> verses) async {
    if (index >= verses.length) return;

    setState(() {
      _isAutoPlaying = true;
      _currentPlayingIndex = index;
      _currentAudioLang = languageCode;
      _currentChapterVerses = verses;
    });

    var v = verses[index];
    String textToRead = languageCode == "en-US" ? v['text'] : (v['tel'] ?? "");

    if (languageCode == "te-IN" &&
        (textToRead.isEmpty ||
            textToRead == "Telugu translation unavailable")) {
      _flutterTts.stop();
      _playGlobalVerse(index + 1, languageCode, verses);
      return;
    }

    try {
      await _flutterTts.setLanguage(languageCode);
      await _flutterTts.setPitch(0.95);

      // 👇 Sets your dynamic speed properly
      await _flutterTts.setSpeechRate(0.5 * _playbackSpeed);

      // 👇 FIXED: Now it only speaks exactly ONE time!
      await _flutterTts.speak(textToRead);
    } catch (e) {
      debugPrint("❌ Error playing audio: $e");
    }

    try {
      await _flutterTts.setLanguage(languageCode);
      await _flutterTts.setSpeechRate(0.45);
      await _flutterTts.setPitch(0.95);
      // 👇 ADD THIS LINE RIGHT BEFORE IT SPEAKS
      await _flutterTts.setSpeechRate(0.5 * _playbackSpeed);

      // This is your existing speak command
      await _flutterTts.speak(textToRead);
      await _flutterTts.speak(textToRead);
    } catch (e) {
      debugPrint("❌ Error playing audio: $e");
    }
  }

// ⏩ SPEED CONTROLS
  double _playbackSpeed = 1.0;

  void _togglePlaybackSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.25;
      } else if (_playbackSpeed == 1.25) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else if (_playbackSpeed == 2.0) {
        _playbackSpeed = 0.75;
      } else {
        _playbackSpeed = 1.0;
      }
    });

    // Send the new speed to the engine
    _flutterTts.setSpeechRate(0.5 * _playbackSpeed);

    // 👇 NEW HACK: Force an instant speed change!
    // This stops the engine and restarts the current verse at the new speed.
    if (_isAutoPlaying && _currentPlayingIndex != -1) {
      _flutterTts.stop();
      _playGlobalVerse(
          _currentPlayingIndex, _currentAudioLang, _currentChapterVerses);
    }
  }

  // 🗣️ THE GLOBAL STOP FUNCTION
  void _stopGlobalAudio() async {
    await _flutterTts.stop();
    setState(() {
      _isAutoPlaying = false;
      _currentPlayingIndex = -1;
    });
  }

  Widget _getCurrentPage() {
    switch (_tabIndex) {
      case 0:
        return HomeTab(
            currentBook: _book, // 👈 FIXED: Now pulls your actual saved book!
            currentChapter:
                _chapter, // 👈 FIXED: Now pulls your actual saved chapter!
            key: const ValueKey(0),
            onReadNow: () => setState(() => _tabIndex = 1),
            onNavigate: _goToReader);
      case 1:
        return ReaderTab(
            key: const ValueKey(1),
            book: _book,
            chapter: _chapter,
            initialVerse: _initialVerse,
            onNavigate: _goToReader,
            onPlayAudio: _playGlobalVerse,
            onStopAudio: _stopGlobalAudio,
            isAutoPlaying: _isAutoPlaying,
            onBack: () => setState(() => _tabIndex = 0));
      case 2:
        return PlansTab(key: const ValueKey(2), onNavigate: _goToReader);
      case 3:
        return SearchTab(key: const ValueKey(3), onNavigate: _goToReader);
      case 4:
        return SettingsTab(
            key: const ValueKey(4),
            themeMode: _themeMode,
            toggleTheme: toggleTheme,
            onNavigate: _goToReader);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: globalAppLanguage,
      builder: (context, currentLang, child) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          themeMode: _themeMode,
          theme: AppTheme.build(Brightness.light),
          darkTheme: AppTheme.build(Brightness.dark),
          home: Builder(
            builder: (appContext) {
              return Scaffold(
                extendBody: true,
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.02),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _getCurrentPage(),
                    ),

                    // 🌟 THE GLOBAL MINI-PLAYER
                    if (_isAutoPlaying && _currentChapterVerses.isNotEmpty)
                      Positioned(
                        bottom: 100,
                        left: 16,
                        right: 16,
                        child: _AudioMiniPlayer(
                          verseTitle:
                              "$_book $_chapter:${_currentChapterVerses[_currentPlayingIndex]['v']}",
                          language: _currentAudioLang == "en-US"
                              ? "English"
                              : "Telugu",
                          // 👇 PASSED THE NEW SPEED VARIABLES HERE
                          playbackSpeed: _playbackSpeed,
                          onSpeedToggle: _togglePlaybackSpeed,
                          onStop: _stopGlobalAudio,
                          onTap: () {
                            if (_tabIndex != 1) {
                              setState(() => _tabIndex = 1);
                            }
                          },
                        ),
                      ),
                  ], // 👈 THIS BRACKET WAS MISSING!
                ),

                // 👇 ANIMATED BOTTOM NAVIGATION BAR
                bottomNavigationBar: ValueListenableBuilder<bool>(
                  valueListenable: globalIsUIVisible,
                  builder: (context, isVisible, child) {
                    return AnimatedSlide(
                      duration: const Duration(milliseconds: 300),
                      offset: Offset(0, isVisible ? 0 : 1),
                      child: _GlassNavBar(
                          index: _tabIndex,
                          onTap: (i) => setState(() => _tabIndex = i)),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ==============================================================================
// 3. HOME TAB (ORIGINAL UI - NOW FUNCTIONAL WITH SCROLLING & SHARE)
// ==============================================================================
class HomeTab extends StatelessWidget {
  final String currentBook;
  final int currentChapter;
  final VoidCallback onReadNow;
  final Function(String, int, [int?])
      onNavigate; // 🌟 FIXED: Now accepts optional verse target parameter!

  const HomeTab(
      {super.key,
      required this.currentBook,
      required this.currentChapter,
      required this.onReadNow,
      required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 80,
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
          elevation: 0,
          floating: false,
          pinned: false,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 20, bottom: 10),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(AppStrings.get('today'),
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                        color: isDark ? Colors.white : Colors.black87)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 4),
                  child: _buildStreakBadge(context),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildHeroCard(context),
                const SizedBox(height: 40),
                Text(AppStrings.get('discover'),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    children: [
                      _featureCard(
                          context,
                          AppStrings.get('devotional'),
                          AppStrings.get('anxiety_peace'),
                          CupertinoIcons.heart_fill,
                          const Color(0xFFFF6B6B),
                          () => onNavigate("Philippians", 4,
                              13)), // 🌟 Added verse parameter 13
                      _featureCard(
                          context,
                          AppStrings.get('study'),
                          AppStrings.get('book_of_john'),
                          CupertinoIcons.book_fill,
                          const Color(0xFF4D96FF),
                          () => onNavigate(
                              "John", 1, 1)), // 🌟 Added verse parameter 1
                      _featureCard(
                          context,
                          AppStrings.get('start_action'), // 🌍 Changed key here
                          AppStrings.get('the_beginning'),
                          CupertinoIcons
                              .flag_fill, // 🎨 Optional: Changed to a flag/start icon
                          const Color(0xFFFFB347),
                          () => onNavigate("Genesis", 1, 1)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                InkWell(
                  onTap: onReadNow,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 8))
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle),
                          child: const Icon(CupertinoIcons.book_fill,
                              color: AppTheme.primary, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                AppStrings.get('continue_reading')
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0)),
                            const SizedBox(height: 4),
                            Text("$currentBook $currentChapter",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const Spacer(),
                        const Icon(CupertinoIcons.arrow_right,
                            color: Colors.grey, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildStreakBadge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentStreak = StreakManager.streak;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.flame_fill,
              color: currentStreak > 0 ? Colors.orange : Colors.grey, size: 14),
          const SizedBox(width: 6),
          Text("$currentStreak ${AppStrings.get('days')}",
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    final List<Map<String, dynamic>> dailyVerses = [
      {
        "text": "dv1_text",
        "reference": "dv1_ref",
        "book": "Philippians",
        "chapter": 4,
        "verse": 13, // 🌟 Added explicit target verse number
        "image":
            "https://images.unsplash.com/photo-1504052434569-70ad5836ab65?q=80&w=800&auto=format&fit=crop"
      },
      {
        "text": "dv2_text",
        "reference": "dv2_ref",
        "book": "Proverbs",
        "chapter": 3,
        "verse": 5, // 🌟 Added explicit target verse number
        "image":
            "https://images.unsplash.com/photo-1469474968028-56623f02e42e?q=80&w=800&auto=format&fit=crop"
      },
      {
        "text": "dv3_text",
        "reference": "dv3_ref",
        "book": "2 Timothy",
        "chapter": 1,
        "verse": 7, // 🌟 Added explicit target verse number
        "image":
            "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?q=80&w=800&auto=format&fit=crop"
      },
      {
        "text": "dv4_text",
        "reference": "dv4_ref",
        "book": "Psalms",
        "chapter": 46,
        "verse": 10, // 🌟 Added explicit target verse number
        "image":
            "https://images.unsplash.com/photo-1478147427282-58a87a120781?q=80&w=800&auto=format&fit=crop"
      },
    ];

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final todayVerse = dailyVerses[dayOfYear % dailyVerses.length];

    return GestureDetector(
      // 🌟 FIXED: Passes book, chapter, and verse index cleanly to reader!
      onTap: () => onNavigate(
          todayVerse["book"], todayVerse["chapter"], todayVerse["verse"]),
      child: Container(
        height: 420,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 15))
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.network(
                todayVerse["image"],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.grey),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  debugPrint("🚨 IMAGE ERROR: $error");
                  return Container(
                    color: Colors.grey[800],
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image,
                            color: Colors.white54, size: 40),
                        SizedBox(height: 8),
                        Text("Failed to load",
                            style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black.withValues(alpha: 0.9)
                    ],
                    stops: const [
                      0.4,
                      0.8,
                      1.0
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                        AppStrings.get('verse_of_the_day').toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "\"${AppStrings.get(todayVerse["text"])}\"",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Georgia',
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(AppStrings.get(todayVerse["reference"]),
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),

// 🌟 UPDATED WITH IPAD POPUP ANCHORING Logic:
                      InkWell(
                        onTap: () async {
                          final text = AppStrings.get(todayVerse["text"]);
                          final ref = AppStrings.get(todayVerse["reference"]);

                          // 1. Find the physical size and location of the tap button
                          final RenderBox? box =
                              context.findRenderObject() as RenderBox?;

                          // 2. Safely trigger the share drawer with coordinates
                          await Share.share(
                            '"$text" — $ref\n\nShared from the Bible App',
                            sharePositionOrigin: box != null
                                ? box.localToGlobal(Offset.zero) & box.size
                                : null, // 🎯 This gives iPad/iOS the exact popup placement coordinates!
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: const Icon(CupertinoIcons.share,
                              color: Colors.white, size: 18),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(BuildContext context, String type, String title,
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const Spacer(),
            Text(type,
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5)),
            const SizedBox(height: 6),
            Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: Theme.of(context).textTheme.bodyMedium?.color)),
          ],
        ),
      ),
    );
  }
}

class ReaderTab extends StatefulWidget {
  final String book;
  final int chapter;
  final int? initialVerse;
  final Function(String, int, [int?]) onNavigate;
  final VoidCallback onBack;
  final Function(int, String, List<dynamic>) onPlayAudio;
  final VoidCallback onStopAudio;
  final bool isAutoPlaying;

  const ReaderTab({
    super.key,
    required this.book,
    required this.chapter,
    this.initialVerse,
    required this.onNavigate,
    required this.onBack,
    required this.onPlayAudio,
    required this.onStopAudio,
    required this.isAutoPlaying,
  });

  @override
  State<ReaderTab> createState() => _ReaderTabState();
}

class _ReaderTabState extends State<ReaderTab> {
  int? _expandedVerseIndex;
  int? _flashedVerseIndex; // 👈 ADD THIS! Tracks the temporary flash
  String _displayMode = "both";
  int _selectedThemeIndex = 0;
  bool _isCustomTheme = false;
  Color _customBgColor = const Color(0xFFF4ECD8);
  Color _customTextColor = const Color(0xFF5B4636);
  double _fontSize = 18.0;
  double _baseFontSize = 18.0; // 👈 Used to track the scale during a pinch!
  bool _showIconLabels = true;
  bool _notificationsEnabled = false; // 👈 Tracks if the reminder is turned on
// 🗓️ Daily Verse Data
  Map<String, dynamic>? _dailyVerseData = {
    'v': 1,
    'text': "Your word is a lamp to my feet and a light to my path.",
    'tel': "నీ వాక్యము నా పాదములకు దీపమును నా మార్గమునకు వెలుగునై యున్నది."
  };
  String _dailyBook = "Psalms";
  int _dailyChapter = 119;
  double _playbackSpeed = 1.0;

  void _togglePlaybackSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0)
        _playbackSpeed = 1.25;
      else if (_playbackSpeed == 1.25)
        _playbackSpeed = 1.5;
      else if (_playbackSpeed == 1.5)
        _playbackSpeed = 2.0;
      else if (_playbackSpeed == 2.0)
        _playbackSpeed = 0.75;
      else
        _playbackSpeed = 1.0;
    });
  }

  // 🏷️ Nametags for scrolling to specific verses
  final Map<int, GlobalKey> _verseKeys = {};

  // 🧠 LOCAL MEMORY (Highlights, bookmarks, notes)
  final Map<int, Color> _highlights = {};
  final Set<int> _bookmarks = {};
  final Map<int, String> _notes = {};

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _loadSettings();

    // 👇 ADDED THIS: Log the streak the second they open a chapter!
    StreakManager.markReadToday();

    if (widget.initialVerse != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) _scrollToAndFlashVerse(widget.initialVerse!); // ✅ FIXED
        });
      });
    }
  }

  void _showFontSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Adjust Text Size",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("A",
                          style: TextStyle(fontSize: 14)), // Small A
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 14.0,
                          max: 36.0,
                          activeColor: Colors.blue,
                          onChanged: (newValue) {
                            setSheetState(() {
                              _fontSize = newValue;
                            });
                            setState(() {});
                            _saveSettings(); // 👈 NOW SAVES GLOBALLY
                          },
                        ),
                      ),
                      const Text("A",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold)), // Big A
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant ReaderTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialVerse != oldWidget.initialVerse &&
        widget.initialVerse != null) {
      // 🔎 DIAGNOSTIC PRINT 2: See what the layout receives when navigating from your dashboard list
      print(
          "🚀 NAVIGATION CHECK: ReaderTab received an initialVerse value of = ${widget.initialVerse}");

      // 🎯 THE FIX: Instead of calling an undefined controller, we use your app's built-in function!
      // We pass it the target verse directly.
      try {
        _scrollToVerse(widget.initialVerse!);
        print(
            "⚙️ SCROLL ENGINE: Sent verse ${widget.initialVerse} to _scrollToVerse()");
      } catch (e) {
        print(
            "⚠️ SCROLL ENGINE ERROR: Could not find or run _scrollToVerse: $e");
      }
    }
  }

  void _triggerVerseFlash(int index) {
    setState(() {
      _flashedVerseIndex = index;
    });

    // Wait for 800 milliseconds, then clear the flash
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && _flashedVerseIndex == index) {
        setState(() {
          _flashedVerseIndex = null;
        });
      }
    });
  }

  // 📝 SHARE AS TEXT
  void _shareVerseAsText(
      String book, int chapter, int verseNum, String engText, String telText) {
    String shareText =
        "📖 $book $chapter:$verseNum\n\n$engText\n\n$telText\n\nShared via My Bible App";

    // This pops open the native iOS/Android share menu!
    Share.share(shareText);
  }

  void _scrollToAndFlashVerse(int targetVerseNum) {
    String lookupBook = _getCorrectedBookName(widget.book);
    final verses = BibleData.getVerses(lookupBook, widget.chapter);
    print(
        "👀 DEBUG CHECK: Book = '$lookupBook', Chapter = '${widget.chapter}', Verses Found = ${verses.length}");

    // 🎯 THE FIX: Subtract 1 here to turn the verse number (e.g. 6) into the code index (e.g. 5)
    int targetIndex = targetVerseNum - 1;

    if (targetIndex >= 0 && targetIndex < verses.length) {
      // 2. Safely scroll to the verse using the GlobalKey we assigned
      final keyContext = _verseKeys[targetVerseNum]?.currentContext;
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.3,
        );
      }

      // 3. Trigger your existing flash animation using the corrected index
      _triggerVerseFlash(targetIndex);
    }
  }

  void _goToNextChapter() {
    int maxChapters = BibleData.bookChapters[widget.book] ??
        1; // Assuming your variable is widget.book

    if (widget.chapter < maxChapters) {
      // Still in the same book, just go to the next chapter
      widget.onNavigate(widget.book, widget.chapter + 1);
    } else {
      // Reached the end of the book, jump to chapter 1 of the NEXT book
      int bookIndex = BibleData.books.indexOf(widget.book);
      if (bookIndex < BibleData.books.length - 1) {
        String nextBook = BibleData.books[bookIndex + 1];
        widget.onNavigate(nextBook, 1);
      }
    }
  }

  void _goToPrevChapter() {
    if (widget.chapter > 1) {
      // Still in the same book, just go back a chapter
      widget.onNavigate(widget.book, widget.chapter - 1);
    } else {
      // Reached chapter 1, jump to the LAST chapter of the PREVIOUS book
      int bookIndex = BibleData.books.indexOf(widget.book);
      if (bookIndex > 0) {
        String prevBook = BibleData.books[bookIndex - 1];
        int prevBookMaxChapters = BibleData.bookChapters[prevBook] ?? 1;
        widget.onNavigate(prevBook, prevBookMaxChapters);
      }
    }
  }

  void _scrollToVerseAndFlash(int verseNum) {
    // 1. Wait a moment for the new chapter's ListView to build and attach the keys
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;

      // Find the specific verse in the list
      final targetContext = _verseKeys[verseNum]?.currentContext;

      if (targetContext != null) {
        // 2. Smoothly scroll to the verse
        Scrollable.ensureVisible(
          targetContext,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
          alignment:
              0.2, // 0.2 leaves a little breathing room at the top of the screen
        ).then((_) {
          // 3. 🌟 FLASH THE VERSE AFTER SCROLLING IS 100% DONE! 🌟
          _triggerVerseFlash(
              verseNum - 1); // verseNum - 1 gets the correct index
        });
      }
    });
  }

  void _scrollToVerse(int verseNumber) {
    debugPrint("🚀 Attempting to scroll to verse $verseNumber...");

    Future.delayed(const Duration(milliseconds: 400), () {
      final key = _verseKeys[verseNumber];

      if (key == null) {
        debugPrint(
            "❌ ERROR: Could not find the GlobalKey for verse $verseNumber!");
        return;
      }

      if (key.currentContext == null) {
        debugPrint(
            "❌ ERROR: The context for verse $verseNumber is null (it hasn't rendered yet)!");
        return;
      }

      debugPrint("✅ Key found! Scrolling now...");
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.15,
      );
    });
  }

// 💾 LOAD SAVED DATA (Bookmarks, Notes, AND Highlights!)
  Future<void> _loadSavedData() async {
    final dbBook = widget.book;
    final dbChapter = widget.chapter;

    final savedItemsForChapter = await isar.savedItems
        .filter()
        .bookEqualTo(dbBook)
        .chapterEqualTo(dbChapter)
        .findAll();

    if (!mounted) return;

    setState(() {
      _bookmarks.clear();
      _notes.clear();
      _highlights.clear();

      for (var item in savedItemsForChapter) {
        int uiIndex = item.verse - 1;

        if (item.type == "bookmark") {
          // 🎯 THE FINAL FIX: Add the raw item.verse (e.g., 7) directly to _bookmarks!
          // This keeps the bookmark icon locked onto the exact verse line instead of sliding back.
          _bookmarks.add(item.verse);
        } else if (item.type == "note" && item.content != null) {
          // 🎯 UNIFIED STRATEGY FIX: Use item.verse directly as the map key!
          // This matches your bookmark system and keeps the note icon perfectly aligned.
          _notes[item.verse] = item.content!;
        } else if (item.type == "highlight") {
          // 👇 Read our secret color code!
          Color hColor =
              Colors.orange; // Fallback to orange if no color is found
          if (item.content != null && item.content!.contains("///")) {
            final parts = item.content!.split("///");
            final colorString = parts[0].replaceAll("COLOR:", "");
            final colorValue = int.tryParse(colorString);
            if (colorValue != null) {
              hColor = Color(colorValue);
            }
          }

          _highlights[item.verse] = hColor.withValues(alpha: 0.15);
        }
      }
    });
  }

  // 💾 LOAD ALL SETTINGS (Font, Language, Colors, Themes)
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _fontSize = prefs.getDouble('bible_font_size') ?? 18.0;
        _displayMode = prefs.getString('bible_display_mode') ?? "both";
        _selectedThemeIndex = prefs.getInt('bible_theme_index') ?? 0;
        _isCustomTheme = prefs.getBool('bible_is_custom_theme') ?? false;
        _showIconLabels = prefs.getBool('show_icon_labels') ?? true;

        int? savedBg = prefs.getInt('bible_custom_bg');
        if (savedBg != null) _customBgColor = Color(savedBg);

        int? savedText = prefs.getInt('bible_custom_text');
        if (savedText != null) _customTextColor = Color(savedText);
      });
    }
  }

// 💾 SAVE ALL SETTINGS
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('bible_font_size', _fontSize);
    await prefs.setString('bible_display_mode', _displayMode);
    await prefs.setInt('bible_theme_index', _selectedThemeIndex);
    await prefs.setBool('bible_is_custom_theme', _isCustomTheme);
    await prefs.setInt('bible_custom_bg', _customBgColor.value);
    await prefs.setInt('bible_custom_text', _customTextColor.value);

    // History Saves
    await prefs.setString('last_read_book', widget.book);
    await prefs.setInt('last_read_chapter', widget.chapter);

    // 👇 NEW: Save the verse!
    if (widget.initialVerse != null) {
      await prefs.setInt('last_read_verse', widget.initialVerse!);
    } else {
      await prefs.remove(
          'last_read_verse'); // Clears it so it defaults to top if no verse was selected
    }
  }

  // Curated Pairings
  final List<Map<String, dynamic>> _themes = [
    {
      "name": "System",
      "bg": null,
      "text": null,
      "preview": Colors.grey.shade300
    },
    {
      "name": "Light",
      "bg": const Color(0xFFFFFFFF),
      "text": const Color(0xFF1C1C1E),
      "preview": Colors.white
    },
    {
      "name": "Sepia",
      "bg": const Color(0xFFF4ECD8),
      "text": const Color(0xFF5B4636),
      "preview": const Color(0xFFF4ECD8)
    },
    {
      "name": "Charcoal",
      "bg": const Color(0xFF2C2C2E),
      "text": const Color(0xFFE5E5E7),
      "preview": const Color(0xFF2C2C2E)
    },
    {
      "name": "Midnight",
      "bg": const Color(0xFF0F172A),
      "text": const Color(0xFF94A3B8),
      "preview": const Color(0xFF0F172A)
    },
  ];

  // Custom Color Palettes
  final List<Color> _bgColors = [
    Colors.white,
    const Color(0xFFF4ECD8),
    const Color(0xFFE2E8F0),
    const Color(0xFF2C2C2E),
    const Color(0xFF0F172A),
    Colors.black
  ];
  final List<Color> _textColors = [
    Colors.black,
    const Color(0xFF5B4636),
    const Color(0xFF1E293B),
    const Color(0xFFE5E5E7),
    const Color(0xFF94A3B8),
    Colors.white
  ];

// 📱 AUDIO LANGUAGE DIALOG
  void _showAudioLanguageDialog(int index, List<dynamic> verses) {
    // 1. IF TELUGU ONLY: Skip dialog, play Telugu directly
    if (_displayMode == "telugu") {
      widget.onPlayAudio(index, "te-IN", verses);
      return; // This stops the dialog from opening
    }

    // 2. IF ENGLISH ONLY: Skip dialog, play English directly
    if (_displayMode == "english") {
      widget.onPlayAudio(index, "en-US", verses);
      return; // This stops the dialog from opening
    }

    // 3. IF BOTH: Show the dialog so the user can choose
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Select Audio Language",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.blue),
                title: const Text("English"),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  widget.onPlayAudio(index, "en-US", verses);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.orange),
                title: const Text("Telugu (తెలుగు)"),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  widget.onPlayAudio(index, "te-IN", verses);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBookPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _BookChapterPicker(
          displayMode: _displayMode,
          onSelect: (String book, int chapter, int verse) {
            // 👇 FIXED: We now pass the verse to onNavigate!
            widget.onNavigate(book, chapter, verse);

            Navigator.pop(context);

            _scrollToVerseAndFlash(verse);
          },
        );
      },
    );
  }

  void _copyVerse(Map<String, dynamic> verse) async {
    final text = "${verse['b']} ${verse['c']}:${verse['v']} - ${verse['text']}";
    await Clipboard.setData(ClipboardData(text: text));
    setState(() => _expandedVerseIndex = null);
  }

// 📝 FULL UNIFIED NOTE DIALOG
  void _showNoteDialog(int dbVerseNum, Map<String, dynamic> verse) {
    // Look up existing text using the true verse number as the key
    TextEditingController noteController =
        TextEditingController(text: _notes[dbVerseNum] ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Note for ${verse['b']} ${verse['c']}:$dbVerseNum",
          style: const TextStyle(fontSize: 18),
        ),
        content: TextField(
          controller: noteController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Type your thoughts here...",
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () async {
              final textToSave = noteController.text.trim();

              // Write/Update the note directly in Isar using the true verse number
              await isar.writeTxn(() async {
                final existingNote = await isar.savedItems
                    .filter()
                    .bookEqualTo(widget.book)
                    .chapterEqualTo(widget.chapter)
                    .verseEqualTo(dbVerseNum)
                    .typeEqualTo("note")
                    .findFirst();

                if (existingNote != null) {
                  await isar.savedItems.delete(existingNote.id);
                }

                if (textToSave.isNotEmpty) {
                  final newNote = SavedItem()
                    ..book = widget.book
                    ..chapter = widget.chapter
                    ..verse = dbVerseNum
                    ..type = "note"
                    ..content = textToSave
                    ..createdAt = DateTime.now();

                  await isar.savedItems.put(newNote);
                }
              });

              // Update your local state so the icon changes color instantly
              setState(() {
                if (textToSave.isNotEmpty) {
                  _notes[dbVerseNum] = textToSave;
                } else {
                  _notes.remove(dbVerseNum);
                }
                _expandedVerseIndex = null; // Close the menu smoothly
              });

              Navigator.pop(context);
            },
            child: const Text("Save Note"),
          ),
        ],
      ),
    );
  }

  String _getCorrectedBookName(String bookName) {
    // Force the check to be entirely lowercase so we never miss it!
    String checkName = bookName.toLowerCase();

    // Catch the mismatched KJV name and fix it for the JSON lookup
    if (checkName == "song of solomon" || checkName == "song of songs") {
      return "Solomon's Song";
    }

    // You can add others here later if you find more, like:
    // if (checkName == "psalms") return "Psalm";

    return bookName; // If it's normal, just return it as-is
  }

  Widget _buildColorSwatch({
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
              color:
                  isSelected ? Colors.blue : Colors.grey.withValues(alpha: 0.3),
              width: isSelected ? 3 : 1),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.3),
                  blurRadius: 4,
                  spreadRadius: 1)
          ],
        ),
        child: isSelected
            ? Icon(Icons.check,
                size: 20,
                color: color.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white)
            : null,
      ),
    );
  }

  void _showAppearanceMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color ??
                  Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const Text("Preset Themes",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_themes.length, (index) {
                    final theme = _themes[index];
                    final isSelected =
                        !_isCustomTheme && _selectedThemeIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setSheetState(() {
                          _selectedThemeIndex = index;
                          _isCustomTheme = false;
                        });
                        setState(() {});
                        _saveSettings(); // 👈 NOW SAVES GLOBALLY
                      },
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: theme["preview"],
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.withValues(alpha: 0.3),
                                  width: isSelected ? 3 : 1),
                            ),
                            child: isSelected
                                ? Icon(Icons.check,
                                    color:
                                        index > 1 ? Colors.white : Colors.black,
                                    size: 20)
                                : null,
                          ),
                          const SizedBox(height: 8),
                          Text(theme["name"],
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color:
                                      isSelected ? Colors.blue : Colors.grey)),
                        ],
                      ),
                    );
                  }),
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider()),
                const Text("Custom Colors",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text("Background",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _bgColors
                        .map((c) => _buildColorSwatch(
                            color: c,
                            isSelected: _isCustomTheme && _customBgColor == c,
                            onTap: () {
                              setSheetState(() {
                                _isCustomTheme = true;
                                _customBgColor = c;
                              });
                              setState(() {});
                              _saveSettings(); // 👈 NOW SAVES GLOBALLY
                            }))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Text",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _textColors
                        .map((c) => _buildColorSwatch(
                            color: c,
                            isSelected: _isCustomTheme && _customTextColor == c,
                            onTap: () {
                              setSheetState(() {
                                _isCustomTheme = true;
                                _customTextColor = c;
                              });
                              setState(() {});
                              _saveSettings(); // 👈 NOW SAVES GLOBALLY
                            }))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildActionIcon(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: color, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

// 🎨 HIGHLIGHT COLOR PICKER
  void _showHighlightPicker(int index, Map<String, dynamic> verse) {
    final List<Color> pickerColors = [
      Colors.transparent, // 👈 NEW: The "Clear Highlight" option
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ??
              Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Choose Color",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: pickerColors.map((color) {
                bool isClearBtn = color == Colors.transparent;

                return GestureDetector(
                  onTap: () async {
                    Navigator.pop(context); // Close the sheet

                    final dbBook = widget.book;
                    final dbChapter = widget.chapter;
                    final dbVerse = int.parse(verse['v'].toString());

                    if (isClearBtn) {
                      // 🗑️ THEY CLICKED CLEAR: Remove the highlight entirely
                      setState(() {
                        _highlights.remove(index);
                        _expandedVerseIndex = null;
                      });

                      await isar.writeTxn(() async {
                        final old = await isar.savedItems
                            .filter()
                            .bookEqualTo(dbBook)
                            .chapterEqualTo(dbChapter)
                            .verseEqualTo(dbVerse)
                            .typeEqualTo("highlight")
                            .findFirst();
                        if (old != null) await isar.savedItems.delete(old.id);
                      });
                    } else {
                      // 🎨 THEY CLICKED A COLOR: Save or update the highlight
                      setState(() {
                        _highlights[index] = color.withValues(alpha: 0.15);
                        _expandedVerseIndex = null;
                      });

                      final colorEncodedText =
                          "COLOR:${color.value}///${verse['text']}";

                      final newHighlight = SavedItem()
                        ..book = dbBook
                        ..chapter = dbChapter
                        ..verse = dbVerse
                        ..type = "highlight"
                        ..content = colorEncodedText
                        ..createdAt = DateTime.now();

                      await isar.writeTxn(() async {
                        // Delete the old one first so we don't accidentally double-stack them
                        final old = await isar.savedItems
                            .filter()
                            .bookEqualTo(dbBook)
                            .chapterEqualTo(dbChapter)
                            .verseEqualTo(dbVerse)
                            .typeEqualTo("highlight")
                            .findFirst();
                        if (old != null) await isar.savedItems.delete(old.id);

                        await isar.savedItems.put(newHighlight);
                      });
                    }
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: isClearBtn
                          ? Colors.grey.withValues(alpha: 0.2)
                          : color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isClearBtn ? Colors.grey : color, width: 2),
                    ),
                    // 👇 NEW: Put a cool reset icon in the clear button!
                    child: isClearBtn
                        ? const Icon(Icons.format_color_reset,
                            color: Colors.grey, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineMenu(int index, Map<String, dynamic> verse) {
    // 🎯 THE UNIFIED STRATEGY: We use the true verse number for everything!
    final dbVerse = int.parse(verse['v'].toString());

    final isHighlighted = _highlights.containsKey(dbVerse);
    final isBookmarked = _bookmarks.contains(dbVerse);
    final hasNote = _notes.containsKey(dbVerse);

    return Container(
      margin:
          const EdgeInsets.only(top: 4.0, bottom: 16.0, left: 8.0, right: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 🗣️ PLAY BUTTON
          _buildActionIcon(
            CupertinoIcons.volume_up,
            "Play",
            Colors.blue,
            () {
              String displayBook = widget.book.trim();
              if (displayBook.isNotEmpty) {
                displayBook = displayBook[0].toUpperCase() +
                    displayBook.substring(1).toLowerCase();
              }

              String lookupBook = _getCorrectedBookName(displayBook);
              final chapterVerses =
                  BibleData.getVerses(lookupBook, widget.chapter);

              _showAudioLanguageDialog(index, chapterVerses);
            },
          ),

          // 🖍️ HIGHLIGHT BUTTON
          _buildActionIcon(
            isHighlighted
                ? Icons.format_color_fill
                : Icons.format_color_fill_outlined,
            "Highlight",
            isHighlighted ? Colors.orange : Colors.grey.shade600,
            () {
              _showHighlightPicker(dbVerse, verse);
            },
          ),

          // 🔖 BOOKMARK BUTTON
          _buildActionIcon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            "Bookmark",
            isBookmarked ? Colors.blue : Colors.grey.shade600,
            () async {
              print("📣 DEBUG: Tapping Bookmark Button!");
              final dbBook = widget.book;
              final dbChapter = widget.chapter;
              final bool currentlyBookmarked = _bookmarks.contains(dbVerse);

              if (currentlyBookmarked) {
                setState(() {
                  _bookmarks.remove(dbVerse);
                  _expandedVerseIndex = null;
                });

                await isar.writeTxn(() async {
                  final itemToDelete = await isar.savedItems
                      .filter()
                      .bookEqualTo(dbBook)
                      .chapterEqualTo(dbChapter)
                      .verseEqualTo(dbVerse)
                      .typeEqualTo("bookmark")
                      .findFirst();

                  if (itemToDelete != null) {
                    await isar.savedItems.delete(itemToDelete.id);
                  }
                });
              } else {
                setState(() {
                  _bookmarks.add(dbVerse);
                  _expandedVerseIndex = null;
                });

                final newBookmark = SavedItem()
                  ..book = widget.book
                  ..chapter = widget.chapter
                  ..verse = dbVerse
                  ..type = "bookmark"
                  ..content = ""
                  ..createdAt = DateTime.now();

                await isar.writeTxn(() async {
                  await isar.savedItems.put(newBookmark);
                });
              }
            },
          ),

          // 📝 UNIFIED NOTE BUTTON
          _buildActionIcon(
            hasNote ? Icons.note : Icons.edit_note,
            "Note",
            hasNote ? Colors.green : Colors.grey.shade600,
            () => _showNoteDialog(dbVerse, verse),
          ),

          // 📋 SHARE BUTTON
          _buildActionIcon(
            Icons.share,
            "Share",
            Colors.blueAccent,
            () => _showShareOptions(verse),
          ),
        ],
      ),
    );
  }

  // 🎛️ SHOW SHARE OPTIONS SHEET
  void _showShareOptions(Map<String, dynamic> verse) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final String bookName = widget.book;
        final int chapterNum = widget.chapter;
        final String verseNum = verse['v'].toString();
        final String engText = verse['text'] ?? "";
        final String telText = verse['tel'] ?? "";

        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                child: Text(
                  "$bookName $chapterNum:$verseNum",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const Divider(height: 1),

              // 📋 COPY TEXT BUTTON (Handles English, Telugu, and Both!)
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.blue),
                title: const Text("Copy Verse Text"),
                onTap: () async {
                  Navigator.pop(sheetContext);

                  String textToCopy = "📖 $bookName $chapterNum:$verseNum\n\n";

                  if (_displayMode == "telugu") {
                    textToCopy += telText;
                  } else if (_displayMode == "both") {
                    textToCopy += "$engText\n\n$telText";
                  } else {
                    // Default to English
                    textToCopy += engText;
                  }

                  await Clipboard.setData(ClipboardData(text: textToCopy));

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Verse text copied!")),
                    );
                  }
                },
              ),

              ListTile(
                leading: const Icon(Icons.image, color: Colors.purple),
                title: const Text("Share as Image Card"),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _shareVerseAsImage(verse);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

// 🎨 GENERATE & SHARE IMAGE CARD
  void _shareVerseAsImage(Map<String, dynamic> verse) {
    final GlobalKey boundaryKey = GlobalKey();
    final String bookName = widget.book;
    final int chapterNum = widget.chapter;
    final String verseNum = verse['v'].toString();
    final String engText = verse['text'] ?? "";
    final String telText = verse['tel'] ?? "";

    // Determine layout modes based on your _displayMode variable
    final bool showEnglish =
        (_displayMode == "english" || _displayMode == "both");
    final bool showTelugu =
        (_displayMode == "telugu" || _displayMode == "both") &&
            telText.isNotEmpty &&
            telText != "Telugu translation unavailable";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🖼️ THE PREVIEW IMAGE CARD
              RepaintBoundary(
                key: boundaryKey,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header reference
                      Text(
                        "$bookName $chapterNum:$verseNum".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🏴󠁧󠁢󠁥󠁮󠁧󠁿 ENGLISH SECTION
                      if (showEnglish) ...[
                        Text(
                          engText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            height: 1.4,
                            // Italicizes English if showing side-by-side
                            fontStyle: (_displayMode == "both")
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                        ),
                      ],

                      // ➖ DIVIDER (Only visible in "both" mode)
                      if (_displayMode == "both" &&
                          showEnglish &&
                          showTelugu) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          child: Divider(color: Colors.white30, thickness: 0.5),
                        ),
                      ],

                      // 🇮🇳 TELUGU SECTION
                      if (showTelugu) ...[
                        Text(
                          telText,
                          style: const TextStyle(
                            color: Color(0xFFEEEEEE),
                            fontSize: 18,
                            height: 1.5,
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Shared via My Bible App",
                          style: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🚀 TRIGGER ACTION SHEET BUTTON
              ElevatedButton.icon(
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text("Send Image",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () async {
                  try {
                    RenderRepaintBoundary boundary = boundaryKey.currentContext!
                        .findRenderObject() as RenderRepaintBoundary;
                    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
                    ByteData? byteData =
                        await image.toByteData(format: ui.ImageByteFormat.png);
                    Uint8List pngBytes = byteData!.buffer.asUint8List();

                    final tempDir = await getTemporaryDirectory();
                    final file = await File(
                            '${tempDir.path}/verse_${bookName}_${chapterNum}_$verseNum.png')
                        .create();
                    await file.writeAsBytes(pngBytes);

                    Navigator.pop(dialogContext);

                    final RenderBox? box =
                        dialogContext.findRenderObject() as RenderBox?;
                    final Rect? iPadShareOrigin = box != null
                        ? box.localToGlobal(Offset.zero) & box.size
                        : null;

                    await Share.shareXFiles(
                      [XFile(file.path)],
                      text: '📖 $bookName $chapterNum:$verseNum',
                      sharePositionOrigin: iPadShareOrigin,
                    );
                  } catch (e) {
                    debugPrint("❌ Error rendering or sharing image card: $e");
                  }
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.white70)),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: Icon(icon, size: 14, color: color),
    );
  }

  Widget _buildEmptyState(String b, int c) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_stories,
                size: 50, color: Colors.blue.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 24),
          Text("No text found for $b $c",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Try checking your connection or data file.",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

// 🌍 FULL 66-BOOK TRANSLATION DICTIONARY (For _ReaderTabState)
  String _getTranslatedBookName(String englishBook) {
    // 👇 FIX: Using _displayMode instead of widget.displayMode!
    if (_displayMode == "english" || _displayMode == "both") {
      return englishBook;
    }

    const teluguBooks = {
      // Old Testament
      "Genesis": "ఆదికాండము", "Exodus": "నిర్గమకాండము",
      "Leviticus": "లేవీయకాండము",
      "Numbers": "సంఖ్యాకాండము", "Deuteronomy": "ద్వితీయోపదేశకాండము",
      "Joshua": "యెహోషువ",
      "Judges": "న్యాయాధిపతులు", "Ruth": "రూతు", "1 Samuel": "1 సమూయేలు",
      "2 Samuel": "2 సమూయేలు", "1 Kings": "1 రాజులు", "2 Kings": "2 రాజులు",
      "1 Chronicles": "1 దినవృత్తాంతములు", "2 Chronicles": "2 దినవృత్తాంతములు",
      "Ezra": "ఎజ్రా", "Nehemiah": "నెహెమ్యా", "Esther": "ఎస్తేరు",
      "Job": "యోబు",
      "Psalms": "కీర్తనలు", "Proverbs": "సామెతలు", "Ecclesiastes": "ప్రసంగి",
      "Song of Solomon": "పరమగీతము", "Isaiah": "యెషయా", "Jeremiah": "యిర్మీయా",
      "Lamentations": "విలాపవాక్యములు", "Ezekiel": "యెహెజ్కేలు",
      "Daniel": "దానియేలు",
      "Hosea": "హోషేయ", "Joel": "యోవేలు", "Amos": "ఆమోసు", "Obadiah": "ఓబద్యా",
      "Jonah": "యోనా", "Micah": "మీకా", "Nahum": "నహూము",
      "Habakkuk": "హబక్కూకు",
      "Zephaniah": "జెఫన్యా", "Haggai": "హగ్గయి", "Zechariah": "జెకర్యా",
      "Malachi": "మలాకీ",

      // New Testament
      "Matthew": "మత్తయి", "Mark": "మార్కు", "Luke": "లూకా", "John": "యోహాను",
      "Acts": "అపొస్తలుల కార్యములు", "Romans": "రోమీయులకు",
      "1 Corinthians": "1 కొరింథీయులకు",
      "2 Corinthians": "2 కొరింథీయులకు", "Galatians": "గలతీయులకు",
      "Ephesians": "ఎఫెసీయులకు",
      "Philippians": "ఫిలిప్పీయులకు", "Colossians": "కొలస్సీయులకు",
      "1 Thessalonians": "1 థెస్సలొనీకయులకు",
      "2 Thessalonians": "2 థెస్సలొనీకయులకు",
      "1 Timothy": "1 తిమోతికి", "2 Timothy": "2 తిమోతికి", "Titus": "తీతుకు",
      "Philemon": "ఫిలేమోనుకు", "Hebrews": "హెబ్రీయులకు", "James": "యాకోబు",
      "1 Peter": "1 పేతురు", "2 Peter": "2 పేతురు", "1 John": "1 యోహాను",
      "2 John": "2 యోహాను", "3 John": "3 యోహాను", "Jude": "యూదా",
      "Revelation": "ప్రకటన"
    };

    return teluguBooks[englishBook] ?? englishBook;
  }

  // 🧠 NEW: Dynamically grabs the verse text in the currently toggled language
  String _getDynamicVerse(String book, int chapter, int verseNum) {
    String displayBook =
        widget.book.trim(); // (or book.trim() if you are in _getDynamicVerse)
    if (displayBook.isNotEmpty) {
      displayBook =
          displayBook[0].toUpperCase() + displayBook.substring(1).toLowerCase();
    }

    String lookupBook = _getCorrectedBookName(displayBook);
    final verses = BibleData.getVerses(
        lookupBook, widget.chapter); // (or chapter if in _getDynamicVerse)

    print(
        "👀 DEBUG CHECK: Book = '$lookupBook', Chapter = '${widget.chapter}', Verses Found = ${verses.length}");

    // Find the specific verse we bookmarked/noted
    final verseData = verses.firstWhere(
        (v) => int.parse(v['v'].toString()) == verseNum,
        orElse: () => <String, dynamic>{});

    if (verseData.isEmpty) return "Verse not found";

    final eng = verseData['text']?.toString() ?? "";
    final tel =
        verseData['tel']?.toString() ?? "Telugu translation unavailable";

    if (_displayMode == "telugu") return tel;
    if (_displayMode == "english") return eng;
    return "$eng\n$tel"; // If they have "both" selected, show both!
  }

  void _showBookmarksSheet(BuildContext context) async {
    final allBookmarks = await isar.savedItems
        .filter()
        .typeEqualTo("bookmark")
        .sortByCreatedAtDesc()
        .findAll();
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        if (allBookmarks.isEmpty) {
          return const Center(child: Text("No bookmarks yet."));
        }
        return Column(
          children: [
            // Header row with the Clear All button
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 16.0, top: 16.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Bookmarks",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    label: const Text("Clear All",
                        style: TextStyle(color: Colors.red)),
                    onPressed: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Clear All Bookmarks?"),
                          content: const Text(
                              "Are you sure? This action cannot be undone."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Clear All",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );

// If they click "Clear All", wipe the database and close the sheet
                      if (confirm == true) {
                        await isar.writeTxn(() async {
                          await isar.savedItems
                              .filter()
                              .typeEqualTo("bookmark")
                              .deleteAll();
                        });

                        // 👇 THE MAGIC FIX: Clear the local memory instantly!
                        setState(() {
                          _bookmarks.clear();
                        });

                        if (context.mounted) {
                          Navigator.pop(context); // Close the bottom sheet
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("All bookmarks cleared.")),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // The existing list of bookmarks
            Expanded(
              child: ListView.builder(
                itemCount: allBookmarks.length,
                itemBuilder: (context, index) {
                  final bookmark = allBookmarks[index];
                  final dynamicVerse = _getDynamicVerse(
                      bookmark.book, bookmark.chapter, bookmark.verse);

                  String formattedDate = "";
                  if (bookmark.createdAt != null) {
                    final d = bookmark.createdAt!;
                    final month = d.month.toString().padLeft(2, '0');
                    final day = d.day.toString().padLeft(2, '0');
                    final hour =
                        d.hour == 0 ? 12 : (d.hour > 12 ? d.hour - 12 : d.hour);
                    final amPm = d.hour >= 12 ? "PM" : "AM";
                    final minute = d.minute.toString().padLeft(2, '0');
                    formattedDate =
                        "$month/$day/${d.year} at $hour:$minute $amPm";
                  }

                  return ListTile(
                    leading: const Icon(Icons.bookmark, color: Colors.blue),
                    title: Text(
                        '${_getTranslatedBookName(bookmark.book)} ${bookmark.chapter}:${bookmark.verse}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (formattedDate.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 2.0, bottom: 4.0),
                            child: Text(
                              formattedDate,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        Text(dynamicVerse,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      widget.onNavigate(
                          bookmark.book, bookmark.chapter, bookmark.verse);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNotesSheet(BuildContext context) async {
    // 👇 CHANGED: Now pulling "note" types instead of bookmarks
    final allNotes = await isar.savedItems
        .filter()
        .typeEqualTo("note")
        .sortByCreatedAtDesc()
        .findAll();
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        if (allNotes.isEmpty) {
          return const Center(child: Text("No notes yet."));
        }
        return Column(
          children: [
            // 👇 NEW: Header row with the Clear All button for Notes
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 16.0, top: 16.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Notes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    label: const Text("Clear All",
                        style: TextStyle(color: Colors.red)),
                    onPressed: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Clear All Notes?"),
                          content: const Text(
                              "Are you sure? This action cannot be undone."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Clear All",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );

                      // If they click "Clear All", wipe the notes database and close the sheet
                      if (confirm == true) {
                        await isar.writeTxn(() async {
                          await isar.savedItems
                              .filter()
                              .typeEqualTo("note")
                              .deleteAll();
                        });

                        // 👇 THE MAGIC FIX: Clear the local notes memory instantly!
                        setState(() {
                          _notes.clear();
                        });

                        if (context.mounted) {
                          Navigator.pop(context); // Close the bottom sheet
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("All notes cleared.")),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // The list of Notes
            Expanded(
              child: ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (context, index) {
                  final note = allNotes[index];
                  final dynamicVerse =
                      _getDynamicVerse(note.book, note.chapter, note.verse);

                  // Formatting the date nicely
                  String formattedDate = "";
                  if (note.createdAt != null) {
                    final d = note.createdAt!;
                    final month = d.month.toString().padLeft(2, '0');
                    final day = d.day.toString().padLeft(2, '0');
                    final hour =
                        d.hour == 0 ? 12 : (d.hour > 12 ? d.hour - 12 : d.hour);
                    final amPm = d.hour >= 12 ? "PM" : "AM";
                    final minute = d.minute.toString().padLeft(2, '0');
                    formattedDate =
                        "$month/$day/${d.year} at $hour:$minute $amPm";
                  }

                  return ListTile(
                    // 👇 CHANGED: Using a distinct note icon
                    leading: const Icon(Icons.edit_note, color: Colors.orange),
                    title: Text(
                        '${_getTranslatedBookName(note.book)} ${note.chapter}:${note.verse}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (formattedDate.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 2.0, bottom: 4.0),
                            child: Text(
                              formattedDate,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        // Displays the actual note content!
                        // (Assuming your Isar model uses 'content' for the note text)
                        if (note.content != null && note.content!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              '"${note.content}"',
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        // The actual bible verse text
                        Text(dynamicVerse,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      widget.onNavigate(note.book, note.chapter, note.verse);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppBarAction(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        // 👇 THE FIX: Forces every button to be at least 46 pixels wide.
        // This spreads the icons out beautifully when text is OFF!
        constraints: const BoxConstraints(minWidth: 46),
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: _showIconLabels ? 20 : 24),
            if (_showIconLabels) ...[
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                    color: color, fontSize: 9, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayBook = widget.book.trim();
    if (displayBook.isNotEmpty) {
      displayBook =
          displayBook[0].toUpperCase() + displayBook.substring(1).toLowerCase();
    }

    String lookupBook = _getCorrectedBookName(displayBook);
    final verses = BibleData.getVerses(lookupBook, widget.chapter);

    final activeBgColor = _isCustomTheme
        ? _customBgColor
        : (_themes[_selectedThemeIndex]["bg"] as Color? ??
            Theme.of(context).scaffoldBackgroundColor);
    final activeTextColor = _isCustomTheme
        ? _customTextColor
        : (_themes[_selectedThemeIndex]["text"] as Color? ??
            Theme.of(context).textTheme.bodyMedium?.color ??
            Colors.black);

    // Calculate the exact height of the top area
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double totalTopHeight = statusBarHeight + kToolbarHeight;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      color: activeBgColor,
      child: AnimatedTheme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: activeTextColor,
                displayColor: activeTextColor,
              ),
        ),
        duration: const Duration(milliseconds: 400),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (!globalAutoHideSetting.value) return false;

              if (notification.direction == ScrollDirection.reverse) {
                if (globalIsUIVisible.value) globalIsUIVisible.value = false;
              } else if (notification.direction == ScrollDirection.forward) {
                if (!globalIsUIVisible.value) globalIsUIVisible.value = true;
              }
              return false;
            },
            child: Stack(
              children: [
                // -------------------------------------------------------------
                // 1. THE TEXT (MAIN CONTENT)
                // -------------------------------------------------------------
                Positioned.fill(
                  child: verses.isEmpty
                      ? _buildEmptyState(displayBook, widget.chapter)
                      : GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              _fontSize = 18.0;
                            });
                            _saveSettings();
                          },
                          onScaleStart: (details) {
                            _baseFontSize = _fontSize;
                          },
                          onScaleUpdate: (details) {
                            setState(() {
                              _fontSize = (_baseFontSize * details.scale)
                                  .clamp(14.0, 36.0);
                            });
                          },
                          onScaleEnd: (details) {
                            _saveSettings();
                          },
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity != null &&
                                details.primaryVelocity! < -300) {
                              _goToNextChapter();
                            } else if (details.primaryVelocity != null &&
                                details.primaryVelocity! > 300) {
                              _goToPrevChapter();
                            }
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: SingleChildScrollView(
                              key: ValueKey("${widget.book}_${widget.chapter}"),
                              padding: EdgeInsets.fromLTRB(
                                  16, totalTopHeight + 10, 16, 120),
                              child: Column(
                                children: List.generate(verses.length, (index) {
                                  final v = verses[index];
                                  final isExpanded =
                                      _expandedVerseIndex == index;

                                  int verseNum = int.parse(v['v'].toString());

                                  // 🎯 Unified true verse mapping strategy
                                  final highlightColor = _highlights[verseNum];
                                  final isBookmarked =
                                      _bookmarks.contains(verseNum);
                                  final hasNote = _notes.containsKey(verseNum);

                                  if (!_verseKeys.containsKey(verseNum)) {
                                    _verseKeys[verseNum] = GlobalKey();
                                  }

                                  return Column(
                                    key: _verseKeys[verseNum],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          _triggerVerseFlash(index);
                                          setState(() => _expandedVerseIndex =
                                              isExpanded ? null : index);
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 350),
                                          curve: Curves.easeOut,
                                          decoration: BoxDecoration(
                                            color: _flashedVerseIndex == index
                                                ? Theme.of(context)
                                                    .primaryColor
                                                    .withValues(alpha: 0.3)
                                                : (highlightColor ??
                                                    Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 8.0),
                                            child: _PremiumVerseItem(
                                              verseNum: v['v'].toString(),
                                              englishText:
                                                  _displayMode == "telugu"
                                                      ? ""
                                                      : v['text'],
                                              teluguText: _displayMode ==
                                                      "english"
                                                  ? ""
                                                  : (v['tel'] ??
                                                      "Telugu translation unavailable"),
                                              onPlay: () =>
                                                  _showAudioLanguageDialog(
                                                      index, verses),
                                              fontSize: _fontSize,
                                              isBookmarked: isBookmarked,
                                              hasNote: hasNote,
                                            ),
                                          ),
                                        ),
                                      ),
                                      AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        curve: Curves.easeOutBack,
                                        alignment: Alignment.topCenter,
                                        child: isExpanded
                                            ? _buildInlineMenu(index, v)
                                            : const SizedBox(
                                                width: double.infinity,
                                                height: 0),
                                      ),
                                    ],
                                  );
                                }), // List.generate
                              ), // Column
                            ), // SingleChildScrollView
                          ), // AnimatedSwitcher
                        ), // GestureDetector
                ), // Positioned.fill

                // -------------------------------------------------------------
                // 2. THE ANIMATED FLOATING APP BAR
                // -------------------------------------------------------------
                ValueListenableBuilder<bool>(
                  valueListenable: globalIsUIVisible,
                  builder: (context, isVisible, child) {
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      top: isVisible ? 0 : -totalTopHeight,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: totalTopHeight,
                        padding: EdgeInsets.only(top: statusBarHeight),
                        decoration: BoxDecoration(
                          color: activeBgColor.withValues(alpha: 0.98),
                          boxShadow: isVisible
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : [],
                        ),
                        child: AppBar(
                          primary:
                              false, // 🌟 THIS FIXES THE OVERFLOW & IPHONE BUG!
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          centerTitle: false,
                          titleSpacing: _showIconLabels ? 0.0 : 16.0,
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new,
                                size: 20, color: activeTextColor),
                            onPressed: widget.onBack,
                          ),
                          title: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => _showBookPicker(context),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${_getTranslatedBookName(displayBook)} ${widget.chapter}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.5,
                                        color: activeTextColor),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.keyboard_arrow_down,
                                      size: 24, color: activeTextColor),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            _buildAppBarAction(
                                Icons.translate, "Language", activeTextColor,
                                () {
                              setState(() {
                                if (_displayMode == "both") {
                                  _displayMode = "english";
                                } else if (_displayMode == "english") {
                                  _displayMode = "telugu";
                                } else {
                                  _displayMode = "both";
                                }
                              });
                              _saveSettings();
                            }),
                            _buildAppBarAction(
                                Icons.bookmarks_outlined,
                                "Bookmarks",
                                activeTextColor,
                                () => _showBookmarksSheet(context)),
                            _buildAppBarAction(
                                Icons.notes,
                                "Notes",
                                activeTextColor,
                                () => _showNotesSheet(context)),
                            _buildAppBarAction(Icons.text_fields, "Size",
                                activeTextColor, _showFontSettings),
                            _buildAppBarAction(
                                Icons.text_format,
                                "Theme",
                                activeTextColor,
                                () => _showAppearanceMenu(context)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumVerseItem extends StatelessWidget {
  final String verseNum;
  final String englishText;
  final String teluguText;
  final VoidCallback onPlay;
  final double fontSize;
  final bool isBookmarked;
  final bool hasNote;

  const _PremiumVerseItem({
    super.key,
    required this.verseNum,
    required this.englishText,
    required this.teluguText,
    required this.onPlay,
    required this.fontSize,
    required this.isBookmarked,
    required this.hasNote,
  });

  @override
  Widget build(BuildContext context) {
    // The magic math: This makes the icons scale up and down with your text size!
    final double dynamicIconSize = fontSize * 0.8;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1️⃣ Left Column: Verse Number AND Indicators
        Container(
          margin: const EdgeInsets.only(right: 16, top: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Hugs the items tightly
            children: [
              // The Verse Number Box
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    verseNum,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // 👇 THE NEW PLAY BUTTON! (Right under the verse number)
              GestureDetector(
                onTap: onPlay,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.volume_up, // 👈 Volume/Play icon
                    size: 22,
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.7),
                  ),
                ),
              ),

              // The Badges are now safely tucked under the play button!
              if (isBookmarked || hasNote) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasNote)
                      Icon(Icons.sticky_note_2,
                          size: dynamicIconSize, color: Colors.green),
                    if (hasNote && isBookmarked) const SizedBox(width: 4),
                    if (isBookmarked)
                      Icon(Icons.bookmark,
                          size: dynamicIconSize, color: Colors.blue),
                  ],
                ),
              ]
            ],
          ),
        ),

        // 2️⃣ Verse Text Column (Safely out of the way on the right!)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (englishText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    englishText,
                    style: TextStyle(
                      fontSize: fontSize,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              if (teluguText.isNotEmpty)
                Text(
                  teluguText,
                  style: TextStyle(
                    fontSize: fontSize - 1,
                    height: 1.8,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- PREMIUM BOOK, CHAPTER, & VERSE PICKER MENU ---
class _BookChapterPicker extends StatefulWidget {
  final Function(String, int, int) onSelect;
  final String displayMode; // 👈 Accepts the language mode

  const _BookChapterPicker({required this.onSelect, required this.displayMode});

  @override
  State<_BookChapterPicker> createState() => _BookChapterPickerState();
}

class _BookChapterPickerState extends State<_BookChapterPicker> {
  final PageController _pageController = PageController();

  final Map<String, int> bibleBooks = {
    "Genesis": 50,
    "Exodus": 40,
    "Leviticus": 27,
    "Numbers": 36,
    "Deuteronomy": 34,
    "Joshua": 24,
    "Judges": 21,
    "Ruth": 4,
    "1 Samuel": 31,
    "2 Samuel": 24,
    "1 Kings": 22,
    "2 Kings": 25,
    "1 Chronicles": 29,
    "2 Chronicles": 36,
    "Ezra": 10,
    "Nehemiah": 13,
    "Esther": 10,
    "Job": 42,
    "Psalms": 150,
    "Proverbs": 31,
    "Ecclesiastes": 12,
    "Song of Solomon": 8,
    "Isaiah": 66,
    "Jeremiah": 52,
    "Lamentations": 5,
    "Ezekiel": 48,
    "Daniel": 12,
    "Hosea": 14,
    "Joel": 3,
    "Amos": 9,
    "Obadiah": 1,
    "Jonah": 4,
    "Micah": 7,
    "Nahum": 3,
    "Habakkuk": 3,
    "Zephaniah": 3,
    "Haggai": 2,
    "Zechariah": 14,
    "Malachi": 4,
    "Matthew": 28,
    "Mark": 16,
    "Luke": 24,
    "John": 21,
    "Acts": 28,
    "Romans": 16,
    "1 Corinthians": 16,
    "2 Corinthians": 13,
    "Galatians": 6,
    "Ephesians": 6,
    "Philippians": 4,
    "Colossians": 4,
    "1 Thessalonians": 5,
    "2 Thessalonians": 3,
    "1 Timothy": 6,
    "2 Timothy": 4,
    "Titus": 3,
    "Philemon": 1,
    "Hebrews": 13,
    "James": 5,
    "1 Peter": 5,
    "2 Peter": 3,
    "1 John": 5,
    "2 John": 1,
    "3 John": 1,
    "Jude": 1,
    "Revelation": 22
  };

  String? selectedBook;
  int? selectedChapter;

  // 🌍 THE FULL 66-BOOK DICTIONARY (Now safely inside the Picker!)
  String _getTranslatedBookName(String englishBook) {
    if (widget.displayMode == "english" || widget.displayMode == "both") {
      return englishBook;
    }

    const teluguBooks = {
      "Genesis": "ఆదికాండము",
      "Exodus": "నిర్గమకాండము",
      "Leviticus": "లేవీయకాండము",
      "Numbers": "సంఖ్యాకాండము",
      "Deuteronomy": "ద్వితీయోపదేశకాండము",
      "Joshua": "యెహోషువ",
      "Judges": "న్యాయాధిపతులు",
      "Ruth": "రూతు",
      "1 Samuel": "1 సమూయేలు",
      "2 Samuel": "2 సమూయేలు",
      "1 Kings": "1 రాజులు",
      "2 Kings": "2 రాజులు",
      "1 Chronicles": "1 దినవృత్తాంతములు",
      "2 Chronicles": "2 దినవృత్తాంతములు",
      "Ezra": "ఎజ్రా",
      "Nehemiah": "నెహెమ్యా",
      "Esther": "ఎస్తేరు",
      "Job": "యోబు",
      "Psalms": "కీర్తనలు",
      "Proverbs": "సామెతలు",
      "Ecclesiastes": "ప్రసంగి",
      "Song of Solomon": "పరమగీతము",
      "Isaiah": "యెషయా",
      "Jeremiah": "యిర్మీయా",
      "Lamentations": "విలాపవాక్యములు",
      "Ezekiel": "యెహెజ్కేలు",
      "Daniel": "దానియేలు",
      "Hosea": "హోషేయ",
      "Joel": "యోవేలు",
      "Amos": "ఆమోసు",
      "Obadiah": "ఓబద్యా",
      "Jonah": "యోనా",
      "Micah": "మీకా",
      "Nahum": "నహూము",
      "Habakkuk": "హబక్కూకు",
      "Zephaniah": "జెఫన్యా",
      "Haggai": "హగ్గయి",
      "Zechariah": "జెకర్యా",
      "Malachi": "మలాకీ",
      "Matthew": "మత్తయి",
      "Mark": "మార్కు",
      "Luke": "లూకా",
      "John": "యోహాను",
      "Acts": "అపొస్తలుల కార్యములు",
      "Romans": "రోమీయులకు",
      "1 Corinthians": "1 కొరింథీయులకు",
      "2 Corinthians": "2 కొరింథీయులకు",
      "Galatians": "గలతీయులకు",
      "Ephesians": "ఎఫెసీయులకు",
      "Philippians": "ఫిలిప్పీయులకు",
      "Colossians": "కొలస్సీయులకు",
      "1 Thessalonians": "1 థెస్సలొనీకయులకు",
      "2 Thessalonians": "2 థెస్సలొనీకయులకు",
      "1 Timothy": "1 తిమోతికి",
      "2 Timothy": "2 తిమోతికి",
      "Titus": "తీతుకు",
      "Philemon": "ఫిలేమోనుకు",
      "Hebrews": "హెబ్రీయులకు",
      "James": "యాకోబు",
      "1 Peter": "1 పేతురు",
      "2 Peter": "2 పేతురు",
      "1 John": "1 యోహాను",
      "2 John": "2 యోహాను",
      "3 John": "3 యోహాను",
      "Jude": "యూదా",
      "Revelation": "ప్రకటన"
    };

    return teluguBooks[englishBook] ?? englishBook;
  }

  void _slideMenu(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _handleBack() {
    if (selectedChapter != null) {
      setState(() => selectedChapter = null);
      _slideMenu(1);
    } else if (selectedBook != null) {
      setState(() => selectedBook = null);
      _slideMenu(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    String headerTitle = widget.displayMode == "telugu"
        ? "పుస్తకాన్ని ఎంచుకోండి"
        : "Select Book";
    if (selectedBook != null && selectedChapter == null) {
      headerTitle = _getTranslatedBookName(selectedBook!);
    }
    if (selectedBook != null && selectedChapter != null) {
      headerTitle = "${_getTranslatedBookName(selectedBook!)} $selectedChapter";
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // --- HEADER ---
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 60,
                  child: selectedBook != null
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                          onPressed: _handleBack,
                          splashRadius: 24,
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      headerTitle,
                      key: ValueKey(headerTitle),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    splashRadius: 24,
                  ),
                ),
              ],
            ),
          ),

          // --- BODY (SLIDING PAGES) ---
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // PAGE 0: BOOKS LIST (Split OT and NT)
                Row(
                  children: [
                    // LEFT SIDE: Old Testament (First 39 books)
                    Expanded(
                      child: _buildTestamentList(
                        widget.displayMode == "telugu"
                            ? "పాత నిబంధన"
                            : "Old Testament",
                        bibleBooks.keys.take(39).toList(),
                      ),
                    ),

                    // Center Divider
                    Container(
                        width: 1, color: Colors.grey.withValues(alpha: 0.2)),

                    // RIGHT SIDE: New Testament (Remaining 27 books)
                    Expanded(
                      child: _buildTestamentList(
                        widget.displayMode == "telugu"
                            ? "క్రొత్త నిబంధన"
                            : "New Testament",
                        bibleBooks.keys.skip(39).toList(),
                      ),
                    ),
                  ],
                ),

                // PAGE 1: CHAPTERS GRID WITH HEADER
                if (selectedBook != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, top: 24.0, bottom: 8.0),
                        child: Text(
                          widget.displayMode == "telugu"
                              ? "అధ్యాయాన్ని ఎంచుకోండి"
                              : "Select Chapter",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).primaryColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: bibleBooks[selectedBook]!,
                          itemBuilder: (context, index) {
                            int chapterNum = index + 1;
                            return _buildPremiumGridItem(
                              text: chapterNum.toString(),
                              onTap: () {
                                setState(() => selectedChapter = chapterNum);
                                _slideMenu(2);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(),

                // PAGE 2: VERSES GRID WITH HEADER
                if (selectedBook != null && selectedChapter != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, top: 24.0, bottom: 8.0),
                        child: Text(
                          widget.displayMode == "telugu"
                              ? "వచనాన్ని ఎంచుకోండి"
                              : "Select Verse",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).primaryColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildVersesGrid(context),
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestamentList(String title, List<String> books) {
    return Column(
      children: [
        // Testament Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        // Books List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: books.length,
            itemBuilder: (context, index) {
              String englishBookName = books[index];
              String displayBookName = _getTranslatedBookName(englishBookName);

              return InkWell(
                onTap: () {
                  setState(() => selectedBook = englishBookName);
                  _slideMenu(1);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 14.0),
                  child: Text(
                    displayBookName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumGridItem(
      {required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVersesGrid(BuildContext context) {
    String lookupBook =
        selectedBook == "Song of Solomon" ? "Solomon's Song" : selectedBook!;
    final verses = BibleData.getVerses(lookupBook, selectedChapter!);
    int verseCount = verses.length;

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: verseCount,
      itemBuilder: (context, index) {
        // 🚨 THE FIX: Read the REAL verse number from the JSON database!
        int actualVerseNum = int.parse(verses[index]['v'].toString());

        return _buildPremiumGridItem(
          text: actualVerseNum.toString(), // 👈 Now it displays the true number
          onTap: () =>
              widget.onSelect(selectedBook!, selectedChapter!, actualVerseNum),
        );
      },
    );
  }
}

// ==============================================================================
// 7. SETTINGS / LIBRARY TAB (With RENAME & EDIT)
// ==============================================================================

class SettingsTab extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;
  final void Function(String, int, [int?]) onNavigate;
  const SettingsTab(
      {super.key,
      required this.themeMode,
      required this.toggleTheme,
      required this.onNavigate});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

// ==============================================================================
// 🌟 DEFAULT STARTUP TAB SETTING
// ==============================================================================
class DefaultTabSetting extends StatefulWidget {
  const DefaultTabSetting({super.key});

  @override
  State<DefaultTabSetting> createState() => _DefaultTabSettingState();
}

class _DefaultTabSettingState extends State<DefaultTabSetting> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPreference(); // 👈 This calls your function when the widget wakes up
  }

  // 🔴 PASTE YOUR CLEANED UP CODE RIGHT HERE:
  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTabIndex = prefs.getInt('default_startup_tab') ?? 0;
    });
  }

  Future<void> _savePreference(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('default_startup_tab', index);
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of dropdown options mapped to their translation keys
    final Map<int, String> tabOptions = {
      0: 'nav_home', // Home
      1: 'nav_read', // Read
      2: 'nav_plans', // Plans
      3: 'nav_search', // Search
    };

    // 🔄 Wraps the widget to force a complete rebuild whenever the global app language updates!
    return ValueListenableBuilder<String>(
      valueListenable: globalAppLanguage,
      builder: (context, currentLanguage, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child: const Icon(CupertinoIcons.device_phone_portrait,
                  color: Colors.teal, size: 20),
            ),
            title: Text(
              AppStrings.get(
                  'startup_tab'), // 🌍 Instantly Translates Main Title
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            subtitle: Text(
              AppStrings.get(
                  'startup_tab_subtitle'), // 🌍 Instantly Translates Subtitle
              style: const TextStyle(fontSize: 12),
            ),
            trailing: DropdownButton<int>(
              value: _selectedTabIndex,
              underline: const SizedBox(),
              icon: const Icon(CupertinoIcons.chevron_down,
                  size: 16, color: Colors.grey),
              items: tabOptions.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(AppStrings.get(
                      entry.value)), // 🌍 Instantly Translates Dropdown options
                );
              }).toList(),
              onChanged: (int? newIndex) {
                if (newIndex != null) {
                  _savePreference(newIndex);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class _SettingsTabState extends State<SettingsTab> {
  // 1. A variable to hold the user's name (defaults to "Enter Name" if empty)
  String _userName = "Enter Name";

  // Variable to hold screen awake setting
  bool _keepScreenOn = true;
  bool _showIconLabels = true;
  bool _notificationsEnabled = false;

  // Load the screen settings and username when the tab opens
  @override
  void initState() {
    super.initState();
    _loadScreenSetting();
  }

  Future<void> _loadScreenSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _keepScreenOn = prefs.getBool('keep_screen_on') ?? true;
      _showIconLabels = prefs.getBool('show_icon_labels') ?? true;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
      // Load the saved name, fallback to a friendly default string if not set yet
      _userName = prefs.getString('user_name') ?? "Enter Name";
    });
  }

  // 2. The function that pops up the editing box and saves the name permanently
  void _showRenameDialog() {
    TextEditingController nameController =
        TextEditingController(text: _userName == "Enter Name" ? "" : _userName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile Name"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter your name"),
            textCapitalization: TextCapitalization.words,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  setState(() {
                    _userName = newName;
                  });

                  // Write the updated name into phone storage memory
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('user_name', newName);
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

// ✍️ UPDATED IN-APP BETA FEEDBACK TERMINAL (VIA FORMSPARK)
  void _showFeedbackDialog() {
    String selectedTab = "Home";
    TextEditingController messageController = TextEditingController();
    bool isSending = false; // Tracks loading state

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.bug_report, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text("Submit Feedback"),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Where did you find the issue?",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedTab,
                          isExpanded: true,
                          items: ["Home", "Read", "Plans", "Search", "Settings"]
                              .map((tab) => DropdownMenuItem(
                                  value: tab, child: Text(tab)))
                              .toList(),
                          onChanged: isSending
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setDialogState(() => selectedTab = value);
                                  }
                                },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Describe the problem:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: messageController,
                      maxLines: 4,
                      enabled: !isSending,
                      decoration: InputDecoration(
                        hintText: "Type your message here...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSending ? null : () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: isSending
                      ? null
                      : () async {
                          final cleanMessage = messageController.text.trim();
                          if (cleanMessage.isEmpty) return;

                          // 1. Show a loading spinner inside the dialog
                          setDialogState(() {
                            isSending = true;
                          });

                          try {
                            // 2. Fire the network request straight to Formspark
                            final response = await http.post(
                              Uri.parse('https://submit-form.com/vYpaIWkut'),
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({
                                'userName': _userName,
                                'problemTab': selectedTab,
                                'message': cleanMessage,
                                'platform': Theme.of(context).platform ==
                                        TargetPlatform.iOS
                                    ? 'iOS'
                                    : 'Android',
                              }),
                            );

                            if (context.mounted) {
                              Navigator.pop(context); // Close dialog box

                              // 3. Show a sleek success notification toast/banner
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      '🎉 Feedback received! Thank you for helping build this beta.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            // Handle accidental network failure gracefully
                            setDialogState(() {
                              isSending = false;
                            });
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      '❌ Connection error. Please try again.'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                  child: isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text("Send",
                          style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // OUR LANGUAGE TOGGLE WIDGET
  Widget _buildLanguageToggle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle),
          child: const Icon(Icons.language, color: Colors.blue, size: 20),
        ),
        title: Text(AppStrings.get('settings'),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: const Text("App Language / అనువర్తన భాష",
            style: TextStyle(fontSize: 12)),
        trailing: DropdownButton<String>(
          value: globalAppLanguage.value,
          underline: const SizedBox(),
          icon: const Icon(CupertinoIcons.chevron_down,
              size: 16, color: Colors.grey),
          items: const [
            DropdownMenuItem(value: 'en', child: Text("English")),
            DropdownMenuItem(value: 'te', child: Text("తెలుగు")),
          ],
          onChanged: (String? newLang) async {
            if (newLang != null) {
              globalAppLanguage.value = newLang;
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('app_lang', newLang);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ---------------------------------------------------------
          // YOUR AWESOME CUSTOM PROFILE CARD
          // ---------------------------------------------------------
          GestureDetector(
            onTap: _showRenameDialog,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white, size: 30)),
                  const SizedBox(width: 16),
                  Text(_userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const Spacer(),
                  const Icon(Icons.edit, size: 20, color: Colors.grey)
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // MY STUFF SECTION
          // ---------------------------------------------------------
          _sectionHeader(AppStrings.get('my_stuff')),

          _buildItem(
            context,
            CupertinoIcons.book_fill,
            AppStrings.get('my_library'),
            AppStrings.get('history_bookmarks'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedTab(
                    onNavigate: (String book, int chapter, [int? verse]) {
                      Navigator.pop(context);
                      widget.onNavigate(book, chapter, verse);
                    },
                  ),
                ),
              );
            },
          ),

          _buildItem(context, CupertinoIcons.pencil_ellipsis_rectangle,
              AppStrings.get('notes'), AppStrings.get('view_notes'), onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const NotesListScreen()),
            );
          }),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // PREFERENCES SECTION
          // ---------------------------------------------------------
          _sectionHeader(AppStrings.get('preferences')),

          _buildLanguageToggle(),

          const DefaultTabSetting(),

          // Dark Mode Toggle
          _buildItem(
            context,
            CupertinoIcons.moon_fill,
            AppStrings.get('dark_mode'),
            "",
            trailing: CupertinoSwitch(
              activeTrackColor: Colors.blue,
              value: widget.themeMode == ThemeMode.dark,
              onChanged: (bool newValue) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isDarkMode', newValue);
                widget.toggleTheme();
              },
            ),
          ),

          // Screen Awake Toggle
          _buildItem(
            context,
            CupertinoIcons.lightbulb_fill,
            AppStrings.get('keep_screen_awake'), // 🌍 Translated Title
            AppStrings.get('screen_awake_subtitle'), // 🌍 Translated Subtitle
            color: Colors.orange,
            trailing: CupertinoSwitch(
              activeTrackColor: Colors.blue,
              value: _keepScreenOn,
              onChanged: (bool newValue) async {
                setState(() {
                  _keepScreenOn = newValue;
                });
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('keep_screen_on', newValue);

                if (newValue) {
                  WakelockPlus.enable();
                } else {
                  WakelockPlus.disable();
                }
              },
            ),
          ),

          // Toggle for App Bar Icon Labels
          _buildItem(
            context,
            CupertinoIcons.textbox,
            AppStrings.get('show_icon_labels'), // 🌍 Translated Title
            AppStrings.get('icon_labels_subtitle'), // 🌍 Translated Subtitle
            color: Colors.pink,
            trailing: CupertinoSwitch(
              activeTrackColor: Colors.blue,
              value: _showIconLabels,
              onChanged: (bool newValue) async {
                setState(() {
                  _showIconLabels = newValue;
                });
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('show_icon_labels', newValue);
              },
            ),
          ),

          // Immersive Reading Mode Toggle
          ValueListenableBuilder<bool>(
            valueListenable: globalAutoHideSetting,
            builder: (context, isAutoHideEnabled, child) {
              return _buildItem(
                context,
                CupertinoIcons.eye_slash_fill,
                AppStrings.get('immersive_reading'), // 🌍 Translated Title
                AppStrings.get('immersive_subtitle'), // 🌍 Translated Subtitle
                color: Colors.indigo,
                trailing: CupertinoSwitch(
                  activeTrackColor: Colors.blue,
                  value: isAutoHideEnabled,
                  onChanged: (bool newValue) async {
                    globalAutoHideSetting.value = newValue;

                    if (!newValue) {
                      globalIsUIVisible.value = true;
                    }

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('auto_hide_ui', newValue);
                  },
                ),
              );
            },
          ),

          // 🔔 COMPLETE DAILY NOTIFICATION ITEM
          _buildItem(
            context,
            CupertinoIcons.bell_fill,
            AppStrings.get('notifications'),
            _notificationsEnabled
                ? AppStrings.get(
                    'reminder_at_8') // 🌍 Translated Dynamic Switch Text
                : AppStrings.get(
                    'reminders_off'), // 🌍 Translated Dynamic Switch Text
            color: Colors.blue,
            trailing: CupertinoSwitch(
              activeTrackColor: Colors.blue,
              value: _notificationsEnabled,
              onChanged: (bool newValue) async {
                setState(() {
                  _notificationsEnabled = newValue;
                });

                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('notifications_enabled', newValue);

                if (newValue) {
                  await scheduleDailyVerseNotification();
                } else {
                  await cancelDailyNotifications();
                }
              },
            ),
          ),

          // ✍️ BETA FEEDBACK TOOL
          _buildItem(
            context,
            CupertinoIcons.chat_bubble_2_fill,
            AppStrings.get('send_feedback'), // 🌍 Translated Title
            AppStrings.get('feedback_subtitle'), // 🌍 Translated Subtitle
            color: Colors.green,
            onTap: _showFeedbackDialog,
          ),

// 🎯 FIXED: Now both the Tab Name and the Subtitle are fully dynamic!
          _buildItem(
            context,
            Icons.info_outline,
            AppStrings.get('how_to_use_title') ?? "How to Use & Tips",
            AppStrings.get('how_to_use_subtitle') ??
                "Gestures, custom searching, and share options",
            color: Colors.blueAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppInfoPage()),
              );
            },
          ),

          // Offline Versions Status
          _buildItem(
            context,
            CupertinoIcons.cloud_download_fill,
            AppStrings.get('offline_versions'),
            "KJV, Telugu BSI",
          ),

          const SizedBox(
              height: 100), // Gives breathing room from the bottom bar
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
    );
  }

  Widget _buildItem(
      BuildContext context, IconData icon, String title, String subtitle,
      {Widget? trailing, Color? color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: (color ?? Colors.grey).withValues(alpha: 0.1),
                shape: BoxShape.circle),
            child: Icon(icon, color: color ?? Colors.grey, size: 20),
          ),
          title: Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
          trailing: trailing ??
              const Icon(CupertinoIcons.chevron_right,
                  size: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

// ==============================================================================
// 🌟 PREMIUM AUDIO MINI-PLAYER
// ==============================================================================
class _AudioMiniPlayer extends StatelessWidget {
  final String verseTitle;
  final String language;
  final VoidCallback onStop;
  final VoidCallback onTap;

  // 👇 NEW: Slots to receive the speed variables
  final double playbackSpeed;
  final VoidCallback onSpeedToggle;

  const _AudioMiniPlayer({
    super.key,
    required this.verseTitle,
    required this.language,
    required this.onStop,
    required this.onTap,
    // 👇 NEW: Require them when building the player
    required this.playbackSpeed,
    required this.onSpeedToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 🎵 Animated-looking icon container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.volume_up_rounded, color: Colors.blue),
            ),
            const SizedBox(width: 12),

            // 📖 Verse Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Reading $verseTitle",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "$language Audio",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ⏩ NEW: Speed Toggle Button
            TextButton(
              onPressed: onSpeedToggle,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: Text(
                "${playbackSpeed}x",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.blue,
                ),
              ),
            ),

            // 🛑 Stop Button
            IconButton(
              icon: const Icon(Icons.stop_circle,
                  color: Colors.redAccent, size: 36),
              onPressed: onStop,
              tooltip: "Stop Audio",
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================================================================
// 10. NAV & UTILS
// ==============================================================================

class _GlassNavBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const _GlassNavBar({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 👇 1. Get the exact height of the phone's system navigation bar
    final bottomSafePadding = MediaQuery.paddingOf(context).bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            // 👇 2. REMOVED height: 90 completely!
            // 👇 3. Replaced it with dynamic padding so the icons shift up, but the glass stays down.
            padding: EdgeInsets.only(
              top: 10,
              bottom: bottomSafePadding > 0
                  ? bottomSafePadding + 5
                  : 15, // Adds just a tiny buffer above the swipe line
            ),
            decoration: BoxDecoration(
              color:
                  (isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF))
                      .withValues(alpha: 0.85),
              border: Border(
                  top: BorderSide(
                      color: isDark
                          ? Colors.white10
                          : Colors.black.withValues(alpha: 0.05))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _navItem(context, 0, CupertinoIcons.house_alt_fill,
                    AppStrings.get('nav_home') ?? "Home"),
                _navItem(context, 1, CupertinoIcons.book_fill,
                    AppStrings.get('nav_read') ?? "Read"),
                _navItem(context, 2, CupertinoIcons.check_mark_circled_solid,
                    AppStrings.get('nav_plans') ?? "Plans"),
                _navItem(context, 3, CupertinoIcons.search,
                    AppStrings.get('nav_search') ?? "Search"),
                _navItem(context, 4, CupertinoIcons.settings_solid,
                    AppStrings.get('nav_settings') ?? "Settings"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, int i, IconData icon, String label) {
    final isSelected = index == i;
    final color = isSelected
        ? AppTheme.primary
        : (Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[700]
            : Colors.grey[400]);

    return GestureDetector(
      onTap: () => onTap(i),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          // 👇 4. Added mainAxisSize.min so the column doesn't stretch infinitely
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================================================================
// 5. SAVED TAB (WITH KEEP-ALIVE TO PREVENT FREEZING)
// ==============================================================================

class SavedTab extends StatelessWidget {
  final void Function(String, int, [int?]) onNavigate;
  const SavedTab({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text("My Library",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : Colors.black87)),
          bottom: const TabBar(
            indicatorColor: AppTheme.primary,
            labelColor: AppTheme.primary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Bookmarks"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 🚀 We moved these into their own protected widgets!
            _BookmarksView(onNavigate: onNavigate),
            _HistoryView(onNavigate: onNavigate),
          ],
        ),
      ),
    );
  }
}

// 🕒 Global Formatting Helper
String _formatDate(DateTime? date) {
  if (date == null) return "Recent";
  final months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  final month = months[date.month - 1];
  int hour = date.hour;
  final amPm = hour >= 12 ? 'PM' : 'AM';
  if (hour == 0) hour = 12;
  if (hour > 12) hour -= 12;
  final minute = date.minute.toString().padLeft(2, '0');
  return "$month ${date.day} • $hour:$minute $amPm";
}

// ==============================================================================
// 🌟 BOOKMARKS VIEW (PROTECTED FROM DESTRUCTION)
// ==============================================================================
class _BookmarksView extends StatefulWidget {
  final void Function(String, int, [int?])
      onNavigate; // 👈 Updated to accept a verse!
  const _BookmarksView({required this.onNavigate});

  @override
  State<_BookmarksView> createState() => _BookmarksViewState();
}

// 🛡️ Notice the 'AutomaticKeepAliveClientMixin' here!
// 🛡️ Notice the 'AutomaticKeepAliveClientMixin' here!
class _BookmarksViewState extends State<_BookmarksView>
    with AutomaticKeepAliveClientMixin {
  late Stream<List<SavedItem>> _bookmarksStream;

  @override
  void initState() {
    super.initState();
    // 🚀 Stream the new SavedItem vault!
    _bookmarksStream = isar.savedItems
        .filter()
        .typeEqualTo("bookmark")
        .watch(fireImmediately: true);
  }

  @override
  bool get wantKeepAlive =>
      true; // 🛡️ This tells Flutter NEVER to destroy this tab

  Future<void> _deleteBookmark(int id) async {
    await isar.writeTxn(() async {
      // 👇 FIXED: Changed 'bookmarks' to 'savedItems'
      await isar.savedItems.delete(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 🛡️ Required for KeepAlive

    return Scaffold(
      body: StreamBuilder<List<SavedItem>>(
        stream: _bookmarksStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No bookmarks yet."));
          }

          final bookmarks = snapshot.data!.toList();

          // 👇 FIXED: Changed 'timestamp' to 'createdAt'
          bookmarks.sort((a, b) => (b.createdAt ?? DateTime.now())
              .compareTo(a.createdAt ?? DateTime.now()));

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 100),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final b = bookmarks[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                              "${b.book} ${b.chapter ?? 1}:${b.verse ?? 1}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary),
                              overflow: TextOverflow.ellipsis),
                        ),
                        IconButton(
                          icon: const Icon(CupertinoIcons.trash,
                              size: 18, color: Colors.redAccent),
                          onPressed: () => _deleteBookmark(b.id),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 👇 FIXED: Changed 'text' to 'content'
                    Text(b.content ?? "Verse text unavailable",
                        style: const TextStyle(fontSize: 18, height: 1.4)),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          // 👇 THE MAGIC HAPPENS RIGHT HERE! Added b.verse
                          onTap: () => widget.onNavigate(
                              b.book ?? 'Genesis', b.chapter ?? 1, b.verse),
                          child: const Text("Read Full Chapter →",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        ),
                        // 👇 FIXED: Changed 'timestamp' to 'createdAt'
                        Text(_formatDate(b.createdAt),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ==============================================================================
// 🌟 HISTORY VIEW (PROTECTED FROM DESTRUCTION)
// ==============================================================================
class _HistoryView extends StatefulWidget {
  final void Function(String, int, [int?]) onNavigate; // 👈 Updated to match!
  const _HistoryView({required this.onNavigate});

  @override
  State<_HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<_HistoryView>
    with AutomaticKeepAliveClientMixin {
  late Stream<List<HistoryLog>> _historyStream;

  @override
  bool get wantKeepAlive => true; // 🛡️ Keeps history alive

  @override
  void initState() {
    super.initState();
    _historyStream = isar.historyLogs.where().watch(fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 🛡️ Required for KeepAlive
    return StreamBuilder<List<HistoryLog>>(
      stream: _historyStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No history yet."));
        }

        final history = snapshot.data!.toList();
        try {
          history.sort((a, b) => b.readAt.compareTo(a.readAt));
        } catch (_) {}

        return ListView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 100),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final h = history[index];
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle),
                child: const Icon(CupertinoIcons.clock_fill,
                    color: AppTheme.primary),
              ),
              title: Text("${h.bookName} ${h.chapter}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(_formatDate(h.readAt)),
              trailing: const Icon(CupertinoIcons.chevron_right,
                  size: 18, color: Colors.grey),
              onTap: () => widget.onNavigate(h.bookName, h.chapter),
            );
          },
        );
      },
    );
  }
}
// ==============================================================================
// 4. LIBRARY TAB (BOOK & CHAPTER PICKER)
// ==============================================================================

class LibraryTab extends StatelessWidget {
  final void Function(String, int, [int?]) onNavigate;
  const LibraryTab({super.key, required this.onNavigate});

  // 📚 Mini-database of books and their chapter counts.
  // I've added a mix of Old and New Testament to start. You can fill in the rest!
  static const Map<String, int> bibleBooks = {
    "Genesis": 50,
    "Exodus": 40,
    "Psalms": 150,
    "Proverbs": 31,
    "Matthew": 28,
    "Mark": 16,
    "Luke": 24,
    "John": 21,
    "Acts": 28,
    "Romans": 16,
    "Philippians": 4,
    "Revelation": 22,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 80,
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
          elevation: 0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 20, bottom: 10),
            title: Text("Library",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    color: isDark ? Colors.white : Colors.black87)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                String bookName = bibleBooks.keys.elementAt(index);
                int chapterCount = bibleBooks.values.elementAt(index);

                return _buildBookTile(context, bookName, chapterCount, isDark);
              },
              childCount: bibleBooks.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
            child: SizedBox(height: 100)), // Bottom padding
      ],
    );
  }

  Widget _buildBookTile(
      BuildContext context, String bookName, int chapterCount, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      // Theme wrapper removes the ugly default borders from ExpansionTile
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.orange, // Matches your flame streak color
          collapsedIconColor: Colors.grey,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          title: Text(
            bookName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _buildChapterGrid(context, bookName, chapterCount, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterGrid(
      BuildContext context, String bookName, int chapterCount, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // 5 chapters per row looks great on mobile
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1, // Perfect squares
      ),
      itemCount: chapterCount,
      itemBuilder: (context, index) {
        final chapterNumber = index + 1;
        return InkWell(
          onTap: () {
            // 🚀 BOOM! Navigate to the ReaderTab with the selected book and chapter
            onNavigate(bookName, chapterNumber);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white10
                  : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "$chapterNumber",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==============================================================================
// 📝 REAL DATABASE NOTES SCREEN
// ==============================================================================
class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<SavedItem> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Load notes when screen opens
  }

  // 💾 FETCH NOTES FROM ISAR
  Future<void> _loadNotes() async {
    final notes = await isar.savedItems.filter().typeEqualTo("note").findAll();
    setState(() {
      _notes = notes;
    });
  }

  // ✏️ EDIT OR DELETE NOTE DIALOG
  void _showEditNoteDialog(SavedItem note) {
    TextEditingController noteCtrl = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: Text("Edit Note - ${note.book} ${note.chapter}:${note.verse}"),
        content: TextField(
            controller: noteCtrl,
            maxLines: 4,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          FilledButton(
              onPressed: () async {
                await isar.writeTxn(() async {
                  if (noteCtrl.text.trim().isEmpty) {
                    // If they cleared the text, delete the note entirely
                    await isar.savedItems.delete(note.id);
                  } else {
                    // Otherwise, update the content and save
                    note.content = noteCtrl.text.trim();
                    await isar.savedItems.put(note);
                  }
                });

                if (context.mounted) Navigator.pop(ctx);
                _loadNotes(); // 🔄 Refresh the list instantly!
              },
              child: const Text("Save")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Notes")),
      body: _notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.pencil_outline,
                      size: 50, color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text("No notes saved yet.",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text("${note.book} ${note.chapter}:${note.verse}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(note.content ?? "",
                          maxLines: 3, overflow: TextOverflow.ellipsis),
                    ),
                    trailing: const Icon(CupertinoIcons.pencil,
                        size: 20, color: Colors.grey),
                    onTap: () => _showEditNoteDialog(note), // 👈 Tap to edit!
                  ),
                );
              },
            ),
    );
  }
}

// 🌟 PREMIUM VERSE OF THE DAY CARD WIDGET
class DailyVerseCard extends StatelessWidget {
  final Map<String, dynamic>? dailyVerse;
  final String bookName;
  final int chapterNum;
  final String displayMode;
  final VoidCallback onShare;

  const DailyVerseCard({
    super.key,
    required this.dailyVerse,
    required this.bookName,
    required this.chapterNum,
    required this.displayMode,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyVerse == null) return const SizedBox.shrink();

    final String verseNum = dailyVerse!['v']?.toString() ?? "1";
    final String engText = dailyVerse!['text'] ?? "";
    final String telText = dailyVerse!['tel'] ?? "";

    // Determine what to show based on the active language mode
    final bool showEnglish =
        (displayMode == "english" || displayMode == "both");
    final bool showTelugu =
        (displayMode == "telugu" || displayMode == "both") &&
            telText.isNotEmpty &&
            telText != "Telugu translation unavailable";

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.indigo.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "VERSE OF THE DAY",
                    style: TextStyle(
                      color: Colors.amber.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white70, size: 20),
                onPressed: onShare,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // English Display
          if (showEnglish)
            Text(
              engText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
                fontStyle: (displayMode == "both")
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),

          // Subtle Divider for bilingual mode
          if (displayMode == "both" && showEnglish && showTelugu)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Colors.white24),
            ),

          // Telugu Display
          if (showTelugu)
            Text(
              telText,
              style: const TextStyle(
                color: Color(0xFFEEEEEE),
                fontSize: 17,
                height: 1.5,
              ),
            ),

          const SizedBox(height: 16),

          // Scripture Reference Tag
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$bookName $chapterNum:$verseNum",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  Future<void> _launchPrivacyPolicy() async {
    final Uri url = Uri.parse('https://www.termsfeed.com/live/70840a2b-57ec-43eb-9503-2689ca290188');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    final List<Map<String, dynamic>> features = [
      {
        'icon': Icons.zoom_in,
        'title': AppStrings.get('pinch_zoom_title') ?? "Pinch to Zoom",
        'desc': AppStrings.get('pinch_zoom_desc') ?? "Pinch fingers to resize text. Double tap to reset.",
        'color': Colors.blue,
      },
      {
        'icon': Icons.search,
        'title': AppStrings.get('adv_search_title') ?? "Advanced Search Scopes",
        'desc': AppStrings.get('adv_search_desc') ?? "Tap filter icons to narrow search down.",
        'color': Colors.green,
      },
      {
        'icon': Icons.share,
        'title': AppStrings.get('share_title') ?? "Sharing Options",
        'desc': AppStrings.get('share_desc') ?? "Tap a verse to copy text or build a graphic layout.",
        'color': Colors.orange,
      },
      {
        'icon': Icons.bookmark,
        'title': AppStrings.get('notes_title') ?? "Notes & Bookmarks",
        'desc': AppStrings.get('notes_desc') ?? "Add annotations instantly to your personal workspace.",
        'color': Colors.red,
      },
      {
        'icon': Icons.translate,
        'title': AppStrings.get('lang_title') ?? "Bilingual Support",
        'desc': AppStrings.get('lang_desc') ?? "Switch configurations between English and Telugu configurations dynamically.",
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('how_to_use_title') ?? "App Features & Tips"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            AppStrings.get('how_to_use_title') ?? "Get the Most Out of Your App",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.get('how_to_use_subtitle') ?? "Discover useful shortcuts and unique capabilities built right into your digital workspace layout.",
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          ...features.map((f) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (f['color'] as Color).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(f['icon'], color: f['color'], size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(f['desc'], style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor, height: 1.3)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),

          // 🎯 PRIVACY POLICY CARD
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: Colors.teal),
              title: const Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Read our data usage and privacy policy specifications"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _launchPrivacyPolicy,
            ),
          ),

          // 🎯 SUPPORT EMAIL SECURELY ANCHORED AT THE BOTTOM OF THE LIST
          const SizedBox(height: 40), 
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Need help? Contact Support",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  "shibley767@gmail.com",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 16), 
              ],
            ),
          ),
        ],
      ),
    );
  }
}