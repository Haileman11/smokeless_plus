import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

enum PeriodType { week, month, threeMonths, year }
enum BreathingPhase { inhale, hold, exhale }
enum MilestoneCategory {
  all,
  shortTerm,
  mediumTerm,
  longTerm,
}
enum MotivationCategory {
  financial,
  health,
  behavioral,
  social,
}


String getLocalizedPeriod(BuildContext context, PeriodType type) {
  final l10n = AppLocalizations.of(context)!;
  switch (type) {
    case PeriodType.week:
      return l10n.week;
    case PeriodType.month:
      return l10n.month;
    case PeriodType.threeMonths:
      return l10n.threeMonths;
    case PeriodType.year:
      return l10n.year;
  }
}

String getLocalizedBreathingPhase(BuildContext context, BreathingPhase phase) {
  final l10n = AppLocalizations.of(context)!;
  switch (phase) {
    case BreathingPhase.inhale:
      return l10n.inhale;
    case BreathingPhase.hold:
      return l10n.hold;
    case BreathingPhase.exhale:
      return l10n.exhale;
  }
}
      

extension MotivationCategoryExtension on MotivationCategory {
  String name(AppLocalizations l10n) {
    switch (this) {
      case MotivationCategory.financial:
        return l10n.motivationFinancial;
      case MotivationCategory.health:
        return l10n.motivationHealth;
      case MotivationCategory.behavioral:
        return l10n.motivationBehavioral;
      case MotivationCategory.social:
        return l10n.motivationSocial;
    }
  }

  String icon() {
    switch (this) {
      case MotivationCategory.financial:
        return 'attach_money';
      case MotivationCategory.health:
        return 'favorite';
      case MotivationCategory.behavioral:
        return 'psychology';
      case MotivationCategory.social:
        return 'people';
    }
  }

  String get id => name.toString().toLowerCase();
}
extension MilestoneCategoryExtension on MilestoneCategory {
  String label(AppLocalizations l10n) {
    switch (this) {
      case MilestoneCategory.all:
        return l10n.categoryAllLabel;
      case MilestoneCategory.shortTerm:
        return l10n.categoryShortLabel;
      case MilestoneCategory.mediumTerm:
        return l10n.categoryMediumLabel;
      case MilestoneCategory.longTerm:
        return l10n.categoryLongLabel;
    }
  }

  String description(AppLocalizations l10n) {
    switch (this) {
      case MilestoneCategory.all:
        return l10n.categoryAllDescription;
      case MilestoneCategory.shortTerm:
        return l10n.categoryShortDescription;
      case MilestoneCategory.mediumTerm:
        return l10n.categoryMediumDescription;
      case MilestoneCategory.longTerm:
        return l10n.categoryLongDescription;
    }
  }

  String iconName() {
    switch (this) {
      case MilestoneCategory.all:
        return 'view_list';
      case MilestoneCategory.shortTerm:
        return 'schedule';
      case MilestoneCategory.mediumTerm:
        return 'trending_up';
      case MilestoneCategory.longTerm:
        return 'military_tech';
    }
  }
}


String formatLifeLost(int totalMinutes) {
    if (totalMinutes < 60) {
      return '${totalMinutes}m';
    } else if (totalMinutes < 1440) {
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      return '${hours}h ${minutes}m';
    } else if (totalMinutes < 525600) {
      final days = totalMinutes ~/ 1440;
      final hours = (totalMinutes % 1440) ~/ 60;
      if (days > 365) {
        final years = days ~/ 365;
        final remainingDays = days % 365;
        return '${years}Y ${remainingDays}d ${hours}h';
      } else if (days > 30) {
        final months = days ~/ 30;
        final remainingDays = days % 30;
        return '${months}M ${remainingDays}d ${hours}h';
      } else {
        return '${days}d ${hours}h';
      }
    } else {
      final years = totalMinutes ~/ 525600;
      final remainingMinutes = totalMinutes % 525600;
      final months = remainingMinutes ~/ 43800;
      final days = (remainingMinutes % 43800) ~/ 1440;
      return '${years}Y ${months}M ${days}d';
    }
  }

  

