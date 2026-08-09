import 'package:isar_community/isar.dart';

part 'history_log.g.dart'; // This tells Flutter to generate the background magic

@collection
class HistoryLog {
  Id id = Isar.autoIncrement; // Automatically gives each log a unique ID

  late String bookName;
  late int chapter;
  late DateTime readAt; // The exact time they opened the chapter
}
