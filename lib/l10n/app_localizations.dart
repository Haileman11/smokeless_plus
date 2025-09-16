import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('es'),
    Locale('ar'),
  ];

  // Navigation
  String get dashboard;
  String get healthTimeline;
  String get rewards;
  String get journal;
  String get trophies;
  String get settings;

  // Dashboard
  String get welcomeBack;
  String get timeSmokeFreeDays;
  String get timeSmokeFreeDaysLabel;
  String get timeSmokeFreHours;
  String get timeSmokeFreMinutes;
  String get cigarettesAvoided;
  String get moneySaved;
  String get currentStreak;
  String get dailyProgress;
  String get weeklyProgress;
  String get monthlyProgress;
  String get yearlyProgress;
  String get smokeFree;
  String get emergency;
  String get motivationalQuote;
  String get statsOverview;
  String get noStatsAvailable;
  String get completeProfile;

  // Health Milestones
  String get healthMilestones;
  String get achieved;
  String get completeProgress;
  String get yourHealthProgress;
  String get timelineDescription;
  String get bloodPressureHeartRateDrop;
  String get carbonMonoxideNormalize;
  String get heartAttackRiskDecrease;
  String get airwaysRelax;
  String get circulationImprove;
  String get lungsCleanUp;
  String get nervesRegenerate;
  String get lungCancerRiskHalved;
  String get heartRateBloodPressureDesc;
  String get carbonMonoxideDesc;
  String get heartAttackRiskDesc;
  String get airwaysDesc;
  String get circulationDesc;
  String get lungsDesc;
  String get nervesDesc;
  String get lungCancerDesc;
  String get minutesRemaining;
  String get hoursRemaining;
  String get daysRemaining;
  String get monthsRemaining;
  String get yearsRemaining;
  String get achievedExclamation;
  String get willUnlockOn;

  // Rewards
  String get yourRewards;
  String get addReward;
  String get addNewReward;
  String get whatsYourReward;
  String get howMuchCost;
  String get rewardPlaceholder;
  String get congratulationsReward;
  String get enjoyReward;
  String get moneySavedSoFar;
  String get redeem;
  String get rewardCreated;
  String get deleteReward;

  // Journal
  String get journalTitle;
  String get addEntry;
  String get howAreYouFeeling;
  String get writeYourThoughts;
  String get moodGreat;
  String get moodGood;
  String get moodOkay;
  String get moodBad;
  String get moodTerrible;
  String get saving;
  String get recentEntries;
  String get entrySaved;
  String get journalEntryCreated;
  String get failedToSaveEntry;

  // Craving SOS
  String get cravingSOS;
  String get breathingExercise;
  String get walkingExercise;
  String get playGame;
  String get selectActivity;
  String get greatJob;
  String get handledCravingPro;

  // Settings
  String get language;
  String get selectLanguage;
  String get exportData;
  String get clearData;
  String get about;
  String get version;
  String get dataExported;
  String get dataCleared;
  String get languageChanged;

  // Onboarding
  String get welcomeToSmokeLess;
  String get letsGetStarted;
  String get whyQuitting;
  String get reasonHealth;
  String get reasonMoney;
  String get reasonFamily;
  String get reasonFreedom;
  String get congratulations;
  String get healthyChoice;
  String get setupProfile;
  String get quitDate;
  String get quitTime;
  String get smokingHistory;
  String get cigarettesPerDay;
  String get yearsSmokingLabel;
  String get pricePerPack;
  String get cigarettesPerPack;
  String get currency;
  String get selectCurrency;
  String get profileComplete;
  String get letsGo;

  // Common
  String get error;
  String get save;
  String get cancel;
  String get delete;
  String get back;
  String get next;
  String get done;
  String get getStarted;

  // Languages
  String get english;
  String get french;
  String get spanish;
  String get arabic;

  // Future state messages
  String get quitJourneyBeginsSoon;
  String get prepareForJourney;
  String get journeyStartsHere;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'es', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'fr':
        return AppLocalizationsFr();
      case 'es':
        return AppLocalizationsEs();
      case 'ar':
        return AppLocalizationsAr();
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Import the language-specific implementations
class AppLocalizationsEn extends AppLocalizations {
  @override String get dashboard => 'Dashboard';
  @override String get healthTimeline => 'Health Timeline';
  @override String get rewards => 'Rewards';
  @override String get journal => 'Journal';
  @override String get trophies => 'Trophies';
  @override String get settings => 'Settings';
  @override String get welcomeBack => 'Welcome back!';
  @override String get timeSmokeFreeDays => 'smoke-free days';
  @override String get timeSmokeFreeDaysLabel => 'Days';
  @override String get timeSmokeFreHours => 'hours';
  @override String get timeSmokeFreMinutes => 'minutes';
  @override String get cigarettesAvoided => 'Cigarettes Avoided';
  @override String get moneySaved => 'Money Saved';
  @override String get currentStreak => 'Current Streak';
  @override String get dailyProgress => 'Daily Progress';
  @override String get weeklyProgress => 'Weekly Progress';
  @override String get monthlyProgress => 'Monthly Progress';
  @override String get yearlyProgress => 'Yearly Progress';
  @override String get smokeFree => 'Smoke Free';
  @override String get emergency => 'Emergency';
  @override String get motivationalQuote => 'Keep going! Every smoke-free moment is a victory.';
  @override String get statsOverview => 'Your Progress Overview';
  @override String get noStatsAvailable => 'No stats available';
  @override String get completeProfile => 'Complete your profile setup to track your health milestones';
  @override String get healthMilestones => 'Health Milestones';
  @override String get achieved => 'ACHIEVED';
  @override String get completeProgress => 'complete';
  @override String get yourHealthProgress => 'Your Health Progress';
  @override String get timelineDescription => 'Track your health improvements over time';
  @override String get bloodPressureHeartRateDrop => 'Blood Pressure & Heart Rate Drop';
  @override String get carbonMonoxideNormalize => 'Carbon Monoxide Levels Normalize';
  @override String get heartAttackRiskDecrease => 'Heart Attack Risk Decreases';
  @override String get airwaysRelax => 'Airways Begin to Relax';
  @override String get circulationImprove => 'Circulation Improves';
  @override String get lungsCleanUp => 'Lung Cilia Regrow & Clean Up';
  @override String get nervesRegenerate => 'Nerve Endings Regenerate';
  @override String get lungCancerRiskHalved => 'Lung Cancer Risk Halved';
  @override String get heartRateBloodPressureDesc => 'Your heart rate and blood pressure begin to return to normal levels';
  @override String get carbonMonoxideDesc => 'Carbon monoxide in your blood drops to normal levels, oxygen increases';
  @override String get heartAttackRiskDesc => 'Your risk of heart attack begins to decrease significantly';
  @override String get airwaysDesc => 'Bronchial tubes relax and breathing becomes easier';
  @override String get circulationDesc => 'Blood circulation improves and continues improving for weeks';
  @override String get lungsDesc => 'Tiny hairs in lungs regrow and help remove tar and debris';
  @override String get nervesDesc => 'Damaged nerve endings start to regrow, improving taste and smell';
  @override String get lungCancerDesc => 'Risk of lung cancer falls to half that of a smoker';
  @override String get minutesRemaining => 'm remaining';
  @override String get hoursRemaining => 'h remaining';
  @override String get daysRemaining => 'd remaining';
  @override String get monthsRemaining => 'mo remaining';
  @override String get yearsRemaining => 'y remaining';
  @override String get achievedExclamation => 'Achieved!';
  @override String get willUnlockOn => 'Will unlock on';
  @override String get yourRewards => 'Your Rewards';
  @override String get addReward => 'Add reward';
  @override String get addNewReward => 'Add New Reward';
  @override String get whatsYourReward => 'What\'s your reward?';
  @override String get howMuchCost => 'How much does it cost?';
  @override String get rewardPlaceholder => 'New sneakers, dinner out, etc.';
  @override String get congratulationsReward => 'Congratulations! 🎉';
  @override String get enjoyReward => 'Enjoy your well-earned reward!';
  @override String get moneySavedSoFar => 'Money saved so far';
  @override String get redeem => 'Redeem';
  @override String get rewardCreated => 'Reward created successfully!';
  @override String get deleteReward => 'Delete reward';
  @override String get journalTitle => 'Daily Journal';
  @override String get addEntry => 'Add Entry';
  @override String get howAreYouFeeling => 'How are you feeling today?';
  @override String get writeYourThoughts => 'Write your thoughts and feelings...';
  @override String get moodGreat => 'Great';
  @override String get moodGood => 'Good';
  @override String get moodOkay => 'Okay';
  @override String get moodBad => 'Bad';
  @override String get moodTerrible => 'Terrible';
  @override String get saving => 'Saving...';
  @override String get recentEntries => 'Recent Entries';
  @override String get entrySaved => 'Entry saved! 📝';
  @override String get journalEntryCreated => 'Journal entry created successfully!';
  @override String get failedToSaveEntry => 'Failed to save journal entry';
  @override String get cravingSOS => 'Craving SOS';
  @override String get breathingExercise => 'Breathing Exercise';
  @override String get walkingExercise => 'Walking Exercise';
  @override String get playGame => 'Play Game';
  @override String get selectActivity => 'Choose an activity to help with your craving:';
  @override String get greatJob => 'Great job! 🎉';
  @override String get handledCravingPro => 'You handled that craving like a pro.';
  @override String get language => 'Language';
  @override String get selectLanguage => 'Select Language';
  @override String get exportData => 'Export Data';
  @override String get clearData => 'Clear All Data';
  @override String get about => 'About';
  @override String get version => 'Version';
  @override String get dataExported => 'Data exported successfully!';
  @override String get dataCleared => 'All data has been cleared. Restarting app...';
  @override String get languageChanged => 'Language changed successfully!';
  @override String get welcomeToSmokeLess => 'Welcome to SmokeLess+';
  @override String get letsGetStarted => 'Let\'s get started on your quit journey';
  @override String get whyQuitting => 'Why are you quitting?';
  @override String get reasonHealth => 'Better health';
  @override String get reasonMoney => 'Save money';
  @override String get reasonFamily => 'Family reasons';
  @override String get reasonFreedom => 'Personal freedom';
  @override String get congratulations => 'Congratulations!';
  @override String get healthyChoice => 'You\'ve taken the most important step towards a healthier, smoke-free life!';
  @override String get setupProfile => 'Set Up My Profile';
  @override String get quitDate => 'When did you quit?';
  @override String get quitTime => 'What time?';
  @override String get smokingHistory => 'Tell us about your smoking';
  @override String get cigarettesPerDay => 'Cigarettes per day';
  @override String get yearsSmokingLabel => 'Years smoking';
  @override String get pricePerPack => 'Price per pack';
  @override String get cigarettesPerPack => 'Cigarettes per pack';
  @override String get currency => 'Currency';
  @override String get selectCurrency => 'Select currency';
  @override String get profileComplete => 'Profile completed successfully!';
  @override String get letsGo => 'Let\'s Go!';
  @override String get error => 'Error';
  @override String get save => 'Save';
  @override String get cancel => 'Cancel';
  @override String get delete => 'Delete';
  @override String get back => 'Back';
  @override String get next => 'Next';
  @override String get done => 'Done';
  @override String get getStarted => 'Get Started';
  @override String get english => 'English';
  @override String get french => 'Français';
  @override String get spanish => 'Español';
  @override String get arabic => 'العربية';
  @override String get quitJourneyBeginsSoon => 'Your quit journey begins soon!';
  @override String get prepareForJourney => 'Prepare yourself for the amazing journey ahead.';
  @override String get journeyStartsHere => 'Your journey to freedom starts here';
}

