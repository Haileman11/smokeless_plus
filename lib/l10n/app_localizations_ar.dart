// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'الإقلاع عن التدخين';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'بعد الظهر سعيد';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get smokeFreeJourney => 'أنت تقوم بعمل رائع في رحلتك الخالية من التدخين';

  @override
  String get currentStreak => 'الخط الحالي';

  @override
  String get daysSmokeFree => 'أيام بدون تدخين';

  @override
  String get timeSmokeFree => 'وقت بدون تدخين';

  @override
  String get moneySaved => 'المال المدخر';

  @override
  String get cigarettesAvoided => 'السجائر المتجنبة';

  @override
  String get healthScore => 'نقاط الصحة';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get keepItUp => 'واصل!';

  @override
  String get improvingDaily => 'تحسن يومي';

  @override
  String get basedOnProgress => 'بناءً على التقدم';

  @override
  String thatsPacks(int count) {
    return 'هذا $count علب';
  }

  @override
  String get navigationHome => 'الرئيسية';

  @override
  String get navigationProgress => 'التقدم';

  @override
  String get navigationHealthScore => 'نقاط الصحة';

  @override
  String get navigationAchievements => 'الإنجازات';

  @override
  String get navigationProfile => 'الملف الشخصي';

  @override
  String get progressUpdated => 'تم تحديث التقدم بنجاح!';

  @override
  String get errorLoadingData => 'خطأ في تحميل البيانات. استخدام القيم الافتراضية.';

  @override
  String get motivationalMessage1 => 'كل يوم بدون تدخين هو انتصار. أنت تبني نسخة أكثر صحة وقوة من نفسك مع كل لحظة تمر.';

  @override
  String get motivationalMessage2 => 'رئتاك تشكرانك الآن. كل نفس أنظف، كل ضربة قلب أقوى.';

  @override
  String get motivationalMessage3 => 'المال الذي تدخره هو مجرد البداية. الكنز الحقيقي هو السنوات التي تضيفها لحياتك.';

  @override
  String get drMichaelChen => 'الدكتور مايكل تشين';

  @override
  String get healthCoachMaria => 'مدربة الصحة ماريا';

  @override
  String get wellnessExpertJohn => 'خبير الصحة جون';

  @override
  String get healthStageStarting => 'بداية الشفاء';

  @override
  String get healthStageBegin => 'مستعد للبداية';

  @override
  String get healthStageJourney => 'الرحلة تبدأ';

  @override
  String get healthStageNicotineDropping => 'النيكوتين ينخفض';

  @override
  String get healthStageCONormalizing => 'مستويات أول أكسيد الكربون تتطبع';

  @override
  String get healthStageHeartRisk => 'خطر القلب ينخفض';

  @override
  String get healthStageNicotineFree => 'جسم خال من النيكوتين';

  @override
  String get healthStageSensesImproving => 'الحواس تتحسن';

  @override
  String get healthStageCirculation => 'الدورة الدموية تتحسن';

  @override
  String get healthStageLungFunction => 'وظائف الرئة تتحسن';

  @override
  String get healthStageSignificant => 'شفاء كبير';

  @override
  String get healthStageHeartDisease => 'خطر أمراض القلب منخفض';

  @override
  String get healthStageStroke => 'خطر السكتة الدماغية طبيعي';

  @override
  String get healthStageMaximum => 'أقصى شفاء صحي';

  @override
  String get milestoneStartJourney => 'ابدأ رحلتك';

  @override
  String get milestoneNicotineDropping => 'مستويات النيكوتين تنخفض';

  @override
  String get milestoneCOClearing => 'أول أكسيد الكربون يتبدد';

  @override
  String get milestoneHeartAttack => 'خطر النوبة القلبية ينخفض';

  @override
  String get milestoneNicotineElimination => 'إزالة النيكوتين';

  @override
  String get milestoneTasteSmell => 'إحياء الطعم والرائحة';

  @override
  String get milestoneCirculationBoost => 'تعزيز الدورة الدموية';

  @override
  String get milestoneLungBoost => 'تعزيز وظائف الرئة';

  @override
  String get milestoneMajorLung => 'شفاء رئوي كبير';

  @override
  String get milestoneHeartRisk => 'خطر القلب ينخفض للنصف';

  @override
  String get milestoneStrokeRisk => 'خطر السكتة الدماغية طبيعي';

  @override
  String get milestoneCancerRisk => 'خطر السرطان ينخفض للنصف';

  @override
  String get milestoneMaintaining => 'الحفاظ على التميز';

  @override
  String get achievedStatus => 'تحقق';

  @override
  String get soonStatus => 'قريباً';

  @override
  String get notStartedStatus => 'لم يبدأ';

  @override
  String timeInDays(int count) {
    return 'خلال $count يوم';
  }

  @override
  String timeInDaysPlural(int count) {
    return 'خلال $count أيام';
  }

  @override
  String timeInHours(int count) {
    return 'خلال $count ساعة';
  }

  @override
  String timeInHoursPlural(int count) {
    return 'خلال $count ساعات';
  }

  @override
  String timeInMinutes(int count) {
    return 'خلال $count دقائق';
  }

  @override
  String get languageSettings => 'إعدادات اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

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
