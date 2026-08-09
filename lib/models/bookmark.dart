import 'package:isar_community/isar.dart';

// This line tells Isar to generate the behind-the-scenes database code for this file
part 'bookmark.g.dart'; 

@collection
class Bookmark {
  Id id = Isar.autoIncrement; // This automatically gives every saved verse a unique ID number

  String? bookName;
  int? chapter;
  int? verseNumber;
  String? verseText;
  DateTime? savedAt;
}