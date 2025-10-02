import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/utils/utils.dart';

import '../../../core/app_export.dart';

class CravingFrequencyChart extends StatelessWidget {
  final PeriodType selectedPeriod;

  const CravingFrequencyChart({
    super.key,
    required this.selectedPeriod,
  });

  List<FlSpot> _getCravingData() {
    switch (selectedPeriod) {
      case PeriodType.week:
        return [
          const FlSpot(0, 8),
          const FlSpot(1, 6),
          const FlSpot(2, 5),
          const FlSpot(3, 4),
          const FlSpot(4, 3),
          const FlSpot(5, 2),
          const FlSpot(6, 1),
        ];
      case PeriodType.month:
        return [
          const FlSpot(0, 8),
          const FlSpot(5, 6),
          const FlSpot(10, 4),
          const FlSpot(15, 3),
          const FlSpot(20, 2),
          const FlSpot(25, 1),
          const FlSpot(30, 1),
        ];
      case PeriodType.threeMonths:
        return [
          const FlSpot(0, 8),
          const FlSpot(15, 5),
          const FlSpot(30, 3),
          const FlSpot(45, 2),
          const FlSpot(60, 1),
          const FlSpot(75, 1),
          const FlSpot(90, 0),
        ];
      case PeriodType.year:
        return [
          const FlSpot(0, 8),
          const FlSpot(60, 4),
          const FlSpot(120, 2),
          const FlSpot(180, 1),
          const FlSpot(240, 1),
          const FlSpot(300, 0),
          const FlSpot(365, 0),
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'trending_down',
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                AppLocalizations.of(context)!.cravingFrequency,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Theme.of(context).colorScheme.outline
                          .withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: selectedPeriod == PeriodType.year
                          ? 60
                          : selectedPeriod == PeriodType.threeMonths
                              ? 15
                              : selectedPeriod == PeriodType.month
                                  ? 5
                                  : 1,
                      getTitlesWidget: (value, meta) {
                        String text = '';
                        switch (selectedPeriod) {
                          case PeriodType.week:
                            final days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun'
                            ];
                            if (value.toInt() < days.length)
                              text = days[value.toInt()];
                            break;
                          case PeriodType.month:
                            text = '${value.toInt() + 1}';
                            break;
                          case PeriodType.threeMonths:
                            text = 'Day ${value.toInt()}';
                            break;
                          case PeriodType.year:
                            text = 'M${(value / 30).round()}';
                            break;
                        }
                        return Text(
                          text,
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: selectedPeriod == PeriodType.year
                    ? 365
                    : selectedPeriod == PeriodType.threeMonths
                        ? 90
                        : selectedPeriod == PeriodType.month
                            ? 30
                            : 6,
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: _getCravingData(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.error,
                        Theme.of(context).colorScheme.error
                            .withValues(alpha: 0.6),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Theme.of(context).colorScheme.error,
                          strokeWidth: 2,
                          strokeColor: Theme.of(context).colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.error
                              .withValues(alpha: 0.2),
                          Theme.of(context).colorScheme.error
                              .withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '${barSpot.y.toInt()} ${AppLocalizations.of(context)!.cravings}',
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
