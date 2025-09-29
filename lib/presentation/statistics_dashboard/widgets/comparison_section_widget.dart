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
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Comparison',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
              context
            ),
            SizedBox(height: 1.5.h),
            _buildComparisonItem(
              'Money Saved',
              userStats['moneySaved'] as int,
              averageStats['moneySaved'] as int,
              personalGoals['moneyGoal'] as int,
              'attach_money',
              context
            ),
            SizedBox(height: 1.5.h),
            _buildComparisonItem(
              'Cigarettes Avoided',
              userStats['cigarettesAvoided'] as int,
              averageStats['cigarettesAvoided'] as int,
              personalGoals['cigarettesGoal'] as int,
              'smoke_free',
              context
            ),
            SizedBox(height: 2.h),
            _buildEncouragingMessage(context),
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
    BuildContext context
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
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Average: $averageValue',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: isAboveAverage
                    ? Theme.of(context).colorScheme.secondary
                        .withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.tertiary
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: isAboveAverage ? 'trending_up' : 'trending_down',
                    color: isAboveAverage
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    isAboveAverage ? 'Above Avg' : 'Below Avg',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isAboveAverage
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.tertiary,
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  '${(goalProgress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            LinearProgressIndicator(
              value: goalProgress,
              backgroundColor: Theme.of(context).colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              minHeight: 6,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEncouragingMessage(BuildContext context) {
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
      messageColor = Theme.of(context).colorScheme.secondary;
    } else if (totalUserScore > totalAverageScore) {
      message =
          "Great job! You're performing above average. Your dedication is paying off!";
      iconName = 'thumb_up';
      messageColor = Theme.of(context).colorScheme.primary;
    } else {
      message =
          "You're making progress! Every step counts. Stay focused on your goals!";
      iconName = 'favorite';
      messageColor = Theme.of(context).colorScheme.tertiary;
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
