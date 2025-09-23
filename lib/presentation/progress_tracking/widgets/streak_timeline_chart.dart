import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/user_data_service.dart';

class StreakTimelineChart extends StatefulWidget {
  final String selectedPeriod;

  const StreakTimelineChart({
    Key? key,
    required this.selectedPeriod,
  }) : super(key: key);

  @override
  State<StreakTimelineChart> createState() => _StreakTimelineChartState();
}

class _StreakTimelineChartState extends State<StreakTimelineChart> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await UserDataService.loadUserData();
    if (mounted) {
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    }
  }

  List<FlSpot> _getStreakData() {
    if (_userData == null) return [];

    final currentStreak = _userData!["currentStreak"] ?? 0;
    final hasStartedQuitting = _userData!["hasStartedQuitting"] ?? false;

    if (!hasStartedQuitting) return [];

    switch (widget.selectedPeriod) {
      case 'Week':
        // Show current week progress
        final daysInWeek = currentStreak >= 7 ? 7 : currentStreak + 1;
        return List.generate(daysInWeek,
            (index) => FlSpot(index.toDouble(), (index + 1).toDouble()));
      case 'Month':
        // Show progress over past 30 days or current streak if less
        final daysToShow = currentStreak >= 30 ? 30 : currentStreak;
        if (daysToShow == 0) return [FlSpot(0, 0)];

        final interval = daysToShow / 6;
        return List.generate(7, (index) {
          final day = (index * interval).round();
          return FlSpot(day.toDouble(), day.toDouble());
        });
      case '3 Months':
        // Show progress over past 90 days
        final daysToShow = currentStreak >= 90 ? 90 : currentStreak;
        if (daysToShow == 0) return [FlSpot(0, 0)];

        final interval = daysToShow / 6;
        return List.generate(7, (index) {
          final day = (index * interval).round();
          return FlSpot(day.toDouble(), day.toDouble());
        });
      case 'Year':
        // Show progress over past year
        final daysToShow = currentStreak >= 365 ? 365 : currentStreak;
        if (daysToShow == 0) return [FlSpot(0, 0)];

        final interval = daysToShow / 12;
        return List.generate(13, (index) {
          final day = (index * interval).round();
          return FlSpot(day.toDouble(), day.toDouble());
        });
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        height: 30.h,
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      );
    }

    final currentStreak = _userData?["currentStreak"] ?? 0;
    final hasStartedQuitting = _userData?["hasStartedQuitting"] ?? false;

    return Container(
      width: double.infinity,
      height: 30.h,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
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
                iconName: 'timeline',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Synchronized Smoke-Free Streak',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Current streak: $currentStreak days',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: !hasStartedQuitting
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: AppTheme.lightTheme.colorScheme.outline,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Your journey hasn\'t started yet',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Check your quit date in Profile settings',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval:
                            widget.selectedPeriod == 'Year' ? 50 : 10,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.1),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: widget.selectedPeriod == 'Year'
                                ? 60
                                : widget.selectedPeriod == '3 Months'
                                    ? 15
                                    : widget.selectedPeriod == 'Month'
                                        ? 5
                                        : 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                'Day ${value.toInt()}',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
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
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: widget.selectedPeriod == 'Year'
                          ? 365
                          : widget.selectedPeriod == '3 Months'
                              ? 90
                              : widget.selectedPeriod == 'Month'
                                  ? 30
                                  : 7,
                      minY: 0,
                      maxY: (currentStreak + 10).toDouble(),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _getStreakData(),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lightTheme.primaryColor,
                              AppTheme.lightTheme.colorScheme.secondary,
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: AppTheme.lightTheme.primaryColor,
                                strokeWidth: 2,
                                strokeColor:
                                    AppTheme.lightTheme.colorScheme.surface,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.3),
                                AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.1),
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
                                '${barSpot.y.toInt()} days smoke-free',
                                AppTheme.lightTheme.textTheme.bodySmall!
                                    .copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
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
