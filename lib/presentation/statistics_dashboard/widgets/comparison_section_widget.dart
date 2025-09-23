import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ComparisonSectionWidget extends StatelessWidget {
  final Map<String, dynamic> userStats;
  final Map<String, dynamic> averageStats;
  final Map<String, dynamic> personalGoals;

  const ComparisonSectionWidget({
    super.key,
    required this.userStats,
    required this.averageStats,
    required this.personalGoals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
              'Progress Comparison',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildComparisonItem(
              'Days Smoke-Free',
              userStats['daysQuit'] as int,
              averageStats['daysQuit'] as int,
              personalGoals['daysGoal'] as int,
              'calendar_today',
            ),
            SizedBox(height: 1.5.h),
            _buildComparisonItem(
              'Money Saved',
              userStats['moneySaved'] as int,
              averageStats['moneySaved'] as int,
              personalGoals['moneyGoal'] as int,
              'attach_money',
            ),
            SizedBox(height: 1.5.h),
            _buildComparisonItem(
              'Cigarettes Avoided',
              userStats['cigarettesAvoided'] as int,
              averageStats['cigarettesAvoided'] as int,
              personalGoals['cigarettesGoal'] as int,
              'smoke_free',
            ),
            SizedBox(height: 2.h),
            _buildEncouragingMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonItem(
    String title,
    int userValue,
    int averageValue,
    int goalValue,
    String iconName,
  ) {
    final isAboveAverage = userValue > averageValue;
    final goalProgress =
        goalValue > 0 ? (userValue / goalValue).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You: $userValue',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Average: $averageValue',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: isAboveAverage
                    ? AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: isAboveAverage ? 'trending_up' : 'trending_down',
                    color: isAboveAverage
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : AppTheme.lightTheme.colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    isAboveAverage ? 'Above Avg' : 'Below Avg',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: isAboveAverage
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Goal Progress',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  '${(goalProgress * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            LinearProgressIndicator(
              value: goalProgress,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
              minHeight: 6,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEncouragingMessage() {
    final totalUserScore = (userStats['daysQuit'] as int) +
        ((userStats['moneySaved'] as int) / 10).round() +
        ((userStats['cigarettesAvoided'] as int) / 5).round();

    final totalAverageScore = (averageStats['daysQuit'] as int) +
        ((averageStats['moneySaved'] as int) / 10).round() +
        ((averageStats['cigarettesAvoided'] as int) / 5).round();

    String message;
    String iconName;
    Color messageColor;

    if (totalUserScore > totalAverageScore * 1.2) {
      message =
          "Outstanding progress! You're excelling beyond expectations. Keep up the amazing work!";
      iconName = 'star';
      messageColor = AppTheme.lightTheme.colorScheme.secondary;
    } else if (totalUserScore > totalAverageScore) {
      message =
          "Great job! You're performing above average. Your dedication is paying off!";
      iconName = 'thumb_up';
      messageColor = AppTheme.lightTheme.colorScheme.primary;
    } else {
      message =
          "You're making progress! Every step counts. Stay focused on your goals!";
      iconName = 'favorite';
      messageColor = AppTheme.lightTheme.colorScheme.tertiary;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: messageColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: messageColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: messageColor,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              message,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: messageColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
