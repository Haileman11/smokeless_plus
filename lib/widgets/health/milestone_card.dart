import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/health_milestone.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../common/progress_indicator.dart';

class MilestoneCard extends StatelessWidget {
  final HealthMilestone milestone;

  const MilestoneCard({Key? key, required this.milestone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final localizations = AppLocalizations.of(context);
    
    final isAchieved = appState.isHealthMilestoneAchieved(milestone.minutesAfterQuit);
    final progress = appState.getHealthProgress(milestone.minutesAfterQuit);
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isAchieved ? milestone.bgColor : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAchieved ? milestone.color : AppColors.border,
          width: isAchieved ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: milestone.color.withOpacity(isAchieved ? 1.0 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  milestone.icon,
                  color: isAchieved ? Colors.white : milestone.color,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLocalizedTitle(localizations, milestone.titleKey),
                      style: AppTextStyles.h4.copyWith(
                        color: isAchieved ? milestone.color : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _getLocalizedDescription(localizations, milestone.descriptionKey),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isAchieved ? milestone.color.withOpacity(0.8) : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isAchieved)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: milestone.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    localizations.achieved,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (!isAchieved) ...[
            SizedBox(height: 16),
            CustomProgressIndicator(
              progress: progress,
              progressColor: milestone.color,
              label: _getTimeRemaining(context, milestone.minutesAfterQuit, appState),
              showPercentage: true,
            ),
          ],
        ],
      ),
    );
  }

  String _getLocalizedTitle(AppLocalizations localizations, String titleKey) {
    switch (titleKey) {
      case 'bloodPressureHeartRateDrop':
        return localizations.bloodPressureHeartRateDrop;
      case 'carbonMonoxideNormalize':
        return localizations.carbonMonoxideNormalize;
      case 'heartAttackRiskDecrease':
        return localizations.heartAttackRiskDecrease;
      case 'airwaysRelax':
        return localizations.airwaysRelax;
      case 'circulationImprove':
        return localizations.circulationImprove;
      case 'lungsCleanUp':
        return localizations.lungsCleanUp;
      case 'nervesRegenerate':
        return localizations.nervesRegenerate;
      case 'lungCancerRiskHalved':
        return localizations.lungCancerRiskHalved;
      default:
        return titleKey;
    }
  }

  String _getLocalizedDescription(AppLocalizations localizations, String descriptionKey) {
    switch (descriptionKey) {
      case 'heartRateBloodPressureDesc':
        return localizations.heartRateBloodPressureDesc;
      case 'carbonMonoxideDesc':
        return localizations.carbonMonoxideDesc;
      case 'heartAttackRiskDesc':
        return localizations.heartAttackRiskDesc;
      case 'airwaysDesc':
        return localizations.airwaysDesc;
      case 'circulationDesc':
        return localizations.circulationDesc;
      case 'lungsDesc':
        return localizations.lungsDesc;
      case 'nervesDesc':
        return localizations.nervesDesc;
      case 'lungCancerDesc':
        return localizations.lungCancerDesc;
      default:
        return descriptionKey;
    }
  }

  String _getTimeRemaining(BuildContext context, int minutesAfterQuit, AppState appState) {
    final stats = appState.getQuitStats();
    final totalMinutes = stats['totalMinutes'] as int? ?? 0;
    final remainingMinutes = minutesAfterQuit - totalMinutes;
    
    if (remainingMinutes <= 0) return '';
    
    final localizations = AppLocalizations.of(context);
    
    if (remainingMinutes < 60) {
      return '$remainingMinutes${localizations.minutesRemaining}';
    } else if (remainingMinutes < 1440) { // Less than 24 hours
      final hours = (remainingMinutes / 60).floor();
      return '$hours${localizations.hoursRemaining}';
    } else if (remainingMinutes < 43200) { // Less than 30 days
      final days = (remainingMinutes / 1440).floor();
      return '$days${localizations.daysRemaining}';
    } else if (remainingMinutes < 525600) { // Less than 365 days
      final months = (remainingMinutes / 43200).floor();
      return '$months${localizations.monthsRemaining}';
    } else {
      final years = (remainingMinutes / 525600).floor();
      return '$years${localizations.yearsRemaining}';
    }
  }
}