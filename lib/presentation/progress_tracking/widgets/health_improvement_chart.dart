import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthImprovementChart extends StatelessWidget {
  final String selectedPeriod;

  const HealthImprovementChart({
    Key? key,
    required this.selectedPeriod,
  }) : super(key: key);

  List<PieChartSectionData> _getHealthData(BuildContext context) {
    switch (selectedPeriod) {
      case 'Week':
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
      case 'Month':
        return [
          PieChartSectionData(
            color: Theme.of(context).colorScheme.secondary,
            value: 45,
            title: 'Lung\nFunction\n45%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.primary,
            value: 55,
            title: 'Heart\nHealth\n55%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.tertiary,
            value: 60,
            title: 'Overall\nWellness\n60%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ];
      case '3 Months':
        return [
          PieChartSectionData(
            color: Theme.of(context).colorScheme.secondary,
            value: 70,
            title: 'Lung\nFunction\n70%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.primary,
            value: 75,
            title: 'Heart\nHealth\n75%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.tertiary,
            value: 80,
            title: 'Overall\nWellness\n80%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ];
      case 'Year':
        return [
          PieChartSectionData(
            color: Theme.of(context).colorScheme.secondary,
            value: 90,
            title: 'Lung\nFunction\n90%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.primary,
            value: 85,
            title: 'Heart\nHealth\n85%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          PieChartSectionData(
            color: Theme.of(context).colorScheme.tertiary,
            value: 95,
            title: 'Overall\nWellness\n95%',
            radius: 60,
            titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ];
      default:
        return [];
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
                'Health Improvement',
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