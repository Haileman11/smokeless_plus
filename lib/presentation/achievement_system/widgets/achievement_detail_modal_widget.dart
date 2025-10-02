import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';

import '../../../core/app_export.dart';

class AchievementDetailModalWidget extends StatelessWidget {
  final Map<String, dynamic> achievement;

  const AchievementDetailModalWidget({
    Key? key,
    required this.achievement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = achievement['isUnlocked'] ?? false;

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
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Large Badge Icon
                  Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      boxShadow: isUnlocked
                          ? [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary
                                    .withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: CustomIconWidget(
                      iconName: achievement['icon'] ?? 'emoji_events',
                      color: isUnlocked
                          ? Colors.white
                          : Colors.grey.withValues(alpha: 0.5),
                      size: 12.w,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Achievement Title
                  Text(
                    achievement['title'] ?? 'Achievement',
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 2.h),

                  // Points Badge
                  if (isUnlocked) ...[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '+${achievement['points'] ?? 0} Points Earned',
                        style:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${achievement['points'] ?? 0} Points Available',
                        style:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.grey.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 4.h),

                  // Description
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.description,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          achievement['description'] ??
                              'No description available.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Unlock Date or Criteria
                  if (isUnlocked) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color:
                                    Theme.of(context).colorScheme.secondary,
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                AppLocalizations.of(context)!.unlocked,
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
                            achievement['unlockDate'] ?? 'Recently unlocked',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'lock',
                                color: Colors.grey.withValues(alpha: 0.7),
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                AppLocalizations.of(context)!.howToUnlock,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                  color: Colors.grey.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            achievement['unlockCriteria'] ??
                                AppLocalizations.of(context)!.completeTheRequiredTasksToUnlockThisAchievement,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                              color: Colors.grey.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 4.h),

                  // Action Buttons
                  if (isUnlocked) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Share achievement functionality
                              Navigator.pop(context);
                            },
                            icon: CustomIconWidget(
                              iconName: 'share',
                              color: Colors.white,
                              size: 4.w,
                            ),
                            label: Text('Share Achievement'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
