# Memento

**Memento** is a minimalist Android application built with Flutter that allows users to create a single note that remains visible as a beautiful floating bubble glass overlay.

The goal is to make it feel like a native Android feature rather than just another notes app.

## ✨ Features

- 📝 **Single persistent note** — Keep one important note readily accessible.
- 🪟 **Floating overlay** — Display the note above other applications.
- 🎨 **Glassmorphic UI** — Minimal, modern interface inspired by native Android design.
- ✏️ **In-place editing** — Tap the floating note to edit it without returning to the main app.
- 💾 **Persistent storage** — Note changes persist across app and overlay lifecycles.
- 🔄 **Cross-engine synchronization** — Main app and overlay stay synchronized even when one is inactive.
- 🫧 **Minimize to bubble** — Collapse the note into a draggable floating bubble.
- ↔️ **Draggable overlay** — Position the bubble anywhere on the screen.
- ↩️ **Restore from bubble** — Tap the bubble to bring the full note back.
- 📱 **Android-first** — Designed specifically around Android's floating overlay capabilities.

## 🛠️ Tech Stack

- **Flutter 3.44.8**
- **Dart 3.12.2**
- **Material 3**
- **Google Fonts**
- **Shared Preferences**
- **flutter_overlay_window 0.5.0**

## 🏗️ Architecture

Memento consists of two Flutter engine contexts:

```text
┌──────────────────────┐
│     Main Flutter     │
│       Engine         │
└──────────┬───────────┘
           │
           ▼
   Shared Preferences
           │
           ▼
┌──────────────────────┐
│    Overlay Flutter   │
│       Engine         │
└──────────────────────┘
````

`shared_preferences` is used as the persistent storage layer between the main application and the overlay engine.

This avoids sharing a Hive database between separate Flutter engines and eliminates the file-locking issues that can occur with dual-engine Hive access.

## 📂 Project Structure

```text
lib/
├── app
│   ├── app.dart
│   ├── routes.dart
│   └── theme.dart
├── core
│   ├── constants
│   │   ├── app_colors.dart
│   │   ├── app_radius.dart
│   │   ├── app_spacing.dart
│   │   └── app_strings.dart
│   └── services
│       ├── overlay_service.dart
│       └── storage_service.dart
├── features
│   ├── editor
│   │   └── editor_screen.dart
│   ├── home
│   │   └── home_screen.dart
│   ├── overlay
│   │   └── overlay_screen.dart
│   └── splash
│       └── splash_screen.dart
├── shared
│   └── widgets
│       ├── glass_toggle_card.dart
│       ├── note_card.dart
│       ├── overlay_bubble.dart
│       ├── overlay_editor_card.dart
│       ├── overlay_note_card.dart
│       └── primary_button.dart
└── main.dart
```

## 🚀 Getting Started

### Requirements

* Flutter 3.44.8+
* Dart 3.12.2+
* Android device or emulator
* Android overlay permission

### Installation

Clone the repository:

```bash
git clone https://github.com/MaswiliK/memento.git
cd memento
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## 📦 Release

Memento **v1.0.0** is available as a production APK.

### Build locally

```bash
flutter build apk --release
```

The generated APK can be found under:

```text
build/app/outputs/flutter-apk/app-release.apk
```

For ready-to-install releases, visit the repository's **Releases** section.

## 🔐 Permissions

Memento requires Android's **Display over other apps** permission to display the floating note.

The permission can be enabled from the application's settings when prompted.

## 🧪 Current Status

**Memento v1.0.0 — Released**

Core functionality is implemented and the release APK has been successfully built and tested on a physical Android device.

* [x] Main application UI
* [x] Note creation and editing
* [x] Persistent note storage
* [x] Floating overlay
* [x] Overlay editing
* [x] Main ↔ overlay synchronization
* [x] Draggable overlay
* [x] Minimize to bubble
* [x] Bubble restoration
* [x] Overlay visibility state synchronization
* [x] App launcher icon
* [x] Release APK
* [x] Physical device testing
* [ ] Battery optimization
* [ ] Performance profiling
* [ ] Storage usage profiling

## 🎯 Philosophy

Memento is intentionally simple.

Instead of becoming another full-featured notes application, it focuses on one idea:

> **Keep one important thing in sight.**

No folders.
No complicated note management.
No unnecessary features.

Just one note, always within reach.

## 📄 License

This project is currently for personal/development use.

````
