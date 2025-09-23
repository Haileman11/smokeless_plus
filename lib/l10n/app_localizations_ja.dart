// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '禁煙トラッカー';

  @override
  String get goodMorning => 'おはようございます';

  @override
  String get goodAfternoon => 'こんにちは';

  @override
  String get goodEvening => 'こんばんは';

  @override
  String get smokeFreeJourney => 'あなたは禁煙の旅で素晴らしい仕事をしています';

  @override
  String get currentStreak => '現在の連続記録';

  @override
  String get daysSmokeFree => '禁煙日数';

  @override
  String get timeSmokeFree => '禁煙時間';

  @override
  String get moneySaved => '節約金額';

  @override
  String get cigarettesAvoided => '避けたタバコ';

  @override
  String get healthScore => '健康スコア';

  @override
  String get achievements => '達成';

  @override
  String get keepItUp => 'その調子で！';

  @override
  String get improvingDaily => '毎日改善';

  @override
  String get basedOnProgress => '進歩に基づく';

  @override
  String thatsPacks(int count) {
    return 'それは$count箱です';
  }

  @override
  String get navigationHome => 'ホーム';

  @override
  String get navigationProgress => '進捗';

  @override
  String get navigationHealthScore => '健康スコア';

  @override
  String get navigationAchievements => '達成項目';

  @override
  String get navigationProfile => 'プロフィール';

  @override
  String get progressUpdated => '進歩が正常に更新されました！';

  @override
  String get errorLoadingData => 'データ読み込みエラー。デフォルト値を使用します。';

  @override
  String get motivationalMessage1 => '禁煙の毎日が勝利です。あなたは過ぎ行く一瞬一瞬で、より健康で強い自分を構築しています。';

  @override
  String get motivationalMessage2 => 'あなたの肺は今、あなたに感謝しています。すべての呼吸がより清潔で、すべての心拍がより強くなっています。';

  @override
  String get motivationalMessage3 => 'あなたが節約しているお金は始まりに過ぎません。本当の宝は、あなたの人生に加えている年月です。';

  @override
  String get drMichaelChen => 'マイケル・チェン医師';

  @override
  String get healthCoachMaria => 'ヘルスコーチ マリア';

  @override
  String get wellnessExpertJohn => 'ウェルネス専門家 ジョン';

  @override
  String get healthStageStarting => '回復開始';

  @override
  String get healthStageBegin => '始める準備';

  @override
  String get healthStageJourney => '旅が始まる';

  @override
  String get healthStageNicotineDropping => 'ニコチン減少';

  @override
  String get healthStageCONormalizing => 'CO値正常化';

  @override
  String get healthStageHeartRisk => '心臓リスク減少';

  @override
  String get healthStageNicotineFree => 'ニコチンフリー体';

  @override
  String get healthStageSensesImproving => '感覚改善';

  @override
  String get healthStageCirculation => '循環改善';

  @override
  String get healthStageLungFunction => '肺機能改善';

  @override
  String get healthStageSignificant => '大幅回復';

  @override
  String get healthStageHeartDisease => '心疾患リスク軽減';

  @override
  String get healthStageStroke => '脳卒中リスク正常化';

  @override
  String get healthStageMaximum => '最大健康回復';

  @override
  String get milestoneStartJourney => '旅を始める';

  @override
  String get milestoneNicotineDropping => 'ニコチンレベル下降';

  @override
  String get milestoneCOClearing => '一酸化炭素除去';

  @override
  String get milestoneHeartAttack => '心臓発作リスク減少';

  @override
  String get milestoneNicotineElimination => 'ニコチン除去';

  @override
  String get milestoneTasteSmell => '味覚・嗅覚復活';

  @override
  String get milestoneCirculationBoost => '循環促進';

  @override
  String get milestoneLungBoost => '肺機能促進';

  @override
  String get milestoneMajorLung => '主要肺回復';

  @override
  String get milestoneHeartRisk => '心臓リスク半減';

  @override
  String get milestoneStrokeRisk => '脳卒中リスク正常化';

  @override
  String get milestoneCancerRisk => 'がんリスク半減';

  @override
  String get milestoneMaintaining => '卓越性維持';

  @override
  String get achievedStatus => '達成';

  @override
  String get soonStatus => 'まもなく';

  @override
  String get notStartedStatus => '未開始';

  @override
  String timeInDays(int count) {
    return '$count日後';
  }

  @override
  String timeInDaysPlural(int count) {
    return '$count日後';
  }

  @override
  String timeInHours(int count) {
    return '$count時間後';
  }

  @override
  String timeInHoursPlural(int count) {
    return '$count時間後';
  }

  @override
  String timeInMinutes(int count) {
    return '$count分後';
  }

  @override
  String get languageSettings => '言語設定';

  @override
  String get selectLanguage => '言語を選択';

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
