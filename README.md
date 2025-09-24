# Jungle Power App (Flutter) — Read-only Customer Viewer

This project is an improved Flutter app skeleton branded for **Jungle Power**.
Includes Material 3 theming, responsive layout, caching (SharedPreferences),
searchable history, CSV export (writes to app documents directory), and UI polish.

How to run:
1. Ensure Flutter is installed and web support is enabled (if you want to run on the web).
2. From the project folder run:
   ```bash
   flutter pub get
   flutter run -d chrome  # or -d windows / -d android
   ```

Files to note:
- `lib/services/api_service.dart` — mock API plus simple SharedPreferences caching.
- `lib/screens/history_screen.dart` — searchable history and CSV export (writes file and shows path).
- `lib/main.dart` — top-level app, Material3, theme toggle, AppBar text 'Jungle Power'.

Generated: 2025-08-11T19:34:37.095150
