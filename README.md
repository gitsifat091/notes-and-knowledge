# Notes & Knowledge

A local-first Flutter notes and knowledge management app.

## Current MVP
- Create, edit, and delete notes
- Create nested folders and navigate between folder levels
- Search note titles, content, and tags
- Favorites and untagged filters
- Add comma-separated tags to notes
- Hive local persistence
- Light and dark Neumorphism-inspired themes

## Stack
- Flutter / Dart
- Provider
- Hive Flutter
- UUID and intl

## Run locally
1. Install Flutter SDK and configure an emulator or device.
2. Clone this repository and switch to `feat/flutter-notes-app`.
3. Run:
   ```bash
   flutter pub get
   flutter run
   ```

## Current limitations
The editor currently stores plain text, not rich-text document structure. Password locking/encryption, attachments, cloud sync, import/export, and automated tests are not included in this first MVP scaffold. Do not use it to store sensitive information until encryption is implemented and reviewed.

## Design direction
The app uses the repository's Neumorphism palette direction: soft raised surfaces, inset input wells, a consistent top-left light source, and distinct light/dark surface colors.
