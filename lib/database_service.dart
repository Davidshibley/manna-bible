import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'database_models.dart';

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = openDB();
  }

  // ==========================================
  // 1. INITIALIZATION
  // ==========================================
  Future<Isar> openDB() async {
    // Check if an instance is already open to avoid errors
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [
          VerseSchema,
          UserVerseDataSchema,
          HistoryEntrySchema
        ], // Add schemas here
        directory: dir.path,
        inspector:
            true, // Allows you to view the DB in the browser while debugging
      );
    }
    return Future.value(Isar.getInstance());
  }

  // ==========================================
  // 2. HISTORY LOG METHODS
  // ==========================================

  /// Call this when a user opens a chapter or makes a search
  Future<void> addHistoryEntry(String title, String type) async {
    final isar = await db;
    final newEntry = HistoryEntry()
      ..displayTitle = title
      ..actionType = type
      ..timestamp = DateTime.now();

    await isar.writeTxn(() async {
      await isar.historyEntrys.put(newEntry);
    });
  }

  /// Fetches the 20 most recent entries for the History UI
  Future<List<HistoryEntry>> getRecentHistory() async {
    final isar = await db;
    return await isar.historyEntrys
        .where()
        .sortByTimestampDesc()
        .limit(20)
        .findAll();
  }

  // ==========================================
  // 3. USER DATA METHODS (Bookmarks, Highlights, Notes)
  // ==========================================

  /// Gets or creates a user data entry for a specific verse
  Future<UserVerseData> _getUserDataOrCreate(Isar isar, String verseKey) async {
    final existingData = await isar.userVerseDatas
        .where()
        .verseIdKeyEqualTo(verseKey)
        .findFirst();

    if (existingData != null) return existingData;

    return UserVerseData()..verseIdKey = verseKey;
  }

  /// Toggles the bookmark status of a verse
  Future<void> toggleBookmark(String verseKey) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final data = await _getUserDataOrCreate(isar, verseKey);
      data.isBookmarked = !data.isBookmarked;
      data.updatedAt = DateTime.now();
      await isar.userVerseDatas.put(data);
    });
  }

  /// Saves or removes a highlight color (pass null to remove)
  Future<void> saveHighlight(String verseKey, String? hexColor) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final data = await _getUserDataOrCreate(isar, verseKey);
      data.highlightColorHex = hexColor;
      data.updatedAt = DateTime.now();
      await isar.userVerseDatas.put(data);
    });
  }

  /// Fetches all user data for a chapter so the UI can draw highlights/bookmarks
  Future<List<UserVerseData>> getUserDataForChapter(
      String bookName, int chapter) async {
    final isar = await db;
    // Example verseKey format: "Genesis_1_1"
    final prefix = "${bookName}_${chapter}_";

    return await isar.userVerseDatas
        .filter()
        .verseIdKeyStartsWith(prefix)
        .findAll();
  }
}
