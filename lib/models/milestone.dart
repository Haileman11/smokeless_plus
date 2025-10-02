import 'package:flutter/material.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/utils/utils.dart';

class Milestone {
  final int id;
  final String titleKey;
  final String descriptionKey;
  final String icon;
  final bool achieved;
  final DateTime date;
  final MotivationCategory category;

  const Milestone({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.achieved,
    required this.date,
    required this.category,
  });

  // String getTitle(AppLocalizations l10n) => l10n;
  // String getDescription(AppLocalizations l10n) => l10n.get(descriptionKey);
}
extension MilestoneExtension on Milestone {
  String title(AppLocalizations l10n) {
    switch(id) {
      case 1:
        return l10n.milestone_20_minutes_title;
      case 2:
        return l10n.milestone_12_hours_title;
      case 3:
        return l10n.milestone_2_weeks_title;
      case 4:
        return l10n.milestone_1_month_title;
      case 5:
        return l10n.milestone_3_months_title;
      case 6:
        return l10n.milestone_1_year_title;
      default:
        return '';
    }
  }

  String description(AppLocalizations l10n) {
    switch(id) {
      case 1:
        return l10n.milestone_20_minutes_description;
      case 2:
        return l10n.milestone_12_hours_description;
      case 3:
        return l10n.milestone_2_weeks_description;
      case 4:
        return l10n.milestone_1_month_description;
      case 5:
        return l10n.milestone_3_months_description;
      case 6:
        return l10n.milestone_1_year_description;
      default:
        return '';
    }
  }
}