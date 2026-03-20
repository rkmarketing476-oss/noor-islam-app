# 🌙 Noor Islam — Flutter App
### Complete Build & Installation Guide

---

## 📋 WHAT'S INCLUDED

This is a **complete Flutter project** for the Noor Islam Islamic app, featuring:

| Feature | Details |
|---------|---------|
| 📖 Full Quran | All 114 Surahs, all verses, Arabic + Translation |
| 📿 Dua Collection | 8 categories, 30+ duas with Arabic, transliteration |
| 🔢 Tasbih Counter | Digital counter with haptic feedback, 6 dhikr types |
| 🕌 Prayer Times | GPS-based, 6 daily prayers (Karachi method) |
| 🧭 Qibla Compass | Real sensor-based compass pointing to Makkah |
| 📅 Islamic Calendar | Hijri calendar with Islamic events |
| 🌙 Live Home | Animated sky (sun/moon), live clock, daily dhikr |
| ⚙️ Full Settings | Theme color, dark mode, font, language, transparency |
| 🌍 Bilingual | Full English + বাংলা (Bangla) support |
| 📱 Responsive | Mobile (bottom nav) + Tablet/Desktop (sidebar) |

---

## 🛠 PREREQUISITES

### 1. Install Flutter SDK
```bash
# Visit: https://docs.flutter.dev/get-started/install
# Install Flutter 3.16+ (stable channel)
flutter --version    # Should show Flutter 3.16+
```

### 2. Install Android Studio
- Download from: https://developer.android.com/studio
- During setup, install Android SDK (API 34)
- Accept all SDK licenses:
  ```bash
  flutter doctor --android-licenses
  ```

### 3. Verify Setup
```bash
flutter doctor
# All checks should pass (✓)
```

---

## 🚀 BUILD STEPS

### Step 1 — Navigate to Project
```bash
cd noor_islam
```

### Step 2 — Get Dependencies
```bash
flutter pub get
```
This downloads all packages:
- `quran` — Full Quran data (114 surahs, all verses)
- `adhan` — Prayer time calculations
- `flutter_qiblah` — Qibla compass
- `hijri` — Hijri calendar
- `geolocator` — GPS location
- `provider` — State management
- `google_fonts` — Amiri Arabic font
- And more...

### Step 3 — Build APK (Debug - for testing)
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Step 4 — Build APK (Release - for sharing/installing)
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Step 5 — Install on Device
```bash
# Connect Android phone via USB (enable Developer Mode + USB Debugging)
flutter install
```

Or manually transfer the APK file to your phone and install it.

---

## 📦 APK SIZES (Approximate)

| Build Type | Size |
|------------|------|
| Debug APK | ~60-80 MB |
| Release APK | ~25-40 MB |

---

## 🐛 COMMON ISSUES & FIXES

### Issue: `flutter pub get` fails
```bash
flutter clean
flutter pub get
```

### Issue: Android SDK not found
```bash
# Set Android SDK path
flutter config --android-sdk /path/to/Android/sdk
```

### Issue: Gradle build fails
```bash
cd android
./gradlew clean
cd ..
flutter build apk
```

### Issue: minSdkVersion error
The app requires Android 5.0+ (minSdk 21). This supports 99%+ of Android devices.

### Issue: Location permissions on device
When running the app, grant Location permissions when prompted (needed for Prayer Times and Qibla).

---

## 📱 DEVICE REQUIREMENTS

| Requirement | Minimum |
|-------------|---------|
| Android Version | 5.0 (API 21) |
| RAM | 2GB |
| Storage | 100MB free |
| Sensors | GPS (for prayer times/qibla) |
| Compass | Optional (for Qibla rotation) |

---

## 🌍 RUNNING ON EMULATOR

```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>

# Run app on emulator
flutter run
```

⚠️ **Note**: Qibla Compass and GPS may not work perfectly on emulators. Use a real device for full functionality.

---

## 📂 PROJECT STRUCTURE

```
noor_islam/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart            # Color palette
│   │   │   ├── app_strings.dart           # EN/BN strings
│   │   │   └── dua_data.dart              # All duas data
│   │   ├── providers/
│   │   │   ├── settings_provider.dart     # App settings state
│   │   │   └── tasbih_provider.dart       # Counter state
│   │   └── theme/
│   │       └── app_theme.dart             # Light/Dark themes
│   ├── features/
│   │   ├── home/home_screen.dart          # Animated home
│   │   ├── quran/
│   │   │   ├── quran_screen.dart          # Surah list
│   │   │   └── surah_detail_screen.dart   # Verses view
│   │   ├── dua/dua_screen.dart            # Dua collection
│   │   ├── tasbih/tasbih_screen.dart      # Counter
│   │   ├── prayer/prayer_screen.dart      # Prayer times
│   │   ├── qibla/qibla_screen.dart        # Compass
│   │   ├── calendar/calendar_screen.dart  # Hijri calendar
│   │   ├── settings/settings_screen.dart  # Settings
│   │   └── more/more_screen.dart          # More hub
│   └── shared/
│       └── widgets/
│           ├── glass_card.dart            # Glassmorphism cards
│           └── app_navigation.dart        # Nav bar/rail
├── android/
│   ├── app/
│   │   ├── build.gradle                   # Android config
│   │   └── src/main/
│   │       ├── AndroidManifest.xml        # Permissions
│   │       └── kotlin/com/noorislam/app/
│   │           └── MainActivity.kt
│   ├── build.gradle
│   └── gradle.properties
└── pubspec.yaml                           # Dependencies
```

---

## ✅ FULL FEATURE CHECKLIST

- [x] Home screen with animated sky (day/night)
- [x] Live clock with AM/PM
- [x] Hijri date on home screen
- [x] Daily dhikr cards
- [x] Full Quran (114 surahs × all verses)
- [x] Arabic text with Amiri font (never breaks)
- [x] Translation + transliteration
- [x] 30+ Duas in 8 categories
- [x] Digital Tasbih with haptic feedback
- [x] GPS-based Prayer Times
- [x] Real Qibla Compass
- [x] Hijri Islamic Calendar
- [x] 10 Islamic events listed
- [x] Settings: Dark/Light mode
- [x] Settings: Theme color picker (10 colors)
- [x] Settings: Font selector
- [x] Settings: EN/BN language switch
- [x] Settings: Glass transparency slider
- [x] Settings: Animation toggle
- [x] Responsive: Mobile (bottom nav)
- [x] Responsive: Tablet/Desktop (navigation rail)
- [x] APK export ready

---

## 📞 BUILD COMMAND SUMMARY

```bash
# Quick build (release APK)
cd noor_islam && flutter pub get && flutter build apk --release

# The APK will be at:
# build/app/outputs/flutter-apk/app-release.apk
```

**بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ**
*In the name of Allah, the Most Gracious, the Most Merciful*
