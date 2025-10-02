import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/utils/utils.dart';

import '../../../core/app_export.dart';

class HealthImprovementChart extends StatelessWidget {
  final PeriodType selectedPeriod;

  const HealthImprovementChart({
    Key? key,
    required this.selectedPeriod,
  }) : super(key: key);

  List<PieChartSectionData> _getHealthData(BuildContext context) {
    switch (selectedPeriod) {
      case PeriodType.week:
        return [
          PieChartSectionData(
            color: Theme.of(context).colorScheme.secondary,
            value: 25,
            title: 'Lung\nFunction\n25%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.primary,
            value: 35,
            title: 'Heart\nHealth\n35%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.tertiary,
            value: 40,
            title: 'Overall\nWellness\n40%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ];
      case PeriodType.month:
        return [
          PieChartSectionData(
            color: Theme.of(context).colorScheme.secondary,
            value: 45,
            title: AppLocalizations.of(context)!.lungFunction(45),
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.primary,
            value: 55,
            title: AppLocalizations.of(context)!.heartHealth(55),
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.tertiary,
            value: 60,
            title: AppLocalizations.of(context)!.overallWellness(60),
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ];
      case PeriodType.threeMonths:
        return [
          PieChartSectionData(
            color: Theme.of(context).colorScheme.secondary,
            value: 70,
            title: AppLocalizations.of(context)!.lungFunction(70),
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.primary,
            value: 75,
            title: AppLocalizations.of(context)!.heartHealth(75),
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.tertiary,
            value: 80,
            title: AppLocalizations.of(context)!.overallWellness(80),
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ];
      case PeriodType.year:
        return [
          PieChartSectionData(
            color: Theme.of(context).colorScheme.secondary,
            value: 90,
            title: AppLocalizations.of(context)!.lungFunction(90),
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.primary,
            value: 85,
            title: AppLocalizations.of(context)!.heartHealth(85),
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.tertiary,
            value: 95,
            title: AppLocalizations.of(context)!.overallWellness(95),
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ];
            
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30.h,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'favorite',
                color: Theme.of(context).colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                AppLocalizations.of(context)!.healthImprovement,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: _getHealthData(context),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
                pieTouchData: PieTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    // Handle touch events for interactive feedback
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}