# PlantCare Pro — Flutter App

> Full Flutter conversion of the React/Tailwind PlantCare Pro UI, matching the exact design, colors, and navigation structure.

---

## Project Structure

```
plantcare_flutter/
├── lib/
│   ├── main.dart                   ← App entry point + root navigator
│   ├── theme/
│   │   └── app_theme.dart          ← Colors & ThemeData (matches theme.css)
│   ├── models/
│   │   ├── models.dart             ← Plant, UserStats, Badge models
│   │   └── app_state.dart          ← ChangeNotifier app state
│   ├── screens/
│   │   ├── welcome_screen.dart     ← Welcome / onboarding
│   │   ├── login_screen.dart       ← Sign In / Sign Up
│   │   ├── home_screen.dart        ← Main shell + bottom nav + FAB
│   │   ├── home_tab.dart           ← Home tab content
│   │   ├── garden_tab.dart         ← My Garden tab
│   │   ├── scan_tab.dart           ← AI Scan, AR, Growth Predictor
│   │   ├── community_tab.dart      ← Social Feed
│   │   ├── marketplace_tab.dart    ← Shop
│   │   └── profile_tab.dart        ← Profile + Gamification
│   └── widgets/
│       ├── plant_card.dart         ← Reusable plant card
│       ├── weather_panel.dart      ← Weather widget
│       └── gamification_panel.dart ← Badges + level ring
├── pubspec.yaml
└── README.md
```

---

## ⚙️ Android Studio Setup (Step-by-Step)

### 1. Install Flutter SDK
- Download: https://docs.flutter.dev/get-started/install
- Add `flutter/bin` to your PATH
- Run `flutter doctor` to verify everything is installed

### 2. Install Android Studio plugins
- Open **Android Studio → Settings → Plugins**
- Search and install: **Flutter** (this also installs Dart)
- Restart Android Studio

### 3. Create a new Flutter project (or use this folder)
```
File → New → New Flutter Project
```
Choose **Flutter Application**, set your package name (e.g. `com.yourname.plantcarepro`).

**OR** just open this folder directly:
```
File → Open → [select the plantcare_flutter folder]
```

### 4. Copy these files into your project
Replace the generated `lib/` folder contents with the files from this project, and replace `pubspec.yaml`.

### 5. Install dependencies
In the terminal inside Android Studio:
```bash
flutter pub get
```

### 6. Run the app
- **Android**: Connect a device or start an emulator, then press ▶️ or run:
  ```bash
  flutter run
  ```
- **Web**: 
  ```bash
  flutter run -d chrome
  ```
- **iOS** (macOS only):
  ```bash
  flutter run -d ios
  ```

---

## 🌐 Enabling Web Support

```bash
flutter config --enable-web
flutter create .       # adds web/ folder if missing
flutter run -d chrome
```

To build for production web:
```bash
flutter build web
```
Output goes to `build/web/` — deploy to Firebase Hosting, Netlify, Vercel, etc.

---

## 📱 Building Release APK (Android)

```bash
flutter build apk --release
```
APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🍎 Building for iOS (macOS + Xcode required)

```bash
flutter build ios
```

---

## 🎨 Design System (from theme.css → Dart)

| Token | Color |
|-------|-------|
| background | `#F8F4E3` |
| foreground | `#1B4332` |
| primary | `#1B4332` |
| secondary | `#52B788` |
| muted | `#D8E4DD` |
| mutedForeground | `#2D6A4F` |
| destructive | `#E76F51` |
| card | `#FFFFFF` |

All defined in `lib/theme/app_theme.dart` → `AppColors`.

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `google_fonts` | Inter font (matching the web app) |
| `cached_network_image` | Efficient plant image loading |
| `provider` | State management |