class AppLocalizationsFr extends AppLocalizations {
  @override String get dashboard => 'Tableau de Bord';
  @override String get healthTimeline => 'Chronologie de Santé';
  @override String get rewards => 'Récompenses';
  @override String get journal => 'Journal';
  @override String get trophies => 'Trophées';
  @override String get settings => 'Paramètres';
  // Add more French translations...
  @override String get welcomeBack => 'Bon retour !';
  @override String get timeSmokeFreeDays => 'jours sans tabac';
  @override String get timeSmokeFreeDaysLabel => 'Jours';
  @override String get timeSmokeFreHours => 'heures';
  @override String get timeSmokeFreMinutes => 'minutes';
  @override String get cigarettesAvoided => 'Cigarettes Évitées';
  @override String get moneySaved => 'Argent Économisé';
  @override String get currentStreak => 'Série Actuelle';
  @override String get dailyProgress => 'Progrès Quotidien';
  @override String get weeklyProgress => 'Progrès Hebdomadaire';
  @override String get monthlyProgress => 'Progrès Mensuel';
  @override String get yearlyProgress => 'Progrès Annuel';
  @override String get smokeFree => 'Sans Tabac';
  @override String get emergency => 'Urgence';
  @override String get motivationalQuote => 'Continuez ! Chaque moment sans tabac est une victoire.';
  @override String get statsOverview => 'Aperçu de Vos Progrès';
  @override String get noStatsAvailable => 'Aucune statistique disponible';
  @override String get completeProfile => 'Complétez votre profil pour suivre vos étapes de santé';
  @override String get healthMilestones => 'Étapes de Santé';
  @override String get achieved => 'ACCOMPLI';
  @override String get completeProgress => 'terminé';
  @override String get yourHealthProgress => 'Votre Progression de Santé';
  @override String get timelineDescription => 'Suivez vos améliorations de santé au fil du temps';
  @override String get bloodPressureHeartRateDrop => 'Chute de la Pression et du Rythme Cardiaque';
  @override String get carbonMonoxideNormalize => 'Normalisation des Niveaux de Monoxyde de Carbone';
  @override String get heartAttackRiskDecrease => 'Diminution du Risque de Crise Cardiaque';
  @override String get airwaysRelax => 'Détente des Voies Respiratoires';
  @override String get circulationImprove => 'Amélioration de la Circulation';
  @override String get lungsCleanUp => 'Régénération des Cils Pulmonaires';
  @override String get nervesRegenerate => 'Régénération des Terminaisons Nerveuses';
  @override String get lungCancerRiskHalved => 'Risque de Cancer du Poumon Divisé par Deux';
  @override String get heartRateBloodPressureDesc => 'Votre rythme cardiaque et pression artérielle commencent à revenir à des niveaux normaux';
  @override String get carbonMonoxideDesc => 'Le monoxyde de carbone dans votre sang chute à des niveaux normaux, l\'oxygène augmente';
  @override String get heartAttackRiskDesc => 'Votre risque de crise cardiaque commence à diminuer significativement';
  @override String get airwaysDesc => 'Les tubes bronchiques se détendent et la respiration devient plus facile';
  @override String get circulationDesc => 'La circulation sanguine s\'améliore et continue de s\'améliorer pendant des semaines';
  @override String get lungsDesc => 'Les petits poils dans les poumons repoussent et aident à éliminer le goudron et les débris';
  @override String get nervesDesc => 'Les terminaisons nerveuses endommagées commencent à repousser, améliorant le goût et l\'odorat';
  @override String get lungCancerDesc => 'Le risque de cancer du poumon tombe à la moitié de celui d\'un fumeur';
  @override String get minutesRemaining => 'm restantes';
  @override String get hoursRemaining => 'h restantes';
  @override String get daysRemaining => 'j restants';
  @override String get monthsRemaining => 'mois restants';
  @override String get yearsRemaining => 'ans restants';
  @override String get achievedExclamation => 'Accompli !';
  @override String get willUnlockOn => 'Se débloquera le';
  @override String get yourRewards => 'Vos Récompenses';
  @override String get addReward => 'Ajouter récompense';
  @override String get addNewReward => 'Ajouter Nouvelle Récompense';
  @override String get whatsYourReward => 'Quelle est votre récompense ?';
  @override String get howMuchCost => 'Combien cela coûte-t-il ?';
  @override String get rewardPlaceholder => 'Nouvelles baskets, dîner dehors, etc.';
  @override String get congratulationsReward => 'Félicitations ! 🎉';
  @override String get enjoyReward => 'Profitez de votre récompense bien méritée !';
  @override String get moneySavedSoFar => 'Argent économisé jusqu\'à présent';
  @override String get redeem => 'Racheter';
  @override String get rewardCreated => 'Récompense créée avec succès !';
  @override String get deleteReward => 'Supprimer la récompense';
  @override String get journalTitle => 'Journal Quotidien';
  @override String get addEntry => 'Ajouter une Entrée';
  @override String get howAreYouFeeling => 'Comment vous sentez-vous aujourd\'hui ?';
  @override String get writeYourThoughts => 'Écrivez vos pensées et sentiments...';
  @override String get moodGreat => 'Excellent';
  @override String get moodGood => 'Bien';
  @override String get moodOkay => 'Correct';
  @override String get moodBad => 'Mauvais';
  @override String get moodTerrible => 'Terrible';
  @override String get saving => 'Sauvegarde en cours...';
  @override String get recentEntries => 'Entrées Récentes';
  @override String get entrySaved => 'Entrée sauvegardée ! 📝';
  @override String get journalEntryCreated => 'Entrée de journal créée avec succès !';
  @override String get failedToSaveEntry => 'Échec de la sauvegarde de l\'entrée';
  @override String get cravingSOS => 'SOS Envie';
  @override String get breathingExercise => 'Exercice de Respiration';
  @override String get walkingExercise => 'Exercice de Marche';
  @override String get playGame => 'Jouer au Jeu';
  @override String get selectActivity => 'Choisissez une activité pour vous aider avec votre envie :';
  @override String get greatJob => 'Excellent travail ! 🎉';
  @override String get handledCravingPro => 'Vous avez géré cette envie comme un pro.';
  @override String get language => 'Langue';
  @override String get selectLanguage => 'Sélectionner la Langue';
  @override String get exportData => 'Exporter les Données';
  @override String get clearData => 'Effacer Toutes les Données';
  @override String get about => 'À Propos';
  @override String get version => 'Version';
  @override String get dataExported => 'Données exportées avec succès !';
  @override String get dataCleared => 'Toutes les données ont été effacées. Redémarrage de l\'app...';
  @override String get languageChanged => 'Langue changée avec succès !';
  @override String get welcomeToSmokeLess => 'Bienvenue sur SmokeLess+';
  @override String get letsGetStarted => 'Commençons votre parcours d\'arrêt';
  @override String get whyQuitting => 'Pourquoi arrêtez-vous ?';
  @override String get reasonHealth => 'Meilleure santé';
  @override String get reasonMoney => 'Économiser de l\'argent';
  @override String get reasonFamily => 'Raisons familiales';
  @override String get reasonFreedom => 'Liberté personnelle';
  @override String get congratulations => 'Félicitations !';
  @override String get healthyChoice => 'Vous avez pris l\'étape la plus importante vers une vie plus saine et sans tabac !';
  @override String get setupProfile => 'Configurer Mon Profil';
  @override String get quitDate => 'Quand avez-vous arrêté ?';
  @override String get quitTime => 'À quelle heure ?';
  @override String get smokingHistory => 'Parlez-nous de votre tabagisme';
  @override String get cigarettesPerDay => 'Cigarettes par jour';
  @override String get yearsSmokingLabel => 'Années de tabagisme';
  @override String get pricePerPack => 'Prix par paquet';
  @override String get cigarettesPerPack => 'Cigarettes par paquet';
  @override String get currency => 'Devise';
  @override String get selectCurrency => 'Sélectionner la devise';
  @override String get profileComplete => 'Profil complété avec succès !';
  @override String get letsGo => 'Allons-y !';
  @override String get error => 'Erreur';
  @override String get save => 'Sauvegarder';
  @override String get cancel => 'Annuler';
  @override String get delete => 'Supprimer';
  @override String get back => 'Retour';
  @override String get next => 'Suivant';
  @override String get done => 'Terminé';
  @override String get getStarted => 'Commencer';
  @override String get english => 'English';
  @override String get french => 'Français';
  @override String get spanish => 'Español';
  @override String get arabic => 'العربية';
  @override String get quitJourneyBeginsSoon => 'Votre parcours d\'arrêt commence bientôt !';
  @override String get prepareForJourney => 'Préparez-vous pour l\'incroyable voyage qui vous attend.';
  @override String get journeyStartsHere => 'Votre voyage vers la liberté commence ici';
}

class AppLocalizationsEs extends AppLocalizations {
  @override String get dashboard => 'Panel de Control';
  @override String get healthTimeline => 'Cronología de Salud';
  @override String get rewards => 'Recompensas';
  @override String get journal => 'Diario';
  @override String get trophies => 'Trofeos';
  @override String get settings => 'Configuración';
  // Add Spanish translations...
  @override String get welcomeBack => '¡Bienvenido de nuevo!';
  @override String get timeSmokeFreeDays => 'días sin fumar';
  @override String get timeSmokeFreeDaysLabel => 'Días';
  @override String get timeSmokeFreHours => 'horas';
  @override String get timeSmokeFreMinutes => 'minutos';
  @override String get cigarettesAvoided => 'Cigarrillos Evitados';
  @override String get moneySaved => 'Dinero Ahorrado';
  @override String get currentStreak => 'Racha Actual';
  @override String get dailyProgress => 'Progreso Diario';
  @override String get weeklyProgress => 'Progreso Semanal';
  @override String get monthlyProgress => 'Progreso Mensual';
  @override String get yearlyProgress => 'Progreso Anual';
  @override String get smokeFree => 'Libre de Humo';
  @override String get emergency => 'Emergencia';
  @override String get motivationalQuote => '¡Sigue adelante! Cada momento sin fumar es una victoria.';
  @override String get statsOverview => 'Resumen de Tu Progreso';
  @override String get noStatsAvailable => 'No hay estadísticas disponibles';
  @override String get completeProfile => 'Completa tu perfil para seguir tus hitos de salud';
  @override String get healthMilestones => 'Hitos de Salud';
  @override String get achieved => 'LOGRADO';
  @override String get completeProgress => 'completo';
  @override String get yourHealthProgress => 'Tu Progreso de Salud';
  @override String get timelineDescription => 'Rastrea tus mejoras de salud a lo largo del tiempo';
  @override String get bloodPressureHeartRateDrop => 'Caída de Presión Arterial y Ritmo Cardíaco';
  @override String get carbonMonoxideNormalize => 'Normalización de Niveles de Monóxido de Carbono';
  @override String get heartAttackRiskDecrease => 'Disminución del Riesgo de Ataque Cardíaco';
  @override String get airwaysRelax => 'Las Vías Respiratorias Comienzan a Relajarse';
  @override String get circulationImprove => 'Mejora la Circulación';
  @override String get lungsCleanUp => 'Regeneración de Cilios Pulmonares';
  @override String get nervesRegenerate => 'Regeneración de Terminaciones Nerviosas';
  @override String get lungCancerRiskHalved => 'Riesgo de Cáncer de Pulmón Reducido a la Mitad';
  @override String get heartRateBloodPressureDesc => 'Tu ritmo cardíaco y presión arterial comienzan a volver a niveles normales';
  @override String get carbonMonoxideDesc => 'El monóxido de carbono en tu sangre baja a niveles normales, el oxígeno aumenta';
  @override String get heartAttackRiskDesc => 'Tu riesgo de ataque cardíaco comienza a disminuir significativamente';
  @override String get airwaysDesc => 'Los tubos bronquiales se relajan y la respiración se vuelve más fácil';
  @override String get circulationDesc => 'La circulación sanguínea mejora y continúa mejorando durante semanas';
  @override String get lungsDesc => 'Los pequeños pelos en los pulmones vuelven a crecer y ayudan a eliminar el alquitrán y los residuos';
  @override String get nervesDesc => 'Las terminaciones nerviosas dañadas comienzan a regenerarse, mejorando el gusto y el olfato';
  @override String get lungCancerDesc => 'El riesgo de cáncer de pulmón cae a la mitad del de un fumador';
  @override String get minutesRemaining => 'm restantes';
  @override String get hoursRemaining => 'h restantes';
  @override String get daysRemaining => 'd restantes';
  @override String get monthsRemaining => 'meses restantes';
  @override String get yearsRemaining => 'años restantes';
  @override String get achievedExclamation => '¡Logrado!';
  @override String get willUnlockOn => 'Se desbloqueará el';
  @override String get yourRewards => 'Tus Recompensas';
  @override String get addReward => 'Añadir recompensa';
  @override String get addNewReward => 'Añadir Nueva Recompensa';
  @override String get whatsYourReward => '¿Cuál es tu recompensa?';
  @override String get howMuchCost => '¿Cuánto cuesta?';
  @override String get rewardPlaceholder => 'Nuevas zapatillas, cena fuera, etc.';
  @override String get congratulationsReward => '¡Felicidades! 🎉';
  @override String get enjoyReward => '¡Disfruta tu recompensa bien merecida!';
  @override String get moneySavedSoFar => 'Dinero ahorrado hasta ahora';
  @override String get redeem => 'Canjear';
  @override String get rewardCreated => '¡Recompensa creada exitosamente!';
  @override String get deleteReward => 'Eliminar recompensa';
  @override String get journalTitle => 'Diario Diario';
  @override String get addEntry => 'Añadir Entrada';
  @override String get howAreYouFeeling => '¿Cómo te sientes hoy?';
  @override String get writeYourThoughts => 'Escribe tus pensamientos y sentimientos...';
  @override String get moodGreat => 'Excelente';
  @override String get moodGood => 'Bien';
  @override String get moodOkay => 'Regular';
  @override String get moodBad => 'Mal';
  @override String get moodTerrible => 'Terrible';
  @override String get saving => 'Guardando...';
  @override String get recentEntries => 'Entradas Recientes';
  @override String get entrySaved => '¡Entrada guardada! 📝';
  @override String get journalEntryCreated => '¡Entrada del diario creada exitosamente!';
  @override String get failedToSaveEntry => 'Error al guardar la entrada';
  @override String get cravingSOS => 'SOS Ansiedad';
  @override String get breathingExercise => 'Ejercicio de Respiración';
  @override String get walkingExercise => 'Ejercicio de Caminata';
  @override String get playGame => 'Jugar';
  @override String get selectActivity => 'Elige una actividad para ayudar con tu ansiedad:';
  @override String get greatJob => '¡Excelente trabajo! 🎉';
  @override String get handledCravingPro => 'Manejaste esa ansiedad como un profesional.';
  @override String get language => 'Idioma';
  @override String get selectLanguage => 'Seleccionar Idioma';
  @override String get exportData => 'Exportar Datos';
  @override String get clearData => 'Borrar Todos los Datos';
  @override String get about => 'Acerca de';
  @override String get version => 'Versión';
  @override String get dataExported => '¡Datos exportados exitosamente!';
  @override String get dataCleared => 'Todos los datos han sido borrados. Reiniciando app...';
  @override String get languageChanged => '¡Idioma cambiado exitosamente!';
  @override String get welcomeToSmokeLess => 'Bienvenido a SmokeLess+';
  @override String get letsGetStarted => 'Comencemos tu viaje para dejar de fumar';
  @override String get whyQuitting => '¿Por qué estás dejando de fumar?';
  @override String get reasonHealth => 'Mejor salud';
  @override String get reasonMoney => 'Ahorrar dinero';
  @override String get reasonFamily => 'Razones familiares';
  @override String get reasonFreedom => 'Libertad personal';
  @override String get congratulations => '¡Felicidades!';
  @override String get healthyChoice => '¡Has dado el paso más importante hacia una vida más saludable y libre de humo!';
  @override String get setupProfile => 'Configurar Mi Perfil';
  @override String get quitDate => '¿Cuándo dejaste de fumar?';
  @override String get quitTime => '¿A qué hora?';
  @override String get smokingHistory => 'Cuéntanos sobre tu tabaquismo';
  @override String get cigarettesPerDay => 'Cigarrillos por día';
  @override String get yearsSmokingLabel => 'Años fumando';
  @override String get pricePerPack => 'Precio por paquete';
  @override String get cigarettesPerPack => 'Cigarrillos por paquete';
  @override String get currency => 'Moneda';
  @override String get selectCurrency => 'Seleccionar moneda';
  @override String get profileComplete => '¡Perfil completado exitosamente!';
  @override String get letsGo => '¡Vamos!';
  @override String get error => 'Error';
  @override String get save => 'Guardar';
  @override String get cancel => 'Cancelar';
  @override String get delete => 'Eliminar';
  @override String get back => 'Atrás';
  @override String get next => 'Siguiente';
  @override String get done => 'Hecho';
  @override String get getStarted => 'Comenzar';
  @override String get english => 'English';
  @override String get french => 'Français';
  @override String get spanish => 'Español';
  @override String get arabic => 'العربية';
  @override String get quitJourneyBeginsSoon => '¡Su viaje para dejar de fumar comienza pronto!';
  @override String get prepareForJourney => 'Prepárate para el increíble viaje que te espera.';
  @override String get journeyStartsHere => 'Tu viaje hacia la libertad comienza aquí';
}

class AppLocalizationsAr extends AppLocalizations {
  @override String get dashboard => 'لوحة التحكم';
  @override String get healthTimeline => 'الجدول الزمني للصحة';
  @override String get rewards => 'المكافآت';
  @override String get journal => 'اليومية';
  @override String get trophies => 'الجوائز';
  @override String get settings => 'الإعدادات';
  // Add Arabic translations...
  @override String get welcomeBack => 'مرحباً بعودتك!';
  @override String get timeSmokeFreeDays => 'أيام خالية من التدخين';
  @override String get timeSmokeFreeDaysLabel => 'أيام';
  @override String get timeSmokeFreHours => 'ساعات';
  @override String get timeSmokeFreMinutes => 'دقائق';
  @override String get cigarettesAvoided => 'السجائر المتجنبة';
  @override String get moneySaved => 'المال المدخر';
  @override String get currentStreak => 'السلسلة الحالية';
  @override String get dailyProgress => 'التقدم اليومي';
  @override String get weeklyProgress => 'التقدم الأسبوعي';
  @override String get monthlyProgress => 'التقدم الشهري';
  @override String get yearlyProgress => 'التقدم السنوي';
  @override String get smokeFree => 'خالي من التدخين';
  @override String get emergency => 'طوارئ';
  @override String get motivationalQuote => 'استمر! كل لحظة خالية من التدخين هي انتصار.';
  @override String get statsOverview => 'نظرة عامة على تقدمك';
  @override String get noStatsAvailable => 'لا توجد إحصائيات متاحة';
  @override String get completeProfile => 'أكمل إعداد ملفك الشخصي لتتبع معالم صحتك';
  @override String get healthMilestones => 'معالم الصحة';
  @override String get achieved => 'تم تحقيقه';
  @override String get completeProgress => 'مكتمل';
  @override String get yourHealthProgress => 'تقدم صحتك';
  @override String get timelineDescription => 'تتبع تحسينات صحتك مع مرور الوقت';
  @override String get bloodPressureHeartRateDrop => 'انخفاض ضغط الدم ومعدل ضربات القلب';
  @override String get carbonMonoxideNormalize => 'تطبيع مستويات أول أكسيد الكربون';
  @override String get heartAttackRiskDecrease => 'انخفاض خطر الأزمة القلبية';
  @override String get airwaysRelax => 'بداية استرخاء الممرات الهوائية';
  @override String get circulationImprove => 'تحسن الدورة الدموية';
  @override String get lungsCleanUp => 'إعادة نمو أهداب الرئة والتنظيف';
  @override String get nervesRegenerate => 'تجديد النهايات العصبية';
  @override String get lungCancerRiskHalved => 'انخفاض خطر سرطان الرئة إلى النصف';
  @override String get heartRateBloodPressureDesc => 'يبدأ معدل ضربات قلبك وضغط دمك في العودة إلى المستويات الطبيعية';
  @override String get carbonMonoxideDesc => 'ينخفض أول أكسيد الكربون في دمك إلى المستويات الطبيعية، ويزداد الأكسجين';
  @override String get heartAttackRiskDesc => 'يبدأ خطر إصابتك بنوبة قلبية في الانخفاض بشكل كبير';
  @override String get airwaysDesc => 'تسترخي الأنابيب الشعبية ويصبح التنفس أسهل';
  @override String get circulationDesc => 'تتحسن الدورة الدموية وتستمر في التحسن لأسابيع';
  @override String get lungsDesc => 'تنمو الشعيرات الصغيرة في الرئتين مرة أخرى وتساعد في إزالة القطران والحطام';
  @override String get nervesDesc => 'تبدأ النهايات العصبية التالفة في النمو مرة أخرى، مما يحسن التذوق والشم';
  @override String get lungCancerDesc => 'ينخفض خطر سرطان الرئة إلى نصف خطر المدخن';
  @override String get minutesRemaining => 'د متبقية';
  @override String get hoursRemaining => 'س متبقية';
  @override String get daysRemaining => 'ي متبقية';
  @override String get monthsRemaining => 'شهر متبقي';
  @override String get yearsRemaining => 'سنة متبقية';
  @override String get achievedExclamation => 'تم تحقيقه!';
  @override String get willUnlockOn => 'سيتم إلغاء قفله في';
  @override String get yourRewards => 'مكافآتك';
  @override String get addReward => 'إضافة مكافأة';
  @override String get addNewReward => 'إضافة مكافأة جديدة';
  @override String get whatsYourReward => 'ما هي مكافأتك؟';
  @override String get howMuchCost => 'كم تكلف؟';
  @override String get rewardPlaceholder => 'أحذية رياضية جديدة، عشاء خارجي، إلخ.';
  @override String get congratulationsReward => 'تهانينا! 🎉';
  @override String get enjoyReward => 'استمتع بمكافأتك المستحقة!';
  @override String get moneySavedSoFar => 'المال المدخر حتى الآن';
  @override String get redeem => 'استبدال';
  @override String get rewardCreated => 'تم إنشاء المكافأة بنجاح!';
  @override String get deleteReward => 'حذف المكافأة';
  @override String get journalTitle => 'اليومية اليومية';
  @override String get addEntry => 'إضافة إدخال';
  @override String get howAreYouFeeling => 'كيف تشعر اليوم؟';
  @override String get writeYourThoughts => 'اكتب أفكارك ومشاعرك...';
  @override String get moodGreat => 'ممتاز';
  @override String get moodGood => 'جيد';
  @override String get moodOkay => 'عادي';
  @override String get moodBad => 'سيء';
  @override String get moodTerrible => 'فظيع';
  @override String get saving => 'حفظ...';
  @override String get recentEntries => 'الإدخالات الحديثة';
  @override String get entrySaved => 'تم حفظ الإدخال! 📝';
  @override String get journalEntryCreated => 'تم إنشاء إدخال اليومية بنجاح!';
  @override String get failedToSaveEntry => 'فشل في حفظ الإدخال';
  @override String get cravingSOS => 'SOS الرغبة الشديدة';
  @override String get breathingExercise => 'تمرين التنفس';
  @override String get walkingExercise => 'تمرين المشي';
  @override String get playGame => 'لعب لعبة';
  @override String get selectActivity => 'اختر نشاطاً لمساعدتك مع رغبتك الشديدة:';
  @override String get greatJob => 'عمل رائع! 🎉';
  @override String get handledCravingPro => 'لقد تعاملت مع تلك الرغبة الشديدة كمحترف.';
  @override String get language => 'اللغة';
  @override String get selectLanguage => 'اختر اللغة';
  @override String get exportData => 'تصدير البيانات';
  @override String get clearData => 'مسح جميع البيانات';
  @override String get about => 'حول';
  @override String get version => 'الإصدار';
  @override String get dataExported => 'تم تصدير البيانات بنجاح!';
  @override String get dataCleared => 'تم مسح جميع البيانات. إعادة تشغيل التطبيق...';
  @override String get languageChanged => 'تم تغيير اللغة بنجاح!';
  @override String get welcomeToSmokeLess => 'مرحباً بك في SmokeLess+';
  @override String get letsGetStarted => 'لنبدأ رحلة الإقلاع عن التدخين';
  @override String get whyQuitting => 'لماذا تقلع عن التدخين؟';
  @override String get reasonHealth => 'صحة أفضل';
  @override String get reasonMoney => 'توفير المال';
  @override String get reasonFamily => 'أسباب عائلية';
  @override String get reasonFreedom => 'حرية شخصية';
  @override String get congratulations => 'تهانينا!';
  @override String get healthyChoice => 'لقد اتخذت أهم خطوة نحو حياة أكثر صحة وخالية من التدخين!';
  @override String get setupProfile => 'إعداد ملفي الشخصي';
  @override String get quitDate => 'متى أقلعت عن التدخين؟';
  @override String get quitTime => 'في أي وقت؟';
  @override String get smokingHistory => 'أخبرنا عن تدخينك';
  @override String get cigarettesPerDay => 'سجائر يومياً';
  @override String get yearsSmokingLabel => 'سنوات التدخين';
  @override String get pricePerPack => 'سعر العلبة';
  @override String get cigarettesPerPack => 'سجائر لكل علبة';
  @override String get currency => 'العملة';
  @override String get selectCurrency => 'اختر العملة';
  @override String get profileComplete => 'تم إكمال الملف الشخصي بنجاح!';
  @override String get letsGo => 'هيا بنا!';
  @override String get error => 'خطأ';
  @override String get save => 'حفظ';
  @override String get cancel => 'إلغاء';
  @override String get delete => 'حذف';
  @override String get back => 'رجوع';
  @override String get next => 'التالي';
  @override String get done => 'تم';
  @override String get getStarted => 'ابدأ';
  @override String get english => 'English';
  @override String get french => 'Français';
  @override String get spanish => 'Español';
  @override String get arabic => 'العربية';
  @override String get quitJourneyBeginsSoon => 'رحلة الإقلاع عن التدخين ستبدأ قريباً!';
  @override String get prepareForJourney => 'استعد للرحلة المذهلة التي تنتظرك.';
  @override String get journeyStartsHere => 'رحلتك نحو الحرية تبدأ هنا';
}