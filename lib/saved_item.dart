import 'package:isar_community/isar.dart';

// This line will have a red squiggly error at first. That is 100% normal!
part 'saved_item.g.dart';

@collection
class SavedItem {
  Id id =
      Isar.autoIncrement; // Automatically gives each item a unique ID number

  late String book; // e.g., "John"
  late int chapter; // e.g., 3
  late int verse; // e.g., 16

  late String type; // Will be either "bookmark", "highlight", or "note"

  late String
      content; // The actual note you typed, or the verse text you bookmarked

  late DateTime createdAt;

  // Added types and @ignore to ALL getters so Isar doesn't crash
  @ignore
  DateTime? get timestamp => null;

  @ignore
  String? get bookName => null;

  @ignore
  DateTime? get savedAt => null;

  @ignore
  int? get verseNumber => null;

  @ignore
  String? get verseText => null;

  @ignore
  String? get text => null;
}
