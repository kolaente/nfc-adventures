import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'NFC Adventures'**
  String get appTitle;

  /// Bottom navigation label for scan screen
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get bottomNavScan;

  /// Bottom navigation label for collection screen
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get bottomNavCollection;

  /// Title for adventure selection screen
  ///
  /// In en, this message translates to:
  /// **'Select Adventure'**
  String get adventureSelectionTitle;

  /// Instructions shown on scan screen
  ///
  /// In en, this message translates to:
  /// **'Hold your tag near the reader...'**
  String get scanInstructions;

  /// Instructions shown on QR scanner screen
  ///
  /// In en, this message translates to:
  /// **'Point camera at QR code to scan adventure'**
  String get qrScanInstructions;

  /// Success message when tag is scanned
  ///
  /// In en, this message translates to:
  /// **'Tag scanned: {tagName}'**
  String tagScannedSuccess(String tagName);

  /// NFC scanning prompt message
  ///
  /// In en, this message translates to:
  /// **'Hold your device near the NFC tag'**
  String get nfcPrompt;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorGeneric(String error);

  /// Error message for invalid QR codes
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code'**
  String get errorInvalidQrCode;

  /// Error message when tags fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading tags'**
  String get errorLoadingTags;

  /// Error when adventures cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Failed to load adventures'**
  String get errorLoadingAdventures;

  /// Error when adventure download fails
  ///
  /// In en, this message translates to:
  /// **'Failed to download adventure'**
  String get errorDownloadingAdventure;

  /// Error loading adventure title
  ///
  /// In en, this message translates to:
  /// **'Error loading adventure title: {error}'**
  String errorLoadingAdventureTitle(String error);

  /// Button text for retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Fallback text for unknown adventure
  ///
  /// In en, this message translates to:
  /// **'Unknown Adventure'**
  String get unknownAdventure;

  /// Fallback text for unknown tag
  ///
  /// In en, this message translates to:
  /// **'Unknown Tag'**
  String get unknownTag;

  /// Counter showing collected vs total tags
  ///
  /// In en, this message translates to:
  /// **'{collected} of {total} tags found'**
  String tagCollectionCounter(int collected, int total);

  /// Message shown when all tags are collected
  ///
  /// In en, this message translates to:
  /// **'All tags found!'**
  String get allTagsFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