List<String> getLocalizedCurrencyLabels([String? locale]) {
  const currencies = ['USD', 'EUR', 'GBP', 'INR', 'JPY'];

  return currencies.map((code) {
    final symbol = NumberFormat.simpleCurrency(name: code, locale: locale).currencySymbol;
    return '$code ($symbol)';
  }).toList();
}

void callNumber(String phoneNumber) async {
  final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $phoneNumber';
  }
}



void generateExportData(Map<String,dynamic> userData ,String format) {
  final _userData = userData;
    // Use real user data for export including years of smoking
    final quitDate = DateTime.parse(_userData["quitDate"] as String);
    final daysSinceQuit = DateTime.now().difference(quitDate).inDays;
    final moneySaved = (_userData["moneySaved"] as double).toStringAsFixed(2);
    final yearsSmoking = (_userData["yearsSmoking"] as double? ?? 0.0);
    final totalCigarettesSmoked =
        (_userData["totalCigarettesSmoked"] as int? ?? 0);
    final totalMoneySpent = (_userData["totalMoneySpent"] as double? ?? 0.0);

    String exportData = '';

    switch (format) {
      case 'PDF':
        exportData = '''
QuitSmoking Tracker - Progress Report
Generated: ${DateTime.now().toString().split('.')[0]}

User Information:
- Name: ${_userData["name"]}
- Quit Date: ${quitDate.day}/${quitDate.month}/${quitDate.year}
- Days Smoke-Free: $daysSinceQuit
- Current Streak: ${_userData["currentStreak"]} days

Smoking History:
- Years of Smoking: ${yearsSmoking.toStringAsFixed(1)} years
- Total Cigarettes Smoked: ${totalCigarettesSmoked.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}
- Total Money Spent on Smoking: \$${totalMoneySpent.toStringAsFixed(0)}

Financial Impact:
- Daily Cigarettes: ${_userData["cigarettesPerDay"]}
- Pack Cost: \${(_userData!["costPerPack"] as double).toStringAsFixed(2)}
- Money Saved: \$moneySaved

Health Progress:
- Health Progress: ${((_userData["healthProgress"] as double) * 100).toStringAsFixed(1)}%
- Health Stage: ${_userData["healthStage"]}
- Next Milestone: ${_userData["nextMilestone"]}
        ''';
        break;
      case 'CSV':
        exportData = '''
Date,Days Smoke-Free,Money Saved,Cigarettes Avoided,Health Progress,Years Smoked,Total Cigarettes Smoked,Total Money Spent
${DateTime.now().toString().split(' ')[0]},${_userData["currentStreak"]},\$moneySaved,${_userData["cigarettesAvoided"]},${((_userData["healthProgress"] as double) * 100).toStringAsFixed(1)}%,${yearsSmoking.toStringAsFixed(1)},${totalCigarettesSmoked},\$${totalMoneySpent.toStringAsFixed(2)}
        ''';
        break;
      case 'JSON':
        exportData = '''
{
  "user": {
    "name": "${_userData["name"]}",
    "quitDate": "${_userData["quitDate"]}",
    "cigarettesPerDay": ${_userData["cigarettesPerDay"]},
    "costPerPack": ${_userData["costPerPack"]},
    "yearsSmoking": ${yearsSmoking}
  },
  "smokingHistory": {
    "totalCigarettesSmoked": ${totalCigarettesSmoked},
    "totalMoneySpent": ${totalMoneySpent},
    "smokingPeriodDays": ${(_userData["smokingPeriodDays"] as int? ?? 0)}
  },
  "progress": {
    "currentStreak": ${_userData["currentStreak"]},
    "moneySaved": ${_userData["moneySaved"]},
    "cigarettesAvoided": ${_userData["cigarettesAvoided"]},
    "healthProgress": ${_userData["healthProgress"]},
    "healthStage": "${_userData["healthStage"]}"
  },
  "exportDate": "${DateTime.now().toIso8601String()}"
}
        ''';
        break;
    }

    // In a real app, this would trigger actual file download
    print('Export Data ($format):\n$exportData');
  }