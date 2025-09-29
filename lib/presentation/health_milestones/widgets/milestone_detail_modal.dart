import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MilestoneDetailModal extends StatelessWidget {
  final Map<String, dynamic> milestone;
  final bool isAchieved;
  final VoidCallback? onShare;

  const MilestoneDetailModal({
    Key? key,
    required this.milestone,
    required this.isAchieved,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAchieved
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline
                            .withValues(alpha: 0.3),
                  ),
                  child: isAchieved
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 6.w,
                        )
                      : CustomIconWidget(
                          iconName: 'schedule',
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 6.w,
                        ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: isAchieved
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline
                                  .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          milestone['timeframe'] ?? '',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                            color: isAchieved
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        milestone['title'] ?? '',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  if (isAchieved) ...[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.tertiary,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'emoji_events',
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Milestone Achieved!',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],
                  // Description
                  Text(
                    'Health Benefit',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    milestone['description'] ?? '',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  // Scientific explanation
                  Text(
                    'Medical Explanation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary
                          .withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      milestone['scientificExplanation'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  // Tips section
                  if (milestone['tips'] != null) ...[
                    Text(
                      'Tips to Maximize Benefits',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(milestone['tips'] as List)
                        .map((tip) => Padding(
                              padding: EdgeInsets.only(bottom: 1.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 0.5.h),
                                    width: 1.w,
                                    height: 1.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      tip,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    SizedBox(height: 3.h),
                  ],
                  // Motivational content
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.secondary
                              .withValues(alpha: 0.1),
                          Theme.of(context).colorScheme.tertiary
                              .withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'psychology',
                              color: Theme.of(context).colorScheme.secondary,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Motivation',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          milestone['motivationalMessage'] ??
                              'Every step forward is a victory for your health!',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          // Action buttons
          if (isAchieved) ...[
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onShare,
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: Theme.of(context).colorScheme.primary,
                        size: 5.w,
                      ),
                      label: Text('Share Achievement'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'celebration',
                        color: Colors.white,
                        size: 5.w,
                      ),
                      label: Text('Celebrate'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
