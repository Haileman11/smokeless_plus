import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/user_data_service.dart';

class MoneySavedChart extends StatefulWidget {
  final String selectedPeriod;

  const MoneySavedChart({
    Key? key,
    required this.selectedPeriod,
  }) : super(key: key);

  @override
  State<MoneySavedChart> createState() => _MoneySavedChartState();
}

class _MoneySavedChartState extends State<MoneySavedChart> {
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

  List<BarChartGroupData> _getMoneySavedData() {
    if (_userData == null) return [];

    final currentStreak = _userData!["currentStreak"] ?? 0;
    final moneySaved = _userData!["moneySaved"] ?? 0.0;
    final hasStartedQuitting = _userData!["hasStartedQuitting"] ?? false;

    if (!hasStartedQuitting || currentStreak == 0) return [];

    switch (widget.selectedPeriod) {
      case 'Week':
        // Show daily savings for the week
        final dailySaving =
            moneySaved / (currentStreak > 7 ? 7 : currentStreak);
        return List.generate(currentStreak > 7 ? 7 : currentStreak, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: dailySaving * (index + 1),
                color: AppTheme.successLight,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        });
      case 'Month':
        // Show weekly savings for the month
        final weeklySaving = moneySaved / (currentStreak / 7);
        final weeksToShow =
            currentStreak >= 30 ? 4 : (currentStreak / 7).ceil();
        return List.generate(weeksToShow, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: weeklySaving * (index + 1),
                color: AppTheme.successLight,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        });
      case '3 Months':
        // Show monthly savings
        final monthlySaving = moneySaved / (currentStreak / 30);
        final monthsToShow =
            currentStreak >= 90 ? 3 : (currentStreak / 30).ceil();
        return List.generate(monthsToShow, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: monthlySaving * (index + 1),
                color: AppTheme.successLight,
                width: 24,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        });
      case 'Year':
        // Show quarterly savings
        final quarterlySaving = moneySaved / (currentStreak / 90);
        final quartersToShow =
            currentStreak >= 365 ? 4 : (currentStreak / 90).ceil();
        return List.generate(quartersToShow, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: quarterlySaving * (index + 1),
                color: AppTheme.successLight,
                width: 28,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
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

    final moneySaved = _userData?["moneySaved"] ?? 0.0;
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
                iconName: 'savings',
                color: AppTheme.successLight,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Synchronized Money Saved',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Total saved: \$${moneySaved.toStringAsFixed(2)}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.successLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: !hasStartedQuitting
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'savings',
                          color: AppTheme.lightTheme.colorScheme.outline,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Start saving money today!',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Set your quit date to see savings',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,                      
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '\$${rod.toY.toStringAsFixed(2)}',
                              AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
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
                            getTitlesWidget: (value, meta) {
                              String text = '';
                              switch (widget.selectedPeriod) {
                                case 'Week':
                                  final days = [
                                    'M',
                                    'T',
                                    'W',
                                    'T',
                                    'F',
                                    'S',
                                    'S'
                                  ];
                                  if (value.toInt() < days.length)
                                    text = days[value.toInt()];
                                  break;
                                case 'Month':
                                  text = 'W${value.toInt() + 1}';
                                  break;
                                case '3 Months':
                                  text = 'M${value.toInt() + 1}';
                                  break;
                                case 'Year':
                                  text = 'Q${value.toInt() + 1}';
                                  break;
                              }
                              return Text(
                                text,
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
                                '\$${value.toInt()}',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: _getMoneySavedData(),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.1),
                            strokeWidth: 1,
                          );
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
