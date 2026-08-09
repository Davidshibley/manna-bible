# Manna Bible 📖

A free, offline-first Bible app for Android with English (KJV) and Telugu translations — built with Flutter and published on Google Play.

**[⬇️ Get it on Google Play](https://play.google.com/store/apps/details?id=com.shibleyapps.bible)**

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)
![Play Store](https://img.shields.io/badge/Google%20Play-Live-success?logo=googleplay&logoColor=white)

## Features

- **Two translations** — King James Version (English) and Telugu Bible, fully bundled for 100% offline reading
- **Bookmarks & saved verses** — save, organize, and revisit favorite passages
- **Reading history & streaks** — automatic history log and a streak tracker to encourage daily reading
- **Listen mode** — audio playback and text-to-speech so you can listen to scripture hands-free
- **Daily reminders** — local notifications to keep up your reading habit
- **Share verses** — send any verse to friends through the system share sheet
- **Reader-friendly** — keeps the screen awake while you read; fast verse navigation with smooth scrolling

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Local database | Isar (community fork, 16 KB page-size compliant) |
| Audio / TTS | audioplayers, flutter_tts |
| Notifications | flutter_local_notifications + timezone |
| Storage & prefs | shared_preferences, path_provider |
| Target platform | Android 16 (API 36), min SDK 24 |

## Screenshots

<!-- Add screenshots here, e.g.:
<p float="left">
  <img src="screenshots/home.png" width="200" />
  <img src="screenshots/reader.png" width="200" />
  <img src="screenshots/bookmarks.png" width="200" />
</p>
-->

*Coming soon*

## Building from source

```bash
flutter pub get
dart run build_runner build
flutter run
```

Release builds require your own signing configuration in `android/key.properties` (not included in this repo).

## Credits

- Bible text databases sourced from [godlytalias/Bible-Database](https://github.com/godlytalias/Bible-Database) (GPL-3.0), which extracts public-domain translations from Wordproject
- King James Version and the Telugu Bible translation are in the public domain

## License

Source code © David Shibley. Bible text data credits above.
