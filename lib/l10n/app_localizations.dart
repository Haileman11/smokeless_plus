import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'QuitSmoking Tracker'**
  String get appTitle;

  /// Morning greeting
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// Afternoon greeting
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// Evening greeting
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// Encouragement message for user's journey
  ///
  /// In en, this message translates to:
  /// **'You\'re doing amazing on your smoke-free journey'**
  String get smokeFreeJourney;

  /// Current streak label
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// Label for days without smoking
  ///
  /// In en, this message translates to:
  /// **'Days Smoke-Free'**
  String get daysSmokeFree;

  /// Label for time counter
  ///
  /// In en, this message translates to:
  /// **'Time Smoke-Free'**
  String get timeSmokeFree;

  /// Money saved metric
  ///
  /// In en, this message translates to:
  /// **'Money Saved'**
  String get moneySaved;

  /// Cigarettes avoided metric
  ///
  /// In en, this message translates to:
  /// **'Cigarettes Avoided'**
  String get cigarettesAvoided;

  /// Health score metric
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get healthScore;

  /// Achievements metric
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// Encouragement message
  ///
  /// In en, this message translates to:
  /// **'Keep it up!'**
  String get keepItUp;

  /// Health improvement message
  ///
  /// In en, this message translates to:
  /// **'Improving daily'**
  String get improvingDaily;

  /// Achievement description
  ///
  /// In en, this message translates to:
  /// **'Based on progress'**
  String get basedOnProgress;

  /// Pack count message
  ///
  /// In en, this message translates to:
  /// **'That\'s {count} packs'**
  String thatsPacks(int count);

  /// Navigation label for home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigationHome;

  /// Navigation label for progress
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navigationProgress;

  /// Navigation label for health score
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get navigationHealthScore;

  /// Navigation label for achievements
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get navigationAchievements;

  /// Navigation label for profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navigationProfile;

  /// Success message for progress update
  ///
  /// In en, this message translates to:
  /// **'Progress updated successfully!'**
  String get progressUpdated;

  /// Error message when data loading fails
  ///
  /// In en, this message translates to:
  /// **'Error loading data. Using default values.'**
  String get errorLoadingData;

  /// First motivational message
  ///
  /// In en, this message translates to:
  /// **'Every day smoke-free is a victory. You\'re building a healthier, stronger version of yourself with each passing moment.'**
  String get motivationalMessage1;

  /// Second motivational message
  ///
  /// In en, this message translates to:
  /// **'Your lungs are thanking you right now. Every breath is cleaner, every heartbeat stronger.'**
  String get motivationalMessage2;

  /// Third motivational message
  ///
  /// In en, this message translates to:
  /// **'The money you\'re saving is just the beginning. The real treasure is the years you\'re adding to your life.'**
  String get motivationalMessage3;

  /// Author name
  ///
  /// In en, this message translates to:
  /// **'Dr. Michael Chen'**
  String get drMichaelChen;

  /// Author name
  ///
  /// In en, this message translates to:
  /// **'Health Coach Maria'**
  String get healthCoachMaria;

  /// Author name
  ///
  /// In en, this message translates to:
  /// **'Wellness Expert John'**
  String get wellnessExpertJohn;

  /// Health stage for starting
  ///
  /// In en, this message translates to:
  /// **'Starting Recovery'**
  String get healthStageStarting;

  /// Health stage for ready to begin
  ///
  /// In en, this message translates to:
  /// **'Ready to Begin'**
  String get healthStageBegin;

  /// Health stage for journey begins
  ///
  /// In en, this message translates to:
  /// **'Journey Begins'**
  String get healthStageJourney;

  /// Health stage for nicotine dropping
  ///
  /// In en, this message translates to:
  /// **'Nicotine Dropping'**
  String get healthStageNicotineDropping;

  /// Health stage for CO normalizing
  ///
  /// In en, this message translates to:
  /// **'CO Levels Normalizing'**
  String get healthStageCONormalizing;

  /// Health stage for heart risk
  ///
  /// In en, this message translates to:
  /// **'Heart Risk Decreasing'**
  String get healthStageHeartRisk;

  /// Health stage for nicotine free
  ///
  /// In en, this message translates to:
  /// **'Nicotine Free Body'**
  String get healthStageNicotineFree;

  /// Health stage for senses improving
  ///
  /// In en, this message translates to:
  /// **'Senses Improving'**
  String get healthStageSensesImproving;

  /// Health stage for circulation
  ///
  /// In en, this message translates to:
  /// **'Circulation Improving'**
  String get healthStageCirculation;

  /// Health stage for lung function
  ///
  /// In en, this message translates to:
  /// **'Lung Function Improving'**
  String get healthStageLungFunction;

  /// Health stage for significant recovery
  ///
  /// In en, this message translates to:
  /// **'Significant Recovery'**
  String get healthStageSignificant;

  /// Health stage for heart disease
  ///
  /// In en, this message translates to:
  /// **'Heart Disease Risk Reduced'**
  String get healthStageHeartDisease;

  /// Health stage for stroke
  ///
  /// In en, this message translates to:
  /// **'Stroke Risk Normalized'**
  String get healthStageStroke;

  /// Health stage for maximum recovery
  ///
  /// In en, this message translates to:
  /// **'Maximum Health Recovery'**
  String get healthStageMaximum;

  /// Milestone for starting journey
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get milestoneStartJourney;

  /// Milestone for nicotine dropping
  ///
  /// In en, this message translates to:
  /// **'Nicotine Levels Dropping'**
  String get milestoneNicotineDropping;

  /// Milestone for CO clearing
  ///
  /// In en, this message translates to:
  /// **'Carbon Monoxide Clearing'**
  String get milestoneCOClearing;

  /// Milestone for heart attack risk
  ///
  /// In en, this message translates to:
  /// **'Heart Attack Risk Decreasing'**
  String get milestoneHeartAttack;

  /// Milestone for nicotine elimination
  ///
  /// In en, this message translates to:
  /// **'Nicotine Elimination'**
  String get milestoneNicotineElimination;

  /// Milestone for taste and smell
  ///
  /// In en, this message translates to:
  /// **'Taste & Smell Revival'**
  String get milestoneTasteSmell;

  /// Milestone for circulation boost
  ///
  /// In en, this message translates to:
  /// **'Circulation Boost'**
  String get milestoneCirculationBoost;

  /// Milestone for lung function boost
  ///
  /// In en, this message translates to:
  /// **'Lung Function Boost'**
  String get milestoneLungBoost;

  /// Milestone for major lung recovery
  ///
  /// In en, this message translates to:
  /// **'Major Lung Recovery'**
  String get milestoneMajorLung;

  /// Milestone for heart risk halved
  ///
  /// In en, this message translates to:
  /// **'Heart Risk Halved'**
  String get milestoneHeartRisk;

  /// Milestone for stroke risk
  ///
  /// In en, this message translates to:
  /// **'Stroke Risk Normalized'**
  String get milestoneStrokeRisk;

  /// Milestone for cancer risk
  ///
  /// In en, this message translates to:
  /// **'Cancer Risk Halved'**
  String get milestoneCancerRisk;

  /// Milestone for maintaining excellence
  ///
  /// In en, this message translates to:
  /// **'Maintaining Excellence'**
  String get milestoneMaintaining;

  /// Status for achieved milestone
  ///
  /// In en, this message translates to:
  /// **'Achieved'**
  String get achievedStatus;

  /// Status for soon milestone
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get soonStatus;

  /// Status for not started
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get notStartedStatus;

  /// Time remaining in days (singular)
  ///
  /// In en, this message translates to:
  /// **'In {count} day'**
  String timeInDays(int count);

  /// Time remaining in days (plural)
  ///
  /// In en, this message translates to:
  /// **'In {count} days'**
  String timeInDaysPlural(int count);

  /// Time remaining in hours (singular)
  ///
  /// In en, this message translates to:
  /// **'In {count} hour'**
  String timeInHours(int count);

  /// Time remaining in hours (plural)
  ///
  /// In en, this message translates to:
  /// **'In {count} hours'**
  String timeInHoursPlural(int count);

  /// Time remaining in minutes
  ///
  /// In en, this message translates to:
  /// **'In {count} minutes'**
  String timeInMinutes(int count);

  /// Language settings title
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// Select language label
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Spanish language option
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// French language option
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// German language option
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// Italian language option
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// Portuguese language option
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// Chinese language option
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// Japanese language option
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// Russian language option
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// Hindi language option
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'de', 'en', 'es', 'fr', 'hi', 'it', 'ja', 'pt', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
