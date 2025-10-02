import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/utils/utils.dart';

import '../../../core/app_export.dart';
import '../../../services/user_data_service.dart';

class StreakTimelineChart extends StatefulWidget {
  final PeriodType selectedPeriod;

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
      case PeriodType.week:
        // Show current week progress
        final daysInWeek = currentStreak >= 7 ? 7 : currentStreak + 1;
        return List.generate(daysInWeek,
            (index) => FlSpot(index.toDouble(), (index + 1).toDouble()));
      case PeriodType.month:
        // Show progress over past 30 days or current streak if less
        final daysToShow = currentStreak >= 30 ? 30 : currentStreak;
        if (daysToShow == 0) return [FlSpot(0, 0)];

        final interval = daysToShow / 6;
        return List.generate(7, (index) {
          final day = (index * interval).round();
          return FlSpot(day.toDouble(), day.toDouble());
        });
      case PeriodType.threeMonths:
        // Show progress over past 90 days
        final daysToShow = currentStreak >= 90 ? 90 : currentStreak;
        if (daysToShow == 0) return [FlSpot(0, 0)];

        final interval = daysToShow / 6;
        return List.generate(7, (index) {
          final day = (index * interval).round();
          return FlSpot(day.toDouble(), day.toDouble());
        });
      case PeriodType.year:
        // Show progress over past year
        final daysToShow = currentStreak >= 365 ? 365 : currentStreak;
        if (daysToShow == 0) return [FlSpot(0, 0)];

        final interval = daysToShow / 12;
        return List.generate(13, (index) {
          final day = (index * interval).round();
          return FlSpot(day.toDouble(), day.toDouble());
        });      
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
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
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
                iconName: 'timeline',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                AppLocalizations.of(context)!.synchronizedSmokeFreeStreak,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '${AppLocalizations.of(context)!.currentStreak}: $currentStreak days',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
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
                          color: Theme.of(context).colorScheme.outline,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          AppLocalizations.of(context)!.yourJourneyHasntStartedYet,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          AppLocalizations.of(context)!.checkYourQuitDate,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
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
                            color: Theme.of(context).colorScheme.outline
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
                      maxX: widget.selectedPeriod == PeriodType.year
                          ? 365
                          : widget.selectedPeriod == PeriodType.threeMonths
                              ? 90
                              : widget.selectedPeriod == PeriodType.month
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
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Theme.of(context).colorScheme.primary,
                                strokeWidth: 2,
                                strokeColor:
                                    Theme.of(context).colorScheme.surface,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary
                                    .withValues(alpha: 0.3),
                                Theme.of(context).colorScheme.secondary
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
                                '${barSpot.y.toInt()} ${AppLocalizations.of(context)!.daysSmokeFree}',
                                Theme.of(context).textTheme.bodySmall!
                                    .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
