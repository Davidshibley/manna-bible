import 'package:isar_community/isar.dart';

// This line will show a red error at first—that is completely normal!
// We are going to generate this missing file in the next step.
part 'isar_models.g.dart';

@collection
class SavedVerse {
  Id id = Isar.autoIncrement; // Isar needs an ID for every saved item

  late String book;
  late int chapter;
  late int verseIndex;

  bool isBookmark = false;
  String?
      noteText; // The question mark means this can be empty if it's just a bookmark
}
