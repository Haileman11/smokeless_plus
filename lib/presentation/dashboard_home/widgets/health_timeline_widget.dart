import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthTimelineWidget extends StatelessWidget {
  final String currentStage;
  final double progress;
  final String nextMilestone;
  final String timeToNext;

  const HealthTimelineWidget({
    Key? key,
    required this.currentStage,
    required this.progress,
    required this.nextMilestone,
    required this.timeToNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'favorite',
                  color: AppTheme.successLight,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Health Recovery Timeline',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Stage',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    currentStage,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.successLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Progress to Next Milestone',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.successLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Milestone',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        nextMilestone,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Time Remaining',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      timeToNext,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
