// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NFC Adventures';

  @override
  String get bottomNavScan => 'Scan';

  @override
  String get bottomNavCollection => 'Collection';

  @override
  String get adventureSelectionTitle => 'Select Adventure';

  @override
  String get scanInstructions => 'Hold your tag near the reader...';

  @override
  String get qrScanInstructions => 'Point camera at QR code to scan adventure';

  @override
  String tagScannedSuccess(String tagName) {
    return 'Tag scanned: $tagName';
  }

  @override
  String get nfcPrompt => 'Hold your device near the NFC tag';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get errorInvalidQrCode => 'Invalid QR code';

  @override
  String get errorLoadingTags => 'Error loading tags';

  @override
  String get errorLoadingAdventures => 'Failed to load adventures';

  @override
  String get errorDownloadingAdventure => 'Failed to download adventure';

  @override
  String errorLoadingAdventureTitle(String error) {
    return 'Error loading adventure title: $error';
  }

  @override
  String get retryButton => 'Retry';

  @override
  String get unknownAdventure => 'Unknown Adventure';

  @override
  String get unknownTag => 'Unknown Tag';

  @override
  String tagCollectionCounter(int collected, int total) {
    return '$collected of $total tags found';
  }

  @override
  String get allTagsFound => 'All tags found!';
}
