import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/utils/utils.dart';

import '../../../core/app_export.dart';

class RecentAchievementsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentAchievements;
  final Function(Map<String, dynamic>) onAchievementTap;

  const RecentAchievementsWidget({
    Key? key,
    required this.recentAchievements,
    required this.onAchievementTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recentAchievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'new_releases',
                color: Theme.of(context).colorScheme.tertiary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                AppLocalizations.of(context)!.recentAchievements,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 12.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentAchievements.length,
              itemBuilder: (context, index) {
                final achievement = recentAchievements[index];
                return GestureDetector(
                  onTap: () => onAchievementTap(achievement),
                  child: Container(
                    width: 70.w,
                    margin: EdgeInsets.only(right: 3.w),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.tertiary
                            .withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.tertiary
                              .withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Achievement Icon
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: achievement['icon'] ?? 'emoji_events',
                            color: Colors.white,
                            size: 6.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        // Achievement Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      achievement['title'] ?? 'Achievement',
                                      style: Theme.of(context).textTheme.titleSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.tertiary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.newText,
                                      style: Theme.of(context).textTheme.labelSmall
                                          ?.copyWith(
                                        color: Theme.of(context).colorScheme.onTertiary,
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                '+${achievement['points'] ?? 0} ${AppLocalizations.of(context)!.pointsEarned}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                DateFormat.yMMMd().format(
                                    DateTime.parse( achievement['unlockDate']) ?? DateTime.now()),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
