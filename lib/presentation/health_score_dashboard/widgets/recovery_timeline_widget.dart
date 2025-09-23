import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecoveryTimelineWidget extends StatefulWidget {
  final DateTime quitDate;
  final double healthProgress;

  const RecoveryTimelineWidget({
    Key? key,
    required this.quitDate,
    required this.healthProgress,
  }) : super(key: key);

  @override
  State<RecoveryTimelineWidget> createState() => _RecoveryTimelineWidgetState();
}

class _RecoveryTimelineWidgetState extends State<RecoveryTimelineWidget> {
  int _selectedPeriod = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor.withAlpha(26),
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
              'Recovery Timeline',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(height: 2.h),
            _buildChart(),
            SizedBox(height: 2.h),
            _buildTimelineDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final chartData = _generateChartData();

    return SizedBox(
      height: 25.h,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            touchCallback:
                (FlTouchEvent event, LineTouchResponse? touchResponse) {
              if (touchResponse != null && touchResponse.lineBarSpots != null) {
                final spot = touchResponse.lineBarSpots!.first;
                setState(() {
                  _selectedPeriod = spot.x.toInt();
                });
              }
            },
            touchTooltipData: LineTouchTooltipData(
              // tooltipBgColor: AppTheme.lightTheme.primaryColor,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final period = _getPeriodLabel(touchedSpot.x.toInt());
                  return LineTooltipItem(
                    '$period\n${touchedSpot.y.toInt()}% Recovery',
                    AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _getPeriodLabel(value.toInt()),
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: chartData,
              isCurved: true,
              color: AppTheme.lightTheme.primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppTheme.lightTheme.primaryColor,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.lightTheme.primaryColor.withAlpha(51),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineDetails() {
    final milestones = _getHealthMilestones();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Recovery Milestones',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...milestones.map((milestone) => _buildMilestoneItem(milestone)),
      ],
    );
  }

  Widget _buildMilestoneItem(Map<String, dynamic> milestone) {
    final isAchieved = milestone['achieved'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isAchieved
            ? AppTheme.successLight.withAlpha(26)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAchieved
              ? AppTheme.successLight.withAlpha(77)
              : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isAchieved ? 'check_circle' : 'schedule',
            color: isAchieved ? AppTheme.successLight : Colors.grey.shade600,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone['title'],
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isAchieved
                        ? AppTheme.successLight
                        : Colors.grey.shade700,
                  ),
                ),
                Text(
                  milestone['description'],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ],
            ),
          ),
          Text(
            milestone['timeframe'],
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isAchieved ? AppTheme.successLight : Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateChartData() {
    final daysSinceQuit = DateTime.now().difference(widget.quitDate).inDays;

    return [
      FlSpot(0, 0), // Start
      FlSpot(1, daysSinceQuit >= 1 ? 15 : (daysSinceQuit * 15)), // 1 day
      FlSpot(
          2,
          daysSinceQuit >= 7
              ? 30
              : (daysSinceQuit >= 1
                  ? 15 + (daysSinceQuit - 1) * 2.5
                  : 0)), // 1 week
      FlSpot(
          3,
          daysSinceQuit >= 30
              ? 50
              : (daysSinceQuit >= 7
                  ? 30 + (daysSinceQuit - 7) * 0.8
                  : 0)), // 1 month
      FlSpot(
          4,
          daysSinceQuit >= 90
              ? 70
              : (daysSinceQuit >= 30
                  ? 50 + (daysSinceQuit - 30) * 0.33
                  : 0)), // 3 months
      FlSpot(
          5,
          daysSinceQuit >= 365
              ? 85
              : (daysSinceQuit >= 90
                  ? 70 + (daysSinceQuit - 90) * 0.055
                  : 0)), // 1 year
      FlSpot(
          6,
          daysSinceQuit >= 1825
              ? 95
              : (daysSinceQuit >= 365
                  ? 85 + (daysSinceQuit - 365) * 0.0068
                  : 0)), // 5 years
    ];
  }

  String _getPeriodLabel(int index) {
    const labels = ['Start', '1D', '1W', '1M', '3M', '1Y', '5Y'];
    return labels[index];
  }

  List<Map<String, dynamic>> _getHealthMilestones() {
    final daysSinceQuit = DateTime.now().difference(widget.quitDate).inDays;

    return [
      {
        'title': '20 minutes',
        'description': 'Heart rate and blood pressure drop',
        'timeframe': '20 min',
        'achieved': true,
      },
      {
        'title': '12 hours',
        'description': 'Carbon monoxide level normalizes',
        'timeframe': '12 hrs',
        'achieved': daysSinceQuit >= 1,
      },
      {
        'title': '2 weeks',
        'description': 'Circulation improves, lung function increases',
        'timeframe': '2 weeks',
        'achieved': daysSinceQuit >= 14,
      },
      {
        'title': '1 month',
        'description': 'Coughing and shortness of breath decrease',
        'timeframe': '1 month',
        'achieved': daysSinceQuit >= 30,
      },
      {
        'title': '1 year',
        'description': 'Heart disease risk cut in half',
        'timeframe': '1 year',
        'achieved': daysSinceQuit >= 365,
      },
    ];
  }
}
