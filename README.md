# FocusSession for macOS ⏱️

A beautiful, native-feeling macOS focus timer built with Flutter. 

Inspired by the built-in Windows Clock Focus Sessions, this application brings a dedicated, distraction-free productivity timer straight to your Mac.

## ✨ Features
* **Native macOS Notifications:** Explicit permission handling and persistent alerts when your session finishes.
* **Responsive UI:** Clean, distraction-free interface that scales elegantly whether it's a small floating window or expanded.
* **Continuous Audio Alerts:** Custom looping alarm sounds when a session is complete.
* **Lightweight & Fast:** Built as a Universal macOS binary (Apple Silicon M-Series & Intel).

## 🚀 Installation 

1. Download the latest `FocusSession-macOS.dmg` release.
2. Open the `.dmg` file and drag **FocusSession** to your `Applications` folder.
3. Open the app from your Applications folder.

### ⚠️ Mac Security "Damaged App" Fix
Since this is an indie app not distributed through the Mac App Store, Apple's Gatekeeper might show a warning saying the app is *"damaged"* or *"cannot be opened"*. 

To fix this instantly, open your Mac's **Terminal** and enter this command to strip the quarantine attribute:
```bash
xattr -cr /Applications/FocusSession.app
```
Hit **Enter**, and the app will open perfectly!

## 💻 Development & Building from Source

To build and run this project locally, ensure you have [Flutter](https://flutter.dev/docs/get-started/install/macos) installed.

1. Clone this repository.
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app in debug mode:
   ```bash
   flutter run -d macos
   ```
4. Build a release `.app` bundle:
   ```bash
   flutter build macos --release
   ```

## 🛠️ Tech Stack
* **Framework:** [Flutter](https://flutter.dev/)
* **Audio:** `audioplayers` for loop management
* **Notifications:** `flutter_local_notifications` for native Darwin triggers
