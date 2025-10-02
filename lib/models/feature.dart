import 'dart:ui';

import 'package:smokeless_plus/l10n/app_localizations.dart';

class Feature {
  final String titleKey;
  final String descriptionKey;
  final String icon;
  final String route;
  final Color color;

  const Feature({
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.route,
    required this.color,
  });

  
}
extension FeatureExtension on Feature {
  String title(AppLocalizations l10n) {
    switch(titleKey) {
      case "feature_progress_tracking_title":
        return l10n.feature_progress_tracking_title;
      case "feature_health_milestones_title":
        return l10n.feature_health_milestones_title;
      case "feature_achievement_system_title":
        return l10n.feature_achievement_system_title;
      case "feature_craving_support_title":
        return l10n.feature_craving_support_title;

      default:
        return '';
    }
  }

  String description(AppLocalizations l10n) {
    switch(descriptionKey) {
      case "feature_progress_tracking_description":
        return l10n.feature_progress_tracking_description;
      case "feature_health_milestones_description":
        return l10n.feature_health_milestones_description;
      case "feature_achievement_system_description":
        return l10n.feature_achievement_system_description;
      case "feature_craving_support_description":
        return l10n.feature_craving_support_description;
      
      default:
        return '';
    }
  }
}