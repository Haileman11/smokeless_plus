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
  /// **'No Smoke'**
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

  /// Title for the health recovery timeline screen
  ///
  /// In en, this message translates to:
  /// **'Health Recovery Timeline'**
  String get healthRecoveryTimeline;

  /// Label for the user's current recovery stage
  ///
  /// In en, this message translates to:
  /// **'Current Stage'**
  String get currentStage;

  /// Label indicating progress toward the next milestone
  ///
  /// In en, this message translates to:
  /// **'Progress to Next Milestone'**
  String get progressToNextMilestone;

  /// Label for the upcoming milestone
  ///
  /// In en, this message translates to:
  /// **'Next Milestone'**
  String get nextMilestone;

  /// Label for remaining time until an event or milestone
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get timeRemaining;

  /// Message shown while daily motivation content loads
  ///
  /// In en, this message translates to:
  /// **'Loading your daily motivation...'**
  String get loadingYourDailyMotivation;

  /// Generic loading indicator
  ///
  /// In en, this message translates to:
  /// **'Loading ...'**
  String get loading;

  /// Error message when a motivational quote cannot be refreshed
  ///
  /// In en, this message translates to:
  /// **'Unable to refresh quote. Try again later.'**
  String get unableToRefreshQuote;

  /// Title for morning motivational content
  ///
  /// In en, this message translates to:
  /// **'Morning Motivation'**
  String get morningMotivation;

  /// Title for evening inspirational content
  ///
  /// In en, this message translates to:
  /// **'Evening Inspiration'**
  String get eveningInspiration;

  /// Countdown display emphasizing each second
  ///
  /// In en, this message translates to:
  /// **'Every second counts - {second} seconds and counting!'**
  String everySecondCounts(int second);

  /// Prep countdown message before an activity
  ///
  /// In en, this message translates to:
  /// **'Get ready - {second} seconds until you start!'**
  String getReady(int second);

  /// Label for days unit
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// Label for hours unit
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// Label for minutes unit
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// Message shown while achievements are being loaded
  ///
  /// In en, this message translates to:
  /// **'Loading Your Achievements...'**
  String get loadingAchievements;

  /// Title for the achievement/awards system
  ///
  /// In en, this message translates to:
  /// **'Achievement System'**
  String get achievementSystem;

  /// Status label when an achievement is unlocked
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// Label for total count or total value
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Label for progress indicator
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Title for list of recently earned achievements
  ///
  /// In en, this message translates to:
  /// **'Recent Achievements'**
  String get recentAchievements;

  /// Title for synchronized progress overview
  ///
  /// In en, this message translates to:
  /// **'Your Synchronized Progress'**
  String get progressTracking;

  /// Label for live synchronization feature
  ///
  /// In en, this message translates to:
  /// **'Live sync'**
  String get liveSync;

  /// Label for user's quit date
  ///
  /// In en, this message translates to:
  /// **'Quit Date'**
  String get quitDate;

  /// Label for user's current streak
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// Label for money saved
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// Label for cigarettes avoided
  ///
  /// In en, this message translates to:
  /// **'Avoided'**
  String get avoided;

  /// Label for health-related metric
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// Label for social impact metric
  ///
  /// In en, this message translates to:
  /// **'Social Impact'**
  String get socialImpact;

  /// Label for number of friends inspired
  ///
  /// In en, this message translates to:
  /// **'Friends Inspired'**
  String get friendsInspired;

  /// Label for support messages received
  ///
  /// In en, this message translates to:
  /// **'Support Messages'**
  String get supportMessages;

  /// Label for user's community ranking
  ///
  /// In en, this message translates to:
  /// **'Community Rank'**
  String get communityRank;

  /// Message shown while progress data syncs
  ///
  /// In en, this message translates to:
  /// **'Synchronizing Your Progress Data'**
  String get synchronizingProgressData;

  /// Title for available filter options
  ///
  /// In en, this message translates to:
  /// **'Filter Options'**
  String get filterOptions;

  /// Action label to export synchronized progress data
  ///
  /// In en, this message translates to:
  /// **'Export Synchronized Progress'**
  String get exportSynchronizedProgress;

  /// Confirmation shown when export completes successfully
  ///
  /// In en, this message translates to:
  /// **'Export Successful'**
  String get exportSuccessful;

  /// Action label to refresh data
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// Confirmation after sharing an achievement
  ///
  /// In en, this message translates to:
  /// **'Achievement shared successfully!'**
  String get achievementSharedSuccess;

  /// Label for health improvement metric
  ///
  /// In en, this message translates to:
  /// **'Health Improvement'**
  String get healthImprovement;

  /// Label for weekly time range
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// Label for monthly time range
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Label for three-month time range
  ///
  /// In en, this message translates to:
  /// **'3 Months'**
  String get threeMonths;

  /// Label for yearly time range
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Label for craving frequency metric
  ///
  /// In en, this message translates to:
  /// **'Craving Frequency'**
  String get cravingFrequency;

  /// Label for cravings count or list
  ///
  /// In en, this message translates to:
  /// **'Cravings'**
  String get cravings;

  /// Label for synchronized smoke-free streak
  ///
  /// In en, this message translates to:
  /// **'Synchronized Smoke-Free Streak'**
  String get synchronizedSmokeFreeStreak;

  /// Label showing the current streak (note: duplicate key may exist elsewhere)
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get currentStreak;

  /// Message shown when user has not started their journey
  ///
  /// In en, this message translates to:
  /// **'Your journey hasn\'t started yet'**
  String get yourJourneyHasntStartedYet;

  /// Prompt to remind user to verify quit date in profile
  ///
  /// In en, this message translates to:
  /// **'Check your quit date in Profile settings'**
  String get checkYourQuitDate;

  /// Label for the 'all milestones' category
  ///
  /// In en, this message translates to:
  /// **'All Milestones'**
  String get categoryAllLabel;

  /// Description for the 'all milestones' category
  ///
  /// In en, this message translates to:
  /// **'Show all health milestones'**
  String get categoryAllDescription;

  /// Label for short-term milestones
  ///
  /// In en, this message translates to:
  /// **'Short-Term'**
  String get categoryShortLabel;

  /// Description for short-term milestone timeframe
  ///
  /// In en, this message translates to:
  /// **'20 min - 48 hours'**
  String get categoryShortDescription;

  /// Label for medium-term milestones
  ///
  /// In en, this message translates to:
  /// **'Medium-Term'**
  String get categoryMediumLabel;

  /// Description for medium-term milestone timeframe
  ///
  /// In en, this message translates to:
  /// **'2 weeks - 9 months'**
  String get categoryMediumDescription;

  /// Label for long-term milestones
  ///
  /// In en, this message translates to:
  /// **'Long-Term'**
  String get categoryLongLabel;

  /// Description for long-term milestone timeframe
  ///
  /// In en, this message translates to:
  /// **'1-10+ years'**
  String get categoryLongDescription;

  /// Category label for financial motivations
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get motivationFinancial;

  /// Category label for health motivations
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get motivationHealth;

  /// Category label for behavioral motivations
  ///
  /// In en, this message translates to:
  /// **'Behavioral'**
  String get motivationBehavioral;

  /// Category label for social motivations
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get motivationSocial;

  /// Title for milestone category selector
  ///
  /// In en, this message translates to:
  /// **'Milestone Categories'**
  String get milestoneCategories;

  /// Text used when sharing a milestone
  ///
  /// In en, this message translates to:
  /// **'🎉 Milestone Achieved! 🎉\n\n{title} - {timeframe}\n{description}\n\nScientific Fact: {scientificBasis}\n\n#QuitSmoking #HealthJourney #MilestoneAchieved'**
  String milestoneShareText(String title, String timeframe, String description, String scientificBasis);

  /// Confirmation when achievement text is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Achievement copied to share!'**
  String get achievementCopied;

  /// Generic label for description fields
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Label for the scientific basis section
  ///
  /// In en, this message translates to:
  /// **'Scientific Basis'**
  String get scientificBasis;

  /// Prompt to complete app setup before accessing a feature
  ///
  /// In en, this message translates to:
  /// **'Complete Setup First'**
  String get completeSetupFirst;

  /// Instruction to set quit date to enable milestone tracking
  ///
  /// In en, this message translates to:
  /// **'Set your quit date to track health milestones'**
  String get setQuitDateToSeeMilestones;

  /// Title for the health milestones timeline view
  ///
  /// In en, this message translates to:
  /// **'Health Milestones Timeline'**
  String get healthMilestoneTimeline;

  /// Subtitle explaining milestone tracking
  ///
  /// In en, this message translates to:
  /// **'Track your scientifically-based recovery progress'**
  String get trackYourRecoveryProgress;

  /// Label showing lung function percentage
  ///
  /// In en, this message translates to:
  /// **'Lung \nFunction\n {percent}%'**
  String lungFunction(int percent);

  /// Label showing heart health percentage
  ///
  /// In en, this message translates to:
  /// **'Heart\nHealth\n {percent}%'**
  String heartHealth(int percent);

  /// Label showing overall wellness percentage
  ///
  /// In en, this message translates to:
  /// **'Overall\nWellness\n {percent}%'**
  String overallWellness(int percent);

  /// Short title for 20 minutes milestone
  ///
  /// In en, this message translates to:
  /// **'20 Minutes'**
  String get milestone_20_minutes_title;

  /// Description for the 20 minutes milestone
  ///
  /// In en, this message translates to:
  /// **'Heart rate and blood pressure drop'**
  String get milestone_20_minutes_description;

  /// Short title for 12 hours milestone
  ///
  /// In en, this message translates to:
  /// **'12 Hours'**
  String get milestone_12_hours_title;

  /// Description for the 12 hours milestone
  ///
  /// In en, this message translates to:
  /// **'Carbon monoxide level normalizes'**
  String get milestone_12_hours_description;

  /// Short title for 2 weeks milestone
  ///
  /// In en, this message translates to:
  /// **'2 Weeks'**
  String get milestone_2_weeks_title;

  /// Description for the 2 weeks milestone
  ///
  /// In en, this message translates to:
  /// **'Circulation improves and lung function increases'**
  String get milestone_2_weeks_description;

  /// Short title for 1 month milestone
  ///
  /// In en, this message translates to:
  /// **'1 Month'**
  String get milestone_1_month_title;

  /// Description for the 1 month milestone
  ///
  /// In en, this message translates to:
  /// **'Coughing and shortness of breath decrease'**
  String get milestone_1_month_description;

  /// Short title for 3 months milestone
  ///
  /// In en, this message translates to:
  /// **'3 Months'**
  String get milestone_3_months_title;

  /// Description for the 3 months milestone
  ///
  /// In en, this message translates to:
  /// **'Risk of heart attack begins to drop'**
  String get milestone_3_months_description;

  /// Short title for 1 year milestone
  ///
  /// In en, this message translates to:
  /// **'1 Year'**
  String get milestone_1_year_title;

  /// Description for the 1 year milestone
  ///
  /// In en, this message translates to:
  /// **'Risk of heart disease is cut in half'**
  String get milestone_1_year_description;

  /// Label for synchronized money saved across devices
  ///
  /// In en, this message translates to:
  /// **'Synchronized Money Saved'**
  String get synchronizedMoneySaved;

  /// Display for total money saved
  ///
  /// In en, this message translates to:
  /// **'Total saved: {saved}'**
  String totalSaved(String saved);

  /// Encouraging prompt to start saving
  ///
  /// In en, this message translates to:
  /// **'Start saving money today!'**
  String get startSavingMoneyToday;

  /// Prompt to set quit date to enable savings calculation
  ///
  /// In en, this message translates to:
  /// **'Set your quit date to see savings'**
  String get setYourQuitDateToStartSaving;

  /// Welcome message for onboarding
  ///
  /// In en, this message translates to:
  /// **'Welcome to Your Journey!'**
  String get welcomeToYourJourney;

  /// Onboarding confirmation message
  ///
  /// In en, this message translates to:
  /// **'You\'re all set to start your smoke-free life. Let\'s begin this amazing journey together!'**
  String get youAreAllSetToStartYourSmokeFreeLife;

  /// Action label to skip a step
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Progress indicator for multi-step setup
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {totalSteps}'**
  String stepXofY(int currentStep, int totalSteps);

  /// Question asking the user for their quit date
  ///
  /// In en, this message translates to:
  /// **'When did you quit smoking?'**
  String get whenDidYouQuitSmoking;

  /// Instruction for selecting quit date during setup
  ///
  /// In en, this message translates to:
  /// **'Select your quit date to track your progress and celebrate milestones.'**
  String get selectYourQuitDateToTrackProgress;

  /// Prompt asking for smoking habit details
  ///
  /// In en, this message translates to:
  /// **'Tell us about your smoking habits'**
  String get tellUsAboutYourSmokingHabits;

  /// Explanation of why smoking habit data is collected
  ///
  /// In en, this message translates to:
  /// **'This helps us calculate your savings and personalize your experience.'**
  String get thisHelpsUsCalculateYourSavings;

  /// Prompt about enabling motivational notifications
  ///
  /// In en, this message translates to:
  /// **'Stay motivated with notifications'**
  String get stayMotivatedWithNotifications;

  /// Instruction to select support preferences
  ///
  /// In en, this message translates to:
  /// **'Choose how you\'d like to receive support and encouragement.'**
  String get chooseHowYoudLikeToReceiveSupport;

  /// Heading encouraging exploration of app features
  ///
  /// In en, this message translates to:
  /// **'Discover powerful features'**
  String get discoverPowerfulFeatures;

  /// Subtitle for feature exploration
  ///
  /// In en, this message translates to:
  /// **'Explore the tools that will support you on your smoke-free journey.'**
  String get exploreTheToolsThatWillSupportYou;

  /// Heading for the user's personalized dashboard
  ///
  /// In en, this message translates to:
  /// **'Your personalized dashboard'**
  String get yourPersonalizedDashboard;

  /// Description shown on dashboard preview during onboarding
  ///
  /// In en, this message translates to:
  /// **'Here\'s a preview of your progress based on the information you provided.'**
  String get dashboardPreviewDescription;

  /// Action label to continue
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// Action label to finish setup
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// Title for health progress section
  ///
  /// In en, this message translates to:
  /// **'Health Progress'**
  String get healthProgress;

  /// Label for the next health milestone
  ///
  /// In en, this message translates to:
  /// **'Next Health Milestone'**
  String get nextHealthMilestone;

  /// Short description for oxygen normalization milestone
  ///
  /// In en, this message translates to:
  /// **'Blood oxygen levels normalize'**
  String get bloodOxygenLevelsNormalize;

  /// Note describing how milestones are calculated
  ///
  /// In en, this message translates to:
  /// **'Based on your quit date and smoking habits'**
  String get basedOnYourQuitDateAndSmokingHabits;

  /// Short description about improvement in taste and smell
  ///
  /// In en, this message translates to:
  /// **'Taste and smell improve'**
  String get tasteAndSmellImprove;

  /// Short description about lung function increase
  ///
  /// In en, this message translates to:
  /// **'Lung function increases'**
  String get lungFunctionIncreases;

  /// Short description about heart disease risk reduction
  ///
  /// In en, this message translates to:
  /// **'Heart disease risk reduces'**
  String get heartDiseaseRiskReduces;

  /// Notification title when an achievement is unlocked
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked!'**
  String get achievementUnlocked;

  /// Prompt indicating first achievement is available
  ///
  /// In en, this message translates to:
  /// **'First Achievement Awaits'**
  String get firstAchievementAwaits;

  /// Message awarded for the first smoke-free day
  ///
  /// In en, this message translates to:
  /// **'First Day Champion - You\'ve completed your first smoke-free day!'**
  String get firstDayChampion;

  /// Prompt encouraging the user to complete first day milestone
  ///
  /// In en, this message translates to:
  /// **'Complete your first smoke-free day to earn your first badge'**
  String get firstDayChampionAwaits;

  /// Feature title for progress tracking
  ///
  /// In en, this message translates to:
  /// **'Progress Tracking'**
  String get feature_progress_tracking_title;

  /// Description for the progress tracking feature
  ///
  /// In en, this message translates to:
  /// **'Monitor your smoke-free journey with detailed statistics'**
  String get feature_progress_tracking_description;

  /// Feature title for health milestones
  ///
  /// In en, this message translates to:
  /// **'Health Milestones'**
  String get feature_health_milestones_title;

  /// Description for the health milestones feature
  ///
  /// In en, this message translates to:
  /// **'See how your body recovers over time'**
  String get feature_health_milestones_description;

  /// Feature title for achievement system
  ///
  /// In en, this message translates to:
  /// **'Achievement System'**
  String get feature_achievement_system_title;

  /// Description for the achievement system feature
  ///
  /// In en, this message translates to:
  /// **'Earn badges and rewards for your progress'**
  String get feature_achievement_system_description;

  /// Feature title for craving support
  ///
  /// In en, this message translates to:
  /// **'Craving Support'**
  String get feature_craving_support_title;

  /// Description for the craving support feature
  ///
  /// In en, this message translates to:
  /// **'Get instant help when you need it most'**
  String get feature_craving_support_description;

  /// Hint to explore app features
  ///
  /// In en, this message translates to:
  /// **'Tap any feature to explore'**
  String get tapAnyFeatureToExplore;

  /// Subheading for feature preview
  ///
  /// In en, this message translates to:
  /// **'Get a preview of what awaits you'**
  String get getAPreviewOfWhatAwaitsYou;

  /// Action label to close a modal or screen
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Action label to explore content
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// Title for daily motivation content
  ///
  /// In en, this message translates to:
  /// **'Daily Motivation'**
  String get dailyMotivation;

  /// Subtitle explaining daily motivational messages
  ///
  /// In en, this message translates to:
  /// **'Receive daily encouraging messages and tips'**
  String get receiveDailyEncouragingMessagesAndTips;

  /// Label for setting notification time
  ///
  /// In en, this message translates to:
  /// **'Notification Time'**
  String get notificationTime;

  /// Action label to change a setting
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Title for milestone alert settings
  ///
  /// In en, this message translates to:
  /// **'Milestone Alerts'**
  String get milestoneAlerts;

  /// Description for milestone alert preference
  ///
  /// In en, this message translates to:
  /// **'Get notified when you reach important milestones'**
  String get getNotifiedWhenYouReachImportantMilestones;

  /// Title for craving support feature
  ///
  /// In en, this message translates to:
  /// **'Craving Support'**
  String get cravingSupport;

  /// Description for craving support
  ///
  /// In en, this message translates to:
  /// **'Instant help and motivation during difficult moments'**
  String get instantHelpAndMotivationDuringDifficultMoments;

  /// Label for quit date and time selector
  ///
  /// In en, this message translates to:
  /// **'Quit Date & Time'**
  String get quitDateTime;

  /// Instruction to choose quit date and time
  ///
  /// In en, this message translates to:
  /// **'Select your quit date and time'**
  String get selectYourQuitDateAndTime;

  /// Action label to modify date and time
  ///
  /// In en, this message translates to:
  /// **'Change Date & Time'**
  String get changeDateAndTime;

  /// Action label to pick a date and time
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time'**
  String get selectDateAndTime;

  /// Question to collect years smoked before quitting
  ///
  /// In en, this message translates to:
  /// **'How many years have you been smoking?'**
  String get howManyYearsHaveYouBeenSmoking;

  /// Label for years smoked input
  ///
  /// In en, this message translates to:
  /// **'Years smoked before quitting'**
  String get yearsSmokedBeforeQuitting;

  /// Title for the health score dashboard
  ///
  /// In en, this message translates to:
  /// **'Health Score Dashboard'**
  String get healthScoreDashboard;

  /// Badge label for new features
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newText;

  /// Label explaining how to unlock an achievement
  ///
  /// In en, this message translates to:
  /// **'How To Unlock'**
  String get howToUnlock;

  /// Instruction to unlock an achievement
  ///
  /// In en, this message translates to:
  /// **'Complete the required actions to unlock this achievement.'**
  String get completeTheRequiredTasksToUnlockThisAchievement;

  /// Action label to share an achievement
  ///
  /// In en, this message translates to:
  /// **'Share Achievement'**
  String get shareAchievement;

  /// Label for total points earned
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get totalPoints;

  /// Label for user's level
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// Label showing progress toward next level
  ///
  /// In en, this message translates to:
  /// **'Progress to Level'**
  String get progressToLevel;

  /// Label indicating points remaining to next milestone
  ///
  /// In en, this message translates to:
  /// **'points to go'**
  String get pointsToGo;

  /// Label indicating points gained
  ///
  /// In en, this message translates to:
  /// **'points earned'**
  String get pointsEarned;

  /// Title for premium motivational content reward
  ///
  /// In en, this message translates to:
  /// **'Premium Motivational Content'**
  String get reward_premium_title;

  /// Description for premium motivational content reward
  ///
  /// In en, this message translates to:
  /// **'Access exclusive daily motivational quotes and success stories'**
  String get reward_premium_description;

  /// Title for ocean theme reward
  ///
  /// In en, this message translates to:
  /// **'Ocean Theme'**
  String get reward_ocean_title;

  /// Description for ocean theme reward
  ///
  /// In en, this message translates to:
  /// **'Beautiful ocean-themed app interface with calming colors'**
  String get reward_ocean_description;

  /// Title for forest theme reward
  ///
  /// In en, this message translates to:
  /// **'Forest Theme'**
  String get reward_forest_title;

  /// Description for forest theme reward
  ///
  /// In en, this message translates to:
  /// **'Nature-inspired green theme for a refreshing experience'**
  String get reward_forest_description;

  /// Title for charity donation reward
  ///
  /// In en, this message translates to:
  /// **'Charity Donation'**
  String get reward_charity_title;

  /// Description for charity donation reward
  ///
  /// In en, this message translates to:
  /// **'Donate \$5 to lung cancer research in your name'**
  String get reward_charity_description;

  /// Title for advanced statistics reward
  ///
  /// In en, this message translates to:
  /// **'Advanced Statistics'**
  String get reward_stats_title;

  /// Description for advanced statistics reward
  ///
  /// In en, this message translates to:
  /// **'Unlock detailed health analytics and progress insights'**
  String get reward_stats_description;

  /// Title for personal coach session reward
  ///
  /// In en, this message translates to:
  /// **'Personal Coach Session'**
  String get reward_coach_title;

  /// Description for coach session reward
  ///
  /// In en, this message translates to:
  /// **'30-minute virtual session with a certified quit coach'**
  String get reward_coach_description;

  /// Title for reward redemption confirmation
  ///
  /// In en, this message translates to:
  /// **'Confirm Redemption'**
  String get confirmRedemption;

  /// Confirmation prompt for redeeming a reward
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to redeem {title} for {points} points?'**
  String areYouSureYouWantToRedeem(String title, int points);

  /// Shows remaining points after redemption
  ///
  /// In en, this message translates to:
  /// **'You will have {availablePoints} points remaining.'**
  String youWillHave(int availablePoints);

  /// Confirmation after reward redemption
  ///
  /// In en, this message translates to:
  /// **'You have successfully redeemed {title}. Check your profile for details.'**
  String youHaveSuccessfullyRedeemed(String title);

  /// Notification title after successful redemption
  ///
  /// In en, this message translates to:
  /// **'Reward Redeemed!'**
  String get rewardRedeemed;

  /// Affirming label
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get great;

  /// Encouraging message
  ///
  /// In en, this message translates to:
  /// **'You\'re doing great!'**
  String get youreDoingGreat;

  /// Display showing number of smoke-free days
  ///
  /// In en, this message translates to:
  /// **'{daysSinceQuit} days smoke-free'**
  String daysSinceQuit(int daysSinceQuit);

  /// Label indicating no cigarettes smoked
  ///
  /// In en, this message translates to:
  /// **'Not Smoked'**
  String get notSmoked;

  /// Title for breathing exercise card
  ///
  /// In en, this message translates to:
  /// **'Breathing\nExercise'**
  String get breathingExercise;

  /// Title for support call action
  ///
  /// In en, this message translates to:
  /// **'Call\nSupport'**
  String get callSupport;

  /// Title for view progress action
  ///
  /// In en, this message translates to:
  /// **'View\nProgress'**
  String get viewProgress;

  /// Title for distraction games section
  ///
  /// In en, this message translates to:
  /// **'Distraction Games'**
  String get distractionGames;

  /// Prompt shown when user has a craving
  ///
  /// In en, this message translates to:
  /// **'Having a craving? You\'re not alone. Choose a coping strategy below.'**
  String get havingACraving;

  /// Title for recent coping activities list
  ///
  /// In en, this message translates to:
  /// **'Recent Coping Sessions'**
  String get recentCopingSessions;

  /// Label for quick breathing exercise
  ///
  /// In en, this message translates to:
  /// **'Quick Breathe'**
  String get quickBreathe;

  /// Prompt to configure emergency contact
  ///
  /// In en, this message translates to:
  /// **'Set up your emergency contact in Settings'**
  String get callingEmergencyContact;

  /// Label for settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Action label to call emergency contact
  ///
  /// In en, this message translates to:
  /// **'Call Emergency Contact'**
  String get callEmergencyContact;

  /// Instruction to contact designated support person
  ///
  /// In en, this message translates to:
  /// **'Reach out to your support person'**
  String get reachOutToYourDesignatedContact;

  /// Action label to get help
  ///
  /// In en, this message translates to:
  /// **'Get Support'**
  String get getSupport;

  /// Confirmation after logging a coping session
  ///
  /// In en, this message translates to:
  /// **'Craving session logged. Great job using {method}!'**
  String cravingSessionLogged(String method);

  /// Title for quick coping tips
  ///
  /// In en, this message translates to:
  /// **'Quick Coping Tips'**
  String get quickCopingTips;

  /// Call-to-action to try a coping strategy immediately
  ///
  /// In en, this message translates to:
  /// **'Try This Now'**
  String get tryThisNow;

  /// Positive feedback after selecting a coping strategy
  ///
  /// In en, this message translates to:
  /// **'Great choice! {title} is an effective coping strategy.'**
  String greatCopingStrategyChoice(String title);

  /// Label for health benefits section
  ///
  /// In en, this message translates to:
  /// **'Health Benefits'**
  String get healthBenefits;

  /// Title for drink water coping strategy
  ///
  /// In en, this message translates to:
  /// **'Drink Water'**
  String get coping_drink_water_title;

  /// Description for drink water coping strategy
  ///
  /// In en, this message translates to:
  /// **'Hydrate your body and keep your hands busy. Water helps flush toxins and reduces cravings.'**
  String get coping_drink_water_description;

  /// Suggested duration for the drink water strategy
  ///
  /// In en, this message translates to:
  /// **'2-3 minutes'**
  String get coping_drink_water_duration;

  /// Title for take a walk coping strategy
  ///
  /// In en, this message translates to:
  /// **'Take a Walk'**
  String get coping_take_a_walk_title;

  /// Description for take a walk coping strategy
  ///
  /// In en, this message translates to:
  /// **'Get moving! Physical activity releases endorphins and distracts from cravings.'**
  String get coping_take_a_walk_description;

  /// Suggested duration for the walk strategy
  ///
  /// In en, this message translates to:
  /// **'5-10 minutes'**
  String get coping_take_a_walk_duration;

  /// Title for call a friend coping strategy
  ///
  /// In en, this message translates to:
  /// **'Call a Friend'**
  String get coping_call_a_friend_title;

  /// Description for call a friend coping strategy
  ///
  /// In en, this message translates to:
  /// **'Reach out for support. Talking to someone can provide motivation and distraction.'**
  String get coping_call_a_friend_description;

  /// Suggested duration for the call-a-friend strategy
  ///
  /// In en, this message translates to:
  /// **'5-15 minutes'**
  String get coping_call_a_friend_duration;

  /// Title for review your reasons strategy
  ///
  /// In en, this message translates to:
  /// **'Review Your Reasons'**
  String get coping_review_reasons_title;

  /// Description for review your reasons strategy
  ///
  /// In en, this message translates to:
  /// **'Remember why you decided to quit. Focus on your health, family, and financial goals.'**
  String get coping_review_reasons_description;

  /// Suggested duration for the review reasons strategy
  ///
  /// In en, this message translates to:
  /// **'3-5 minutes'**
  String get coping_review_reasons_duration;

  /// Title for deep breathing coping strategy
  ///
  /// In en, this message translates to:
  /// **'Deep Breathing'**
  String get coping_deep_breathing_title;

  /// Description for deep breathing strategy
  ///
  /// In en, this message translates to:
  /// **'Practice slow, deep breaths. Inhale for 4, hold for 4, exhale for 4 seconds.'**
  String get coping_deep_breathing_description;

  /// Suggested duration for deep breathing exercise
  ///
  /// In en, this message translates to:
  /// **'2-5 minutes'**
  String get coping_deep_breathing_duration;

  /// Title for chew gum coping strategy
  ///
  /// In en, this message translates to:
  /// **'Chew Gum'**
  String get coping_chew_gum_title;

  /// Description for chew gum strategy
  ///
  /// In en, this message translates to:
  /// **'Keep your mouth busy with sugar-free gum. It helps with oral fixation habits.'**
  String get coping_chew_gum_description;

  /// Suggested duration for chew gum strategy
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get coping_chew_gum_duration;

  /// Title for listen to music coping strategy
  ///
  /// In en, this message translates to:
  /// **'Listen to Music'**
  String get coping_listen_music_title;

  /// Description for listen to music strategy
  ///
  /// In en, this message translates to:
  /// **'Put on your favorite playlist. Music can improve mood and provide distraction.'**
  String get coping_listen_music_description;

  /// Suggested duration for listening to music
  ///
  /// In en, this message translates to:
  /// **'3-10 minutes'**
  String get coping_listen_music_duration;

  /// Title for practice gratitude coping strategy
  ///
  /// In en, this message translates to:
  /// **'Practice Gratitude'**
  String get coping_gratitude_title;

  /// Description for gratitude practice strategy
  ///
  /// In en, this message translates to:
  /// **'Think of three things you\'re grateful for. Positive thinking reduces stress and cravings.'**
  String get coping_gratitude_description;

  /// Suggested duration for gratitude exercise
  ///
  /// In en, this message translates to:
  /// **'2-3 minutes'**
  String get coping_gratitude_duration;

  /// Label indicating high effectiveness
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get coping_effectiveness_high;

  /// Label indicating very high effectiveness
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get coping_effectiveness_very_high;

  /// Label indicating medium effectiveness
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get coping_effectiveness_medium;

  /// Title for color focus distraction challenge
  ///
  /// In en, this message translates to:
  /// **'Color Focus Challenge'**
  String get colorFocusChallenge;

  /// Instruction for the color focus challenge
  ///
  /// In en, this message translates to:
  /// **'Find 5 {randomColor} objects around you'**
  String findFiveObjects(String randomColor);

  /// Detailed instructions for the color focus challenge
  ///
  /// In en, this message translates to:
  /// **'Look around your environment and identify 5 objects that are {randomColor}. Take your time and focus on each object.'**
  String lookAroundAndIdentifyFiveObjects(String randomColor);

  /// Action label to start a new color challenge
  ///
  /// In en, this message translates to:
  /// **'New Color Challenge'**
  String get newColorChallenge;

  /// Title for counting distraction challenge
  ///
  /// In en, this message translates to:
  /// **'Counting Challenge'**
  String get countingChallenge;

  /// Description for counting challenge
  ///
  /// In en, this message translates to:
  /// **'This mental math exercise requires focus and concentration, helping distract from cravings.'**
  String get countingGameDescription;

  /// Action label to reveal a hint
  ///
  /// In en, this message translates to:
  /// **'Show Hint'**
  String get showHint;

  /// Action label to get a new challenge
  ///
  /// In en, this message translates to:
  /// **'New Challenge'**
  String get newChallenge;

  /// Title for memory palace exercise
  ///
  /// In en, this message translates to:
  /// **'Memory Palace'**
  String get memoryPalace;

  /// Prompt to start the memory palace visualization
  ///
  /// In en, this message translates to:
  /// **'Visualize your childhood home'**
  String get visualizeChildhoodHome;

  /// Label for instruction section
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// Step-by-step instructions for the memory palace exercise
  ///
  /// In en, this message translates to:
  /// **'1. Close your eyes and imagine walking through your childhood home\n\n2. Start at the front door and move room by room\n\n3. Notice details: colors, furniture, decorations\n\n4. Spend time in each room remembering specific objects\n\n5. Try to recall sounds, smells, and feelings'**
  String get memoryPalaceInstructions;

  /// Completion message for the memory palace exercise
  ///
  /// In en, this message translates to:
  /// **'Great job! Memory exercises strengthen focus and reduce cravings.'**
  String get memoryPalaceCompletionMessage;

  /// Action label to complete an exercise
  ///
  /// In en, this message translates to:
  /// **'Complete Exercise'**
  String get completeExercise;

  /// Title for word association exercise
  ///
  /// In en, this message translates to:
  /// **'Word Association'**
  String get wordAssociation;

  /// Label for the starting word in the exercise
  ///
  /// In en, this message translates to:
  /// **'Starting word'**
  String get startingWord;

  /// Instructions for the word association exercise
  ///
  /// In en, this message translates to:
  /// **'Create a chain of related words. Each new word should connect to the previous one.'**
  String get wordAssociationInstructions;

  /// Example chain for word association exercise
  ///
  /// In en, this message translates to:
  /// **'Example: Ocean → Water → Rain → Clouds → Sky → Birds → Freedom'**
  String get wordAssociationExample;

  /// Action label to generate a new starting word
  ///
  /// In en, this message translates to:
  /// **'New Starting Word'**
  String get newStartingWord;

  /// Themed label: Ocean
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get ocean;

  /// Themed label: Mountain
  ///
  /// In en, this message translates to:
  /// **'Mountain'**
  String get mountain;

  /// Themed label: Forest
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forest;

  /// Themed label: City
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// Themed label: Garden
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get garden;

  /// Themed label: Library
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// Themed label: Kitchen
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get kitchen;

  /// Themed label: Music
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// Motivational quote
  ///
  /// In en, this message translates to:
  /// **'Every breath is a new beginning'**
  String get everyBreathIsANewBeginning;

  /// Motivational quote
  ///
  /// In en, this message translates to:
  /// **'You are stronger than your cravings'**
  String get youAreStrongerThanYourCravings;

  /// Motivational quote
  ///
  /// In en, this message translates to:
  /// **'This moment will pass, you will overcome'**
  String get thisMomentWillPass;

  /// Motivational quote
  ///
  /// In en, this message translates to:
  /// **'Breathe in peace, breathe out stress'**
  String get breatheInPeace;

  /// Motivational quote
  ///
  /// In en, this message translates to:
  /// **'Your health is worth every breath'**
  String get yourHealthIsWorthEveryBreath;

  /// Motivational quote
  ///
  /// In en, this message translates to:
  /// **'One breath at a time, one day at a time'**
  String get oneBreathAtATime;

  /// Label for inhale phase of breathing exercise
  ///
  /// In en, this message translates to:
  /// **'Inhale'**
  String get inhale;

  /// Label for hold phase of breathing exercise
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get hold;

  /// Label for exhale phase of breathing exercise
  ///
  /// In en, this message translates to:
  /// **'Exhale'**
  String get exhale;

  /// Prompt before starting a breathing exercise
  ///
  /// In en, this message translates to:
  /// **'Ready to breathe?'**
  String get readyToBreathe;

  /// Title for the 4-7-8 breathing technique
  ///
  /// In en, this message translates to:
  /// **'4-7-8 Breathing Technique'**
  String get fourSevenEightTechnique;

  /// Action label to begin an exercise
  ///
  /// In en, this message translates to:
  /// **'Start Exercise'**
  String get startExercise;

  /// Action label to extend an exercise
  ///
  /// In en, this message translates to:
  /// **'Extend (+2 cycles)'**
  String get extendExercise;

  /// Action label to stop an exercise
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopExercise;

  /// Notification shown when a new quote loads
  ///
  /// In en, this message translates to:
  /// **'New motivational quote loaded!'**
  String get newMotivationalQuoteLoaded;

  /// Error message when quote refresh fails
  ///
  /// In en, this message translates to:
  /// **'Failed to refresh quote. Try again later.'**
  String get failedToRefreshQuote;

  /// Title for quote refresh scheduling
  ///
  /// In en, this message translates to:
  /// **'Quote Schedule'**
  String get quoteSchedule;

  /// Label for schedule refresh settings
  ///
  /// In en, this message translates to:
  /// **'Refresh Schedule'**
  String get refreshSchedule;

  /// Label showing next scheduled refresh
  ///
  /// In en, this message translates to:
  /// **'Next Refresh'**
  String get nextRefresh;

  /// Label for total number of available quotes
  ///
  /// In en, this message translates to:
  /// **'Total Quotes'**
  String get totalQuotes;

  /// Label for the current scheduling period
  ///
  /// In en, this message translates to:
  /// **'Current Period'**
  String get currentPeriod;

  /// Display for number of unique quotes
  ///
  /// In en, this message translates to:
  /// **'{number} unique quotes'**
  String xUniqueQuotes(int number);

  /// Displays time until next refresh
  ///
  /// In en, this message translates to:
  /// **'{nextRefreshPeriod} in {hours}h {minutes}m'**
  String periodInHoursAndMinutes(String nextRefreshPeriod, int hours, int minutes);

  /// Informational note about quote refresh schedule
  ///
  /// In en, this message translates to:
  /// **'Quotes automatically refresh at 6 AM and 6 PM every day to keep you motivated throughout your quit-smoking journey!'**
  String get quoteInfoNote;

  /// Acknowledgement button label
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotIt;

  /// Informational text about auto-refresh frequency
  ///
  /// In en, this message translates to:
  /// **'Auto-refreshes 2x daily'**
  String get autoRefreshesFrequency;

  /// Prompt preceding emergency contact numbers
  ///
  /// In en, this message translates to:
  /// **'Call your support person or quitline:'**
  String get callYourSupportPersonOrQuitline;

  /// Title for emergency support section
  ///
  /// In en, this message translates to:
  /// **'Emergency Support'**
  String get emergencySupport;

  /// Expression of thanks
  ///
  /// In en, this message translates to:
  /// **'Thank You'**
  String get thankYou;

  /// Encouraging message
  ///
  /// In en, this message translates to:
  /// **'You\'ve Got This!'**
  String get youveGotThis;

  /// Navigation label to go back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Action label to start something
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Description for the 4-7-8 technique
  ///
  /// In en, this message translates to:
  /// **'Breathe in for 4, hold for 7, exhale for 8'**
  String get fourSevenEightTechniqueDescription;

  /// Prompt to select the preferred coping strategy
  ///
  /// In en, this message translates to:
  /// **'Choose what helps you most right now:'**
  String get chooseWhatHelpsYouMostRightNow;

  /// Title for breathing exercise card
  ///
  /// In en, this message translates to:
  /// **'Breathing Exercise'**
  String get breathing_exercise_title;

  /// Subtitle describing the breathing exercise technique
  ///
  /// In en, this message translates to:
  /// **'4-7-8 technique to reduce cravings'**
  String get breathing_exercise_subtitle;

  /// Title for motivational quote card
  ///
  /// In en, this message translates to:
  /// **'Motivational Quote'**
  String get motivational_quote_title;

  /// Subtitle for the motivational quote section
  ///
  /// In en, this message translates to:
  /// **'Get instant encouragement'**
  String get motivational_quote_subtitle;

  /// Title for emergency contact action
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergency_contact_title;

  /// Subtitle explaining the emergency contact action
  ///
  /// In en, this message translates to:
  /// **'Call your support person'**
  String get emergency_contact_subtitle;

  /// Title for distraction activity card
  ///
  /// In en, this message translates to:
  /// **'Distraction Activity'**
  String get distraction_activity_title;

  /// Subtitle describing short distraction activities
  ///
  /// In en, this message translates to:
  /// **'Quick 5-minute activities'**
  String get distraction_activity_subtitle;

  /// Motivational quote 1
  ///
  /// In en, this message translates to:
  /// **'Every cigarette you don\'t smoke is doing you good.'**
  String get quote_1;

  /// Motivational quote 2
  ///
  /// In en, this message translates to:
  /// **'You are stronger than your cravings.'**
  String get quote_2;

  /// Motivational quote 3
  ///
  /// In en, this message translates to:
  /// **'This craving will pass. You\'ve got this!'**
  String get quote_3;

  /// Motivational quote 4
  ///
  /// In en, this message translates to:
  /// **'Think of how proud you\'ll be tomorrow.'**
  String get quote_4;

  /// Motivational quote 5
  ///
  /// In en, this message translates to:
  /// **'Your health is worth more than any cigarette.'**
  String get quote_5;

  /// Distraction activity 1
  ///
  /// In en, this message translates to:
  /// **'Do 10 jumping jacks'**
  String get activity_1;

  /// Distraction activity 2
  ///
  /// In en, this message translates to:
  /// **'Drink a glass of water slowly'**
  String get activity_2;

  /// Distraction activity 3
  ///
  /// In en, this message translates to:
  /// **'Take 5 deep breaths'**
  String get activity_3;

  /// Distraction activity 4
  ///
  /// In en, this message translates to:
  /// **'Call a friend or family member'**
  String get activity_4;

  /// Distraction activity 5
  ///
  /// In en, this message translates to:
  /// **'Go for a short walk'**
  String get activity_5;

  /// Distraction activity 6
  ///
  /// In en, this message translates to:
  /// **'Listen to your favorite song'**
  String get activity_6;

  /// Title for health recovery progress section
  ///
  /// In en, this message translates to:
  /// **'Health Recovery Progress'**
  String get healthRecoveryProgress;

  /// Label indicating achieved milestones
  ///
  /// In en, this message translates to:
  /// **'Milestones Achieved'**
  String get milestonesAchieved;

  /// Encouraging message about recovery progress
  ///
  /// In en, this message translates to:
  /// **'Amazing progress! Your body is healing beautifully.'**
  String get amazingProgress;

  /// Message about cumulative impact of milestones
  ///
  /// In en, this message translates to:
  /// **'Every milestone brings you closer to complete recovery.'**
  String get everyMilestoneBringsYouCloserToCompleteRecovery;

  /// Action label to save changes
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Action label to cancel an action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label showing the current time
  ///
  /// In en, this message translates to:
  /// **'Current Time'**
  String get currentTime;

  /// Action label to view details
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Title for preview of synchronized export
  ///
  /// In en, this message translates to:
  /// **'Synchronized Export Preview'**
  String get synchronizedExportPreview;

  /// Message shown while initializing user journey
  ///
  /// In en, this message translates to:
  /// **'Initializing your quit journey...'**
  String get initializingYourQuitJourney;

  /// Message shown while user preferences load
  ///
  /// In en, this message translates to:
  /// **'Loading user preferences...'**
  String get loadingUserPreferences;

  /// Message displayed while verifying quit date
  ///
  /// In en, this message translates to:
  /// **'Checking quit date...'**
  String get checkingQuitDate;

  /// Message shown while progress data loads
  ///
  /// In en, this message translates to:
  /// **'Loading progress data...'**
  String get loadingProgressData;

  /// Message shown while streak is calculated
  ///
  /// In en, this message translates to:
  /// **'Calculating streak...'**
  String get calculatingStreak;

  /// Message shown while motivational content is prepared
  ///
  /// In en, this message translates to:
  /// **'Preparing motivational content...'**
  String get preparingMotivationalContent;

  /// Title for breakdown of health categories
  ///
  /// In en, this message translates to:
  /// **'Health Category Breakdown'**
  String get healthCategoryBreakdown;

  /// Action label to edit quit details
  ///
  /// In en, this message translates to:
  /// **'Edit Quit Details'**
  String get editQuitDetails;

  /// Instruction describing quit information updates and sync
  ///
  /// In en, this message translates to:
  /// **'Update your quit information. Changes will sync across all app features.'**
  String get updateQuitInformation;

  /// Label for years smoked input
  ///
  /// In en, this message translates to:
  /// **'Years of Smoking'**
  String get yearsOfSmoking;

  /// Label for daily cigarettes input
  ///
  /// In en, this message translates to:
  /// **'Daily Cigarettes'**
  String get dailyCigarettes;

  /// Unit label for cigarettes per day
  ///
  /// In en, this message translates to:
  /// **'cigarettes per day'**
  String get cigarettesPerDay;

  /// Label for cost per pack input
  ///
  /// In en, this message translates to:
  /// **'Pack Cost'**
  String get packCost;

  /// Action label to save modified settings
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Label for overall health score
  ///
  /// In en, this message translates to:
  /// **'Overall Health Score'**
  String get overallHealthScore;

  /// Label representing number of days quit
  ///
  /// In en, this message translates to:
  /// **'Days Quit'**
  String get daysQuit;

  /// Label for quit duration display
  ///
  /// In en, this message translates to:
  /// **'Quit Duration'**
  String get quitDuration;

  /// Label for recovery metric
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get recovery;

  /// Rating label: excellent
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// Rating label: good
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// Rating label: improving
  ///
  /// In en, this message translates to:
  /// **'Improving'**
  String get improving;
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
