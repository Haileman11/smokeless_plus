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