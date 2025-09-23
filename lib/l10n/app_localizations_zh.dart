// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '戒烟追踪器';

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String get smokeFreeJourney => '您在无烟之旅中表现得非常出色';

  @override
  String get currentStreak => '当前连续记录';

  @override
  String get daysSmokeFree => '无烟天数';

  @override
  String get timeSmokeFree => '无烟时间';

  @override
  String get moneySaved => '节省的钱';

  @override
  String get cigarettesAvoided => '避免的香烟';

  @override
  String get healthScore => '健康得分';

  @override
  String get achievements => '成就';

  @override
  String get keepItUp => '继续保持！';

  @override
  String get improvingDaily => '每天改善';

  @override
  String get basedOnProgress => '基于进展';

  @override
  String thatsPacks(int count) {
    return '那是 $count 包';
  }

  @override
  String get navigationHome => '首页';

  @override
  String get navigationProgress => '进度';

  @override
  String get navigationHealthScore => '健康评分';

  @override
  String get navigationAchievements => '成就';

  @override
  String get navigationProfile => '个人资料';

  @override
  String get progressUpdated => '进展更新成功！';

  @override
  String get errorLoadingData => '加载数据出错。使用默认值。';

  @override
  String get motivationalMessage1 => '每一个无烟的日子都是胜利。您在每一个过去的时刻都在建设更健康、更强壮的自己。';

  @override
  String get motivationalMessage2 => '您的肺部现在正在感谢您。每一次呼吸都更清洁，每一次心跳都更强劲。';

  @override
  String get motivationalMessage3 => '您省下的钱只是开始。真正的宝藏是您为生命增加的岁月。';

  @override
  String get drMichaelChen => '陈迈克尔医生';

  @override
  String get healthCoachMaria => '健康教练玛丽亚';

  @override
  String get wellnessExpertJohn => '健康专家约翰';

  @override
  String get healthStageStarting => '开始恢复';

  @override
  String get healthStageBegin => '准备开始';

  @override
  String get healthStageJourney => '旅程开始';

  @override
  String get healthStageNicotineDropping => '尼古丁下降';

  @override
  String get healthStageCONormalizing => '一氧化碳水平正常化';

  @override
  String get healthStageHeartRisk => '心脏风险下降';

  @override
  String get healthStageNicotineFree => '身体无尼古丁';

  @override
  String get healthStageSensesImproving => '感官改善';

  @override
  String get healthStageCirculation => '循环改善';

  @override
  String get healthStageLungFunction => '肺功能改善';

  @override
  String get healthStageSignificant => '显著恢复';

  @override
  String get healthStageHeartDisease => '心脏病风险降低';

  @override
  String get healthStageStroke => '中风风险正常化';

  @override
  String get healthStageMaximum => '最大健康恢复';

  @override
  String get milestoneStartJourney => '开始您的旅程';

  @override
  String get milestoneNicotineDropping => '尼古丁水平下降';

  @override
  String get milestoneCOClearing => '一氧化碳清除';

  @override
  String get milestoneHeartAttack => '心脏病发作风险下降';

  @override
  String get milestoneNicotineElimination => '尼古丁消除';

  @override
  String get milestoneTasteSmell => '味觉和嗅觉复苏';

  @override
  String get milestoneCirculationBoost => '循环促进';

  @override
  String get milestoneLungBoost => '肺功能促进';

  @override
  String get milestoneMajorLung => '主要肺部恢复';

  @override
  String get milestoneHeartRisk => '心脏风险减半';

  @override
  String get milestoneStrokeRisk => '中风风险正常化';

  @override
  String get milestoneCancerRisk => '癌症风险减半';

  @override
  String get milestoneMaintaining => '保持卓越';

  @override
  String get achievedStatus => '已达成';

  @override
  String get soonStatus => '即将';

  @override
  String get notStartedStatus => '未开始';

  @override
  String timeInDays(int count) {
    return '$count 天内';
  }

  @override
  String timeInDaysPlural(int count) {
    return '$count 天内';
  }

  @override
  String timeInHours(int count) {
    return '$count 小时内';
  }

  @override
  String timeInHoursPlural(int count) {
    return '$count 小时内';
  }

  @override
  String timeInMinutes(int count) {
    return '$count 分钟内';
  }

  @override
  String get languageSettings => '语言设置';

  @override
  String get selectLanguage => '选择语言';

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
