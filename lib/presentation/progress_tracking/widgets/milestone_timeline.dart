import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MilestoneTimeline extends StatelessWidget {
  final String selectedPeriod;

  const MilestoneTimeline({
    Key? key,
    required this.selectedPeriod,
  }) : super(key: key);

  List<Map<String, dynamic>> _getMilestones() {
    final allMilestones = [
      {
        "id": 1,
        "title": "20 Minutes",
        "description": "Heart rate and blood pressure drop",
        "icon": "favorite",
        "achieved": true,
        "date": DateTime.now().subtract(Duration(days: 30)),
        "category": "Health"
      },
      {
        "id": 2,
        "title": "12 Hours",
        "description": "Carbon monoxide level normalizes",
        "icon": "air",
        "achieved": true,
        "date": DateTime.now().subtract(Duration(days: 29)),
        "category": "Health"
      },
      {
        "id": 3,
        "title": "2 Weeks",
        "description": "Circulation improves and lung function increases",
        "icon": "healing",
        "achieved": true,
        "date": DateTime.now().subtract(Duration(days: 16)),
        "category": "Health"
      },
      {
        "id": 4,
        "title": "1 Month",
        "description": "Coughing and shortness of breath decrease",
        "icon": "self_improvement",
        "achieved": true,
        "date": DateTime.now(),
        "category": "Health"
      },
      {
        "id": 5,
        "title": "3 Months",
        "description": "Risk of heart attack begins to drop",
        "icon": "monitor_heart",
        "achieved": false,
        "date": DateTime.now().add(Duration(days: 60)),
        "category": "Health"
      },
      {
        "id": 6,
        "title": "1 Year",
        "description": "Risk of heart disease is cut in half",
        "icon": "health_and_safety",
        "achieved": false,
        "date": DateTime.now().add(Duration(days: 335)),
        "category": "Health"
      },
    ];

    // Filter milestones based on selected period
    switch (selectedPeriod) {
      case 'Week':
        return allMilestones
            .where((m) =>
                (m["date"] as DateTime)
                    .difference(DateTime.now())
                    .inDays
                    .abs() <=
                7)
            .toList();
      case 'Month':
        return allMilestones
            .where((m) =>
                (m["date"] as DateTime)
                    .difference(DateTime.now())
                    .inDays
                    .abs() <=
                30)
            .toList();
      case '3 Months':
        return allMilestones
            .where((m) =>
                (m["date"] as DateTime)
                    .difference(DateTime.now())
                    .inDays
                    .abs() <=
                90)
            .toList();
      case 'Year':
        return allMilestones;
      default:
        return allMilestones.take(3).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final milestones = _getMilestones();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
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
                iconName: 'flag',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Health Milestones',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: milestones.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final milestone = milestones[index];
              final isAchieved = milestone["achieved"] as bool;

              return Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isAchieved
                      ? Theme.of(context).colorScheme.secondary
                          .withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isAchieved
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.outline
                            .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: isAchieved
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.outline
                                .withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: milestone["icon"] as String,
                          color: isAchieved
                              ? Theme.of(context).colorScheme.onSecondary
                              : Theme.of(context).colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                milestone["title"] as String,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isAchieved
                                      ? AppTheme
                                          .lightTheme.colorScheme.secondary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                ),
                              ),
                              if (isAchieved) ...[
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            milestone["description"] as String,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isAchieved ? 'Achieved' : 'Upcoming',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                            color: isAchieved
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          _formatDate(milestone["date"] as DateTime),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 0) {
      return 'In ${difference}d';
    } else {
      return '${difference.abs()}d ago';
    }
  }
}
