import 'package:isar_community/isar.dart';

part 'database_models.g.dart'; // Isar will generate this file for you later

// ==========================================
// 1. THE BIBLE TEXT (Static, Read-Only)
// ==========================================
@collection
class Verse {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String bookName; // e.g., "Genesis"

  @Index()
  late short chapter;

  late short verseNumber;

  // IndexType.words makes this blazing fast for your Search Tab
  @Index(type: IndexType.value)
  late String textEnglish;

  @Index(type: IndexType.value)
  late String textTelugu;

  // A helper string to easily link UserData (e.g., "Genesis_1_1")
  @Index(unique: true)
  late String verseIdKey;
}

// ==========================================
// 2. USER DATA (Highlights, Notes, Bookmarks)
// ==========================================
@collection
class UserVerseData {
  Id id = Isar.autoIncrement;

  // This links directly to the Verse.verseIdKey
  @Index(unique: true)
  late String verseIdKey;

  bool isBookmarked = false;

  // Store the hex string of the color, e.g., "FFFF5252"
  String? highlightColorHex;

  String? noteText;

  // Useful for sorting notes by most recent
  DateTime updatedAt = DateTime.now();
}

// ==========================================
// 3. HISTORY LOG (Recent Chapters & Searches)
// ==========================================
@collection
class HistoryEntry {
  Id id = Isar.autoIncrement;

  // e.g., "John 3" or "Search: Grace"
  late String displayTitle;

  // e.g., "read" or "search" (helps the UI know what icon to show)
  late String actionType;

  // Indexed so we can easily sort by newest and limit to the last 20 items
  @Index()
  DateTime timestamp = DateTime.now();
}
