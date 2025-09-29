import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MilestoneCardWidget extends StatelessWidget {
  final Map<String, dynamic> milestone;
  final bool isAchieved;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MilestoneCardWidget({
    Key? key,
    required this.milestone,
    required this.isAchieved,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isAchieved
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAchieved
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline
                    .withValues(alpha: 0.3),
            width: isAchieved ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAchieved
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline
                        .withValues(alpha: 0.5),
              ),
              child: isAchieved
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 4.w,
                    )
                  : null,
            ),
            SizedBox(width: 4.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeframe
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: isAchieved
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline
                              .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      milestone['timeframe'] ?? '',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isAchieved
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  // Title
                  Text(
                    milestone['title'] ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isAchieved
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  // Description
                  Text(
                    milestone['description'] ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isAchieved) ...[
                    SizedBox(height: 1.h),
                    // Achievement badge
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'emoji_events',
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Achieved!',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Action indicator
            CustomIconWidget(
              iconName: 'chevron_right',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}
