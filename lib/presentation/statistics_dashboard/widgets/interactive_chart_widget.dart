import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class InteractiveChartWidget extends StatefulWidget {
  final String chartType;
  final List<Map<String, dynamic>> chartData;

  const InteractiveChartWidget({
    super.key,
    required this.chartType,
    required this.chartData,
  });

  @override
  State<InteractiveChartWidget> createState() => _InteractiveChartWidgetState();
}

class _InteractiveChartWidgetState extends State<InteractiveChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
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
              _getChartTitle(),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: _buildChart(),
            ),
          ],
        ),
      ),
    );
  }

  String _getChartTitle() {
    switch (widget.chartType) {
      case 'Daily Streak':
        return 'Daily Streak Consistency';
      case 'Weekly Cravings':
        return 'Weekly Craving Frequency';
      case 'Monthly Savings':
        return 'Monthly Savings Accumulation';
      case 'Health Progress':
        return 'Health Milestone Progress';
      default:
        return 'Statistics Chart';
    }
  }

  Widget _buildChart() {
    switch (widget.chartType) {
      case 'Daily Streak':
        return _buildLineChart();
      case 'Weekly Cravings':
        return _buildBarChart();
      case 'Monthly Savings':
        return _buildLineChart();
      case 'Health Progress':
        return _buildPieChart();
      default:
        return _buildLineChart();
    }
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
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
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() < widget.chartData.length) {
                  return SideTitleWidget(
                    meta: meta,                    
                    
                    child: Text(
                      widget.chartData[value.toInt()]['label'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                  ),
                );
              },
              reservedSize: 32,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        minX: 0,
        maxX: (widget.chartData.length - 1).toDouble(),
        minY: 0,
        maxY: _getMaxYValue(),
        lineBarsData: [
          LineChartBarData(
            spots: widget.chartData.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                (entry.value['value'] as num).toDouble(),
              );
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.lightTheme.colorScheme.primary,
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
                  color: AppTheme.lightTheme.colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: AppTheme.lightTheme.colorScheme.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  AppTheme.lightTheme.colorScheme.primary
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
            // tooltipBgColor: AppTheme.lightTheme.colorScheme.surface,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                  '${widget.chartData[flSpot.x.toInt()]['label']}\n${flSpot.y.toInt()}',
                  AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxYValue(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: AppTheme.lightTheme.colorScheme.surface,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${widget.chartData[group.x]['label']}\n${rod.toY.toInt()}',
                AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
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
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() < widget.chartData.length) {
                  return SideTitleWidget(
                    // axisSide: meta.axisSide,
                    meta: meta,
                    child: Text(
                      widget.chartData[value.toInt()]['label'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 38,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: widget.chartData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: (entry.value['value'] as num).toDouble(),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.secondary,
                    AppTheme.lightTheme.colorScheme.primary,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 6.w,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 15.w,
        sections: widget.chartData.asMap().entries.map((entry) {
          final isTouched = entry.key == touchedIndex;
          final fontSize = isTouched ? 14.sp : 12.sp;
          final radius = isTouched ? 18.w : 16.w;

          return PieChartSectionData(
            color: _getPieChartColor(entry.key),
            value: (entry.value['value'] as num).toDouble(),
            title: '${entry.value['value']}%',
            radius: radius,
            titleStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getPieChartColor(int index) {
    final colors = [
      AppTheme.lightTheme.colorScheme.primary,
      AppTheme.lightTheme.colorScheme.secondary,
      AppTheme.lightTheme.colorScheme.tertiary,
      AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.7),
    ];
    return colors[index % colors.length];
  }

  double _getMaxYValue() {
    if (widget.chartData.isEmpty) return 10;

    final maxValue = widget.chartData
        .map((data) => (data['value'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);

    return (maxValue * 1.2).ceilToDouble();
  }
}