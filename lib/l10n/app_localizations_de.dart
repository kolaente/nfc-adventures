// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'NFC Adventures';

  @override
  String get bottomNavScan => 'Scannen';

  @override
  String get bottomNavCollection => 'Sammlung';

  @override
  String get adventureSelectionTitle => 'Abenteuer auswählen';

  @override
  String get scanInstructions => 'Halte deinen Tag an den Reader...';

  @override
  String get qrScanInstructions =>
      'Richte die Kamera auf den QR-Code, um das Abenteuer zu scannen';

  @override
  String tagScannedSuccess(String tagName) {
    return 'Tag gescannt: $tagName';
  }

  @override
  String get nfcPrompt => 'Halte dein Gerät an den NFC-Tag';

  @override
  String errorGeneric(String error) {
    return 'Fehler: $error';
  }

  @override
  String get errorInvalidQrCode => 'Ungültiger QR-Code';

  @override
  String get errorLoadingTags => 'Fehler beim Laden der Tags';

  @override
  String get errorLoadingAdventures => 'Abenteuer konnten nicht geladen werden';

  @override
  String get errorDownloadingAdventure =>
      'Abenteuer konnte nicht heruntergeladen werden';

  @override
  String errorLoadingAdventureTitle(String error) {
    return 'Fehler beim Laden des Abenteuer-Titels: $error';
  }

  @override
  String get retryButton => 'Nochmal versuchen';

  @override
  String get unknownAdventure => 'Unbekanntes Abenteuer';

  @override
  String get unknownTag => 'Unbekannter Tag';

  @override
  String tagCollectionCounter(int collected, int total) {
    return '$collected von $total Tags gefunden';
  }

  @override
  String get allTagsFound => 'Alle Tags gefunden!';
}
