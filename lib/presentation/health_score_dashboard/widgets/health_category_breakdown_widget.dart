import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';

import '../../../core/app_export.dart';

class HealthCategoryBreakdownWidget extends StatelessWidget {
  final DateTime quitDate;

  const HealthCategoryBreakdownWidget({
    Key? key,
    required this.quitDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = _calculateHealthCategories();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.healthCategoryBreakdown,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                // color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 2.h),
            ...categories.map((category) => _buildCategoryItem(category, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: category['color'].withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: category['icon'],
                      color: category['color'],
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    category['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '${category['score']}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: category['color'],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: category['score'] / 100.0,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(category['color']),
            minHeight: 6,
          ),
          SizedBox(height: 1.h),
          Text(
            category['description'],
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _calculateHealthCategories() {
    final daysSinceQuit = DateTime.now().difference(quitDate).inDays;

    // Calculate scores based on days since quit
    int cardiovascularScore = _calculateScore(daysSinceQuit, [1, 30, 365]);
    int respiratoryScore = _calculateScore(daysSinceQuit, [3, 90, 365]);
    int circulationScore = _calculateScore(daysSinceQuit, [1, 14, 180]);
    int cancerRiskScore =
        _calculateScore(daysSinceQuit, [30, 365, 1825]); // 5 years

    return [
      {
        'title': 'Cardiovascular Improvement',
        'score': cardiovascularScore,
        'icon': 'favorite',
        'color': Color(0xFFE91E63),
        'description': daysSinceQuit >= 365
            ? 'Heart disease risk significantly reduced!'
            : daysSinceQuit >= 30
                ? 'Circulation improving, blood pressure normalizing'
                : 'Heart rate and blood pressure starting to improve',
      },
      {
        'title': 'Respiratory Function',
        'score': respiratoryScore,
        'icon': 'air',
        'color': Color(0xFF2196F3),
        'description': daysSinceQuit >= 365
            ? 'Lung function significantly improved!'
            : daysSinceQuit >= 90
                ? 'Coughing and shortness of breath decreasing'
                : 'Lung cilia recovering, less coughing',
      },
      {
        'title': 'Circulation Recovery',
        'score': circulationScore,
        'icon': 'timeline',
        'color': Color(0xFF4CAF50),
        'description': daysSinceQuit >= 180
            ? 'Blood circulation fully normalized!'
            : daysSinceQuit >= 14
                ? 'Walking easier, circulation improving'
                : 'Circulation starting to improve',
      },
      {
        'title': 'Cancer Risk Reduction',
        'score': cancerRiskScore,
        'icon': 'security',
        'color': Color(0xFF9C27B0),
        'description': daysSinceQuit >= 1825
            ? 'Cancer risk reduced by 50%!'
            : daysSinceQuit >= 365
                ? 'Cancer risk steadily decreasing'
                : 'Cancer risk beginning to decline',
      },
    ];
  }

  int _calculateScore(int daysSinceQuit, List<int> milestones) {
    if (daysSinceQuit >= milestones[2]) return 100;
    if (daysSinceQuit >= milestones[1]) return 75;
    if (daysSinceQuit >= milestones[0]) return 50;
    return (daysSinceQuit / milestones[0] * 25).clamp(0, 25).toInt();
  }
}
