// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Трекер Отказа от Курения';

  @override
  String get goodMorning => 'Доброе утро';

  @override
  String get goodAfternoon => 'Добрый день';

  @override
  String get goodEvening => 'Добрый вечер';

  @override
  String get smokeFreeJourney => 'Вы делаете потрясающую работу в своём путешествии без курения';

  @override
  String get currentStreak => 'Текущая серия';

  @override
  String get daysSmokeFree => 'Дней без курения';

  @override
  String get timeSmokeFree => 'Время без курения';

  @override
  String get moneySaved => 'Деньги сэкономлены';

  @override
  String get cigarettesAvoided => 'Сигарет избежано';

  @override
  String get healthScore => 'Показатель здоровья';

  @override
  String get achievements => 'Достижения';

  @override
  String get keepItUp => 'Так держать!';

  @override
  String get improvingDaily => 'Улучшается ежедневно';

  @override
  String get basedOnProgress => 'На основе прогресса';

  @override
  String thatsPacks(int count) {
    return 'Это $count пачек';
  }

  @override
  String get navigationHome => 'Главная';

  @override
  String get navigationProgress => 'Прогресс';

  @override
  String get navigationHealthScore => 'Показатель Здоровья';

  @override
  String get navigationAchievements => 'Достижения';

  @override
  String get navigationProfile => 'Профиль';

  @override
  String get progressUpdated => 'Прогресс успешно обновлён!';

  @override
  String get errorLoadingData => 'Ошибка загрузки данных. Используются значения по умолчанию.';

  @override
  String get motivationalMessage1 => 'Каждый день без курения - это победа. Вы строите более здоровую, сильную версию себя с каждым проходящим моментом.';

  @override
  String get motivationalMessage2 => 'Ваши лёгкие благодарят вас прямо сейчас. Каждый вдох чище, каждое сердцебиение сильнее.';

  @override
  String get motivationalMessage3 => 'Деньги, которые вы экономите - это только начало. Настоящее сокровище - это годы, которые вы добавляете к своей жизни.';

  @override
  String get drMichaelChen => 'Доктор Майкл Чен';

  @override
  String get healthCoachMaria => 'Тренер по здоровью Мария';

  @override
  String get wellnessExpertJohn => 'Эксперт по оздоровлению Джон';

  @override
  String get healthStageStarting => 'Начало восстановления';

  @override
  String get healthStageBegin => 'Готов начать';

  @override
  String get healthStageJourney => 'Путешествие начинается';

  @override
  String get healthStageNicotineDropping => 'Никотин снижается';

  @override
  String get healthStageCONormalizing => 'Уровни CO нормализуются';

  @override
  String get healthStageHeartRisk => 'Сердечный риск снижается';

  @override
  String get healthStageNicotineFree => 'Тело без никотина';

  @override
  String get healthStageSensesImproving => 'Чувства улучшаются';

  @override
  String get healthStageCirculation => 'Циркуляция улучшается';

  @override
  String get healthStageLungFunction => 'Функция лёгких улучшается';

  @override
  String get healthStageSignificant => 'Значительное восстановление';

  @override
  String get healthStageHeartDisease => 'Риск сердечных заболеваний снижен';

  @override
  String get healthStageStroke => 'Риск инсульта нормализован';

  @override
  String get healthStageMaximum => 'Максимальное восстановление здоровья';

  @override
  String get milestoneStartJourney => 'Начните ваше путешествие';

  @override
  String get milestoneNicotineDropping => 'Уровни никотина падают';

  @override
  String get milestoneCOClearing => 'Угарный газ очищается';

  @override
  String get milestoneHeartAttack => 'Риск инфаркта снижается';

  @override
  String get milestoneNicotineElimination => 'Устранение никотина';

  @override
  String get milestoneTasteSmell => 'Возрождение вкуса и запаха';

  @override
  String get milestoneCirculationBoost => 'Улучшение циркуляции';

  @override
  String get milestoneLungBoost => 'Улучшение функции лёгких';

  @override
  String get milestoneMajorLung => 'Крупное восстановление лёгких';

  @override
  String get milestoneHeartRisk => 'Сердечный риск уменьшен вдвое';

  @override
  String get milestoneStrokeRisk => 'Риск инсульта нормализован';

  @override
  String get milestoneCancerRisk => 'Риск рака уменьшен вдвое';

  @override
  String get milestoneMaintaining => 'Поддержание превосходства';

  @override
  String get achievedStatus => 'Достигнуто';

  @override
  String get soonStatus => 'Скоро';

  @override
  String get notStartedStatus => 'Не начато';

  @override
  String timeInDays(int count) {
    return 'Через $count день';
  }

  @override
  String timeInDaysPlural(int count) {
    return 'Через $count дней';
  }

  @override
  String timeInHours(int count) {
    return 'Через $count час';
  }

  @override
  String timeInHoursPlural(int count) {
    return 'Через $count часов';
  }

  @override
  String timeInMinutes(int count) {
    return 'Через $count минут';
  }

  @override
  String get languageSettings => 'Настройки языка';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageChinese => '中文';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageHindi => 'हिन्दी';
}
