# NFC Adventures

NFC Adventures is a cross-platform Flutter mobile application that enables interactive adventure experiences through NFC tag scanning and collection. The app supports multiple adventure scenarios with downloadable content packages containing NFC tag definitions and associated images.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Development Guidelines

### Adding New Strings and Translations

When adding new user-facing strings to the application:

1. **Add to English localization**: Update `lib/l10n/app_en.arb` with new string keys
2. **Add German translation**: Update `lib/l10n/app_de.arb` with corresponding German translations
3. **Use proper ARB format**: Follow the existing pattern for string keys and descriptions
4. **Regenerate localizations**: Run `flutter gen-l10n` if needed to update generated files

### Commit Message Guidelines

Use **conventional commits** format for all commit messages:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic changes)
- `refactor`: Code refactoring without feature/bug changes
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, dependencies updates

**Examples**:
- `feat(nfc): add debug mode for NFC scanning`
- `fix(ui): correct theme switching animation`
- `docs: update installation instructions`
- `feat(l10n): add German translations for settings screen`

## Working Effectively

### Bootstrap, Build, and Test the Repository

Follow these exact commands in sequence:

1. **Install Flutter SDK (REQUIRED)**:
   ```bash
   # Method 1: Git clone (most reliable in restricted networks)
   cd /tmp
   git clone --depth 1 --branch stable https://github.com/flutter/flutter.git
   export PATH="/tmp/flutter/bin:$PATH"
   
   # Method 2: Direct download (may fail due to network restrictions)
   # wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz
   # tar xf flutter_linux_3.24.3-stable.tar.xz
   
   # Method 3: Snap package (may fail due to network restrictions)  
   # sudo snap install flutter --classic
   
   # CRITICAL: Network-restricted environments may block Flutter SDK downloads
   # If all methods fail, document the specific error for environment setup
   ```

2. **Install Dependencies** (only when adding new dependencies) - NEVER CANCEL: Takes 2-5 minutes. Set timeout to 10+ minutes:
   ```bash
   cd /home/runner/work/nfc-adventures/nfc-adventures
   flutter pub get
   # May fail in network-restricted environments - document specific errors
   ```

3. **Generate App Icons** (only when changing app icons) - Takes 1-2 minutes:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

4. **Format and Lint Code** - Takes 30 seconds:
   ```bash
   dart format --set-exit-if-changed .
   # To auto-fix formatting: dart format .
   # May require Dart SDK download in restricted environments
   ```

5. **Run Tests** - NEVER CANCEL: Test suite takes 5-10 minutes. Set timeout to 20+ minutes:
   ```bash
   flutter test
   ```

6. **Build Applications** - NEVER CANCEL: Builds take 15-30 minutes each. Set timeout to 45+ minutes:
   ```bash
   # Android APK
   flutter build apk
   
   # Android App Bundle (for Play Store)
   flutter build appbundle
   
   # iOS (requires macOS)
   flutter build ios
   
   # Linux Desktop
   flutter build linux
   
   # Windows Desktop  
   flutter build windows
   
   # Web
   flutter build web
   ```

### Run the Application

- **Mobile/Development**: `flutter run` - Requires connected device or emulator

## Validation

**CRITICAL**: Always manually validate any new code through complete end-to-end scenarios after making changes.

### Manual Validation Scenarios

After building and running the application, you MUST test actual functionality:

1. **Adventure Selection Flow**:
   - Launch app and verify adventure selection screen appears
   - Test download/selection of adventure packages
   - Verify adventure assets load correctly

2. **NFC Scanning Flow** (limited without physical NFC device):
   - Navigate to scan screen
   - Verify UI displays scanning instructions
   - Test debug mode activation (tap title 10 times quickly)
   - In debug mode, verify last scanned tag ID display functionality

3. **Collection Flow**:
   - Navigate to collection screen
   - Verify collected tags display correctly
   - Test tag detail views

4. **Theme and Localization**:
   - Toggle between light/dark themes
   - Verify UI adapts correctly
   - Test language switching (English/German)

### Build Validation

Always run these commands before committing changes (CI will fail otherwise):

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

## Common Tasks

The following are outputs from frequently run commands. Reference them instead of viewing, searching, or running bash commands to save time.

### Repository Root Structure
```
.
├── .github/            # GitHub configuration (funding, workflows)
├── android/           # Android platform-specific code and configuration
├── assets/            # Adventure assets (icons, sample tags.json, images)
├── ios/              # iOS platform-specific code and configuration
├── lib/              # Main Dart application code
│   ├── l10n/         # Localization files (English/German)
│   ├── models/       # Data models
│   ├── screens/      # UI screens
│   └── services/     # Business logic services
├── linux/            # Linux desktop platform code (CMake)
├── macos/            # macOS platform-specific code
├── manager/          # Additional management code
├── test/             # Test files
├── web/              # Web platform-specific code
├── windows/          # Windows desktop platform code (CMake)
├── analysis_options.yaml # Dart analyzer configuration
├── devenv.nix        # Nix development environment
├── pubspec.yaml      # Flutter dependencies and project config
└── README.md         # Project documentation
```

### Key Application Components

- **Main Entry**: `lib/main.dart` - App initialization, theme management, navigation
- **NFC Service**: `lib/services/nfc_service.dart` - Handles NFC tag reading
- **Adventure Service**: `lib/services/adventure_service.dart` - Manages adventure packages
- **Storage Service**: `lib/services/storage_service.dart` - Local data persistence
- **Scan Screen**: `lib/screens/scan_screen.dart` - NFC scanning interface
- **Collection Screen**: `lib/screens/collection_screen.dart` - View collected tags

### Flutter Dependencies

See [pubspec.yaml](pubspec.yaml) for complete list of dependencies and their versions.

### Adventure Package Structure

Adventures are ZIP packages containing:
```
adventure.zip
├── tags.json          # NFC tag definitions {"uid": "name"}
└── images/            # Tag-specific images named by UID
    ├── 32:b8:4e:d3.jpg
    └── 42:42:42:42.png
```

Example tags.json:
```json
{
    "32:b8:4e:d3": "Foobar",
    "42:42:42:42": "In outer Space"
}
```

## Development Environment Support

### Nix Development Environment (devenv.nix)
If using Nix, these convenience scripts are available:
- `create-emulator` - Create Android emulator
- `run-app` - Execute `flutter run`
- `build-apk-unsigned` - Build Android APK
- `lint` - Run formatter check
- `lint-fix` - Auto-fix formatting

### Platform Requirements

- **Android**: Requires Android Studio or Android SDK
- **iOS**: Requires macOS with Xcode
- **Linux**: Requires GTK 3.0 development libraries
- **Windows**: Requires Visual Studio or Visual Studio Build Tools
- **Web**: Runs in any modern browser

### Debug Features

- **Debug Mode**: Tap app title 10 times quickly to enable
- **Debug UI**: Shows last scanned NFC tag UID (tap to copy to clipboard)
- **Hot Reload**: Use `r` in Flutter terminal for quick UI updates
- **Hot Restart**: Use `R` in Flutter terminal for full app restart

## Troubleshooting

### Manual Code Validation (Network-Restricted Alternative)

When Flutter SDK is unavailable due to network restrictions, validate code changes using these methods:

**Dart Code Analysis**:
```bash
# Check Dart file syntax manually (30 seconds)
find lib/ -name "*.dart" | head -5
# Expected result: 13 total Dart files in project

# Review key files for syntax issues (2-3 minutes per file):
# - lib/main.dart (app entry point, 310 lines)
# - lib/services/nfc_service.dart (NFC functionality)  
# - lib/services/adventure_service.dart (adventure management)
# - lib/screens/scan_screen.dart (scanning interface)
```

**Project Structure Validation** (1-2 minutes total):
```bash
# Validate pubspec.yaml dependencies (verified compatible versions)
grep -A10 "dependencies:" pubspec.yaml
# Expected: flutter, nfc_manager ^3.5.0, shared_preferences ^2.5.1, etc.

# Check localization files exist (English/German support)
ls -la lib/l10n/  
# Expected: app_en.arb, app_de.arb

# Verify platform support files
ls -la android/ ios/ linux/ windows/ web/ macos/
# Expected: All directories present for cross-platform support
```

**Asset and Configuration Validation** (1 minute):
```bash
# Check required assets exist
ls -la assets/icon/icon.png  # Expected: 70533 bytes
ls -la assets/tags.json      # Expected: Sample adventure data  
ls -la assets/tag_images/    # Expected: Adventure image directory

# Validate build configurations
grep -r "nfc_adventures" android/app/build.gradle
# Expected: applicationId = "de.kolaente.nfc_adventures"
```

### Build Issues

**CRITICAL**: This environment experiences network restrictions that block Flutter SDK downloads.

**Working Solutions**:
1. Git clone Flutter repository: `git clone --depth 1 --branch stable https://github.com/flutter/flutter.git`
2. Use existing Flutter installation if available
3. Focus on code analysis using repository structure

**Known Network Blocks**:
- Flutter SDK binary downloads (storage.googleapis.com)
- Dart SDK downloads (Flutter engine components)  
- Snap package installations
- Some curl/wget operations return "Blocked by DNS monitoring proxy"

**Alternative Validation Approach**:
When Flutter commands fail due to network restrictions:
1. Analyze Dart code syntax manually
2. Review pubspec.yaml dependencies for compatibility
3. Check repository structure and file organization
4. Validate CMakeLists.txt for desktop builds
5. Review localization files for completeness

### Build Issues

- **Android**: Ensure Java 8+ is installed, check Android SDK setup
- **iOS**: Ensure Xcode command line tools are installed  
- **Linux**: Install required system packages: `sudo apt install cmake ninja-build libgtk-3-dev`
- **Windows**: Ensure Visual Studio with C++ tools is installed

### Test Issues

**KNOWN TEST BUG**: `test/widget_test.dart` references incorrect app class:
- Test uses: `await tester.pumpWidget(const MyApp());`
- Actual app class: `const NfcCollectorApp()` (in lib/main.dart)
- **Fix**: Update test to use `NfcCollectorApp()` or create appropriate test scenarios

**Test Structure**: Single widget test file (not comprehensive test suite)

- Physical NFC device required for full functionality testing
- Use debug mode for development without NFC hardware
- Test UI flows and adventure management without NFC scanning

## Important Notes

- **NEVER CANCEL long-running commands**: Flutter builds and tests take significant time
- **Always test complete user scenarios** after changes, not just compilation
- **Use debug mode extensively** for development without NFC hardware
- **Adventure packages are the core feature** - understand the ZIP structure
- **Cross-platform codebase** - changes affect multiple platforms simultaneously