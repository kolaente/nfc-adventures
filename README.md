# NFC Adventures

A Flutter-based NFC tag collector app that enables interactive adventure experiences through NFC tag scanning and collection.

## Overview

NFC Adventures is a cross-platform mobile application built with Flutter that allows users to scan NFC tags as part of interactive adventures. The app supports multiple adventure scenarios, where each adventure contains a collection of NFC tags with associated images and metadata.

## Features

- **NFC Tag Scanning**: Scan NFC tags using your device's NFC capabilities
- **Adventure Management**: Support for multiple adventures with downloadable content
- **Tag Collection**: Track and view your collected NFC tags with associated images
- **Dark/Light Theme**: Toggle between dark and light themes
- **Multilingual Support**: Available in English and German
- **Debug Mode**: Hidden debug features for development and testing
- **Cross-Platform**: Built for Android, iOS, macOS, Linux, Windows, and Web

## Architecture

### Core Components

- **Adventure System**: Manages downloadable adventure packages containing NFC tag definitions and images
- **NFC Service**: Handles NFC tag detection and reading
- **Storage Service**: Local data persistence for collected tags and adventure progress
- **Image Management**: Handles adventure-specific images and assets

### Key Screens

- **Adventure Selection**: Choose and download adventure packages
- **Scan Screen**: Real-time NFC tag scanning interface
- **Collection Screen**: View your collected tags and progress
- **Tag Detail**: Detailed view of individual collected tags

## Getting Started

### Prerequisites

- Flutter SDK (^3.5.1)
- NFC-enabled device for testing
- Platform-specific development setup (Android Studio for Android, Xcode for iOS)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd nfc-adventures
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate app icons:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Building for Production

- **Android**: `flutter build apk` or `flutter build appbundle`
- **iOS**: `flutter build ios`

## Adventure Creation

Adventures are defined as ZIP packages containing:

1. **tags.json**: Defines the NFC tags and their metadata
2. **images/**: Directory containing tag-specific images named by tag ID

Example adventure structure:
```json
{
    "1D:1D:C6:0D:09:10:80": "Tag Name",
    "1D:1E:C5:0D:09:10:80": "Another Tag"
}
```

## Development

### Debug Mode

The app includes a hidden debug mode activated by tapping the app title 10 times quickly. Debug mode provides additional information and testing capabilities.

### Localization

The app supports internationalization through Flutter's `intl` package. Supported languages:
- English (en)
- German (de)

Add new translations in `lib/l10n/app_[locale].arb` files.

## Dependencies

### Main Dependencies
- `nfc_manager`: NFC functionality
- `shared_preferences`: Local data storage
- `http`: Network requests for adventure downloads
- `path_provider`: File system access
- `archive`: ZIP file handling for adventures

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_launcher_icons`: App icon generation
- `flutter_lints`: Code quality rules

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). This means you are free to use, modify, and distribute this software under the terms of the GPL-3.0 license.

See the [LICENSE](LICENSE) file for the full license text, or visit https://www.gnu.org/licenses/gpl-3.0.html for more information.

