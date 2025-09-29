import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ComparisonChartWidget extends StatelessWidget {
  final double userProgress;
  final int quitDays;

  const ComparisonChartWidget({
    Key? key,
    required this.userProgress,
    required this.quitDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comparisonData = _generateComparisonData();

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
              'Recovery Progress Comparison',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                // color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'See how your progress compares to average recovery patterns',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
            ),
            SizedBox(height: 3.h),
            _buildChart(context),
            SizedBox(height: 2.h),
            _buildLegend(context),
            SizedBox(height: 2.h),
            _buildEncouragingMessage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    return SizedBox(
      height: 25.h,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              // tooltipBgColor: Theme.of(context).colorScheme.primary,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String category;
                switch (group.x.toInt()) {
                  case 0:
                    category = 'Cardiovascular';
                    break;
                  case 1:
                    category = 'Respiratory';
                    break;
                  case 2:
                    category = 'Circulation';
                    break;
                  case 3:
                    category = 'Overall Health';
                    break;
                  default:
                    category = 'Health';
                }
                return BarTooltipItem(
                  '$category\n${rod.toY.toInt()}%',
                  Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text(
                        'Cardio',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      );
                    case 1:
                      return Text(
                        'Lungs',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      );
                    case 2:
                      return Text(
                        'Circulation',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      );
                    case 3:
                      return Text(
                        'Overall',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      );
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(context),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade300,
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Your Progress', Theme.of(context).colorScheme.primary, context),
        SizedBox(width: 6.w),
        _buildLegendItem('Average', Colors.grey.shade400, context),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4.w,
          height: 2.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEncouragingMessage(BuildContext context) {
    final userScore = (userProgress * 100).toInt();
    final averageScore = _getAverageScore();

    String message;
    Color messageColor;
    String iconName;

    if (userScore > averageScore) {
      message =
          'Excellent! You\'re recovering faster than average. Keep up the great work!';
      messageColor = AppTheme.successLight;
      iconName = 'trending_up';
    } else if (userScore >= averageScore * 0.8) {
      message =
          'You\'re doing great! Your progress is right on track with typical recovery patterns.';
      messageColor = Theme.of(context).colorScheme.primary;
      iconName = 'thumb_up';
    } else {
      message =
          'Every quit journey is unique. Stay committed - your health improvements will accelerate!';
      messageColor = Color(0xFFFF8F00);
      iconName = 'support';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: messageColor.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: messageColor.withAlpha(51),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: messageColor,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: messageColor,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(BuildContext context) {
    final data = _generateComparisonData();

    return data.map((category) {
      return BarChartGroupData(
        x: category['index'],
        barRods: [
          BarChartRodData(
            toY: category['userScore'].toDouble(),
            color: Theme.of(context).colorScheme.primary,
            width: 5.w,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: category['averageScore'].toDouble(),
            color: Colors.grey.shade400,
            width: 5.w,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  List<Map<String, dynamic>> _generateComparisonData() {
    // Calculate user scores based on quit days
    int cardiovascularScore = _calculateHealthScore(quitDays, [1, 30, 365]);
    int respiratoryScore = _calculateHealthScore(quitDays, [3, 90, 365]);
    int circulationScore = _calculateHealthScore(quitDays, [1, 14, 180]);
    int overallScore = (userProgress * 100).toInt();

    // Average scores for comparison
    int avgCardiovascular = _getAverageHealthScore(quitDays, [1, 30, 365]);
    int avgRespiratory = _getAverageHealthScore(quitDays, [3, 90, 365]);
    int avgCirculation = _getAverageHealthScore(quitDays, [1, 14, 180]);
    int avgOverall = _getAverageScore();

    return [
      {
        'index': 0,
        'category': 'Cardiovascular',
        'userScore': cardiovascularScore,
        'averageScore': avgCardiovascular,
      },
      {
        'index': 1,
        'category': 'Respiratory',
        'userScore': respiratoryScore,
        'averageScore': avgRespiratory,
      },
      {
        'index': 2,
        'category': 'Circulation',
        'userScore': circulationScore,
        'averageScore': avgCirculation,
      },
      {
        'index': 3,
        'category': 'Overall',
        'userScore': overallScore,
        'averageScore': avgOverall,
      },
    ];
  }

  int _calculateHealthScore(int days, List<int> milestones) {
    if (days >= milestones[2]) return 100;
    if (days >= milestones[1]) return 75;
    if (days >= milestones[0]) return 50;
    return (days / milestones[0] * 25).clamp(0, 25).toInt();
  }

  int _getAverageHealthScore(int days, List<int> milestones) {
    // Simulated average scores (slightly lower than optimal)
    if (days >= milestones[2]) return 85;
    if (days >= milestones[1]) return 65;
    if (days >= milestones[0]) return 40;
    return (days / milestones[0] * 20).clamp(0, 20).toInt();
  }

  int _getAverageScore() {
    // Average score based on quit days (simulated data)
    if (quitDays >= 365) return 75;
    if (quitDays >= 90) return 55;
    if (quitDays >= 30) return 40;
    if (quitDays >= 7) return 25;
    return 15;
  }
}
