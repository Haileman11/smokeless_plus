import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CravingFrequencyChart extends StatelessWidget {
  final String selectedPeriod;

  const CravingFrequencyChart({
    Key? key,
    required this.selectedPeriod,
  }) : super(key: key);

  List<FlSpot> _getCravingData() {
    switch (selectedPeriod) {
      case 'Week':
        return [
          FlSpot(0, 8),
          FlSpot(1, 6),
          FlSpot(2, 5),
          FlSpot(3, 4),
          FlSpot(4, 3),
          FlSpot(5, 2),
          FlSpot(6, 1),
        ];
      case 'Month':
        return [
          FlSpot(0, 8),
          FlSpot(5, 6),
          FlSpot(10, 4),
          FlSpot(15, 3),
          FlSpot(20, 2),
          FlSpot(25, 1),
          FlSpot(30, 1),
        ];
      case '3 Months':
        return [
          FlSpot(0, 8),
          FlSpot(15, 5),
          FlSpot(30, 3),
          FlSpot(45, 2),
          FlSpot(60, 1),
          FlSpot(75, 1),
          FlSpot(90, 0),
        ];
      case 'Year':
        return [
          FlSpot(0, 8),
          FlSpot(60, 4),
          FlSpot(120, 2),
          FlSpot(180, 1),
          FlSpot(240, 1),
          FlSpot(300, 0),
          FlSpot(365, 0),
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
                iconName: 'trending_down',
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Craving Frequency',
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
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: selectedPeriod == 'Year'
                          ? 60
                          : selectedPeriod == '3 Months'
                              ? 15
                              : selectedPeriod == 'Month'
                                  ? 5
                                  : 1,
                      getTitlesWidget: (value, meta) {
                        String text = '';
                        switch (selectedPeriod) {
                          case 'Week':
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
                          case 'Month':
                            text = '${value.toInt() + 1}';
                            break;
                          case '3 Months':
                            text = 'Day ${value.toInt()}';
                            break;
                          case 'Year':
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
                maxX: selectedPeriod == 'Year'
                    ? 365
                    : selectedPeriod == '3 Months'
                        ? 90
                        : selectedPeriod == 'Month'
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
                          '${barSpot.y.toInt()} cravings',
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
