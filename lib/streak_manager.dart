import 'package:shared_preferences/shared_preferences.dart';

class StreakManager {
  static late SharedPreferences _prefs;

  // 1. Load the preferences when the app starts
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _checkStreak(); // See if they lost their streak while they were gone
  }

  // 2. The magic math to check if they missed a day
  static void _checkStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final lastReadStr = _prefs.getString('last_read_date');
    int currentStreak = _prefs.getInt('current_streak') ?? 0;

    if (lastReadStr != null) {
      final lastRead = DateTime.parse(lastReadStr);
      final difference = today.difference(lastRead).inDays;

      // If more than 1 day has passed, the streak is broken 😭
      if (difference > 1) {
        _prefs.setInt('current_streak', 0);
      }
    }
  }

  // 3. Call this whenever they open a chapter!
  static Future<void> markReadToday() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final lastReadStr = _prefs.getString('last_read_date');
    int currentStreak = _prefs.getInt('current_streak') ?? 0;

    if (lastReadStr == null) {
      // First time ever reading!
      currentStreak = 1;
    } else {
      final lastRead = DateTime.parse(lastReadStr);
      final difference = today.difference(lastRead).inDays;

      if (difference == 1) {
        currentStreak++; // They read yesterday, streak goes up! 🚀
      } else if (difference > 1) {
        currentStreak = 1; // They missed a day, start over at 1
      }
      // If difference == 0, they already read today, so streak stays the same.
    }

    // Save the new data
    await _prefs.setString('last_read_date', today.toIso8601String());
    await _prefs.setInt('current_streak', currentStreak);
  }

  // 4. Get the current streak number for the UI
  static int get streak => _prefs.getInt('current_streak') ?? 0;
}
