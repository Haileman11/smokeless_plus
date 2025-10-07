import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? avatarUrl;
  final DateTime quitDate;
  final int currentStreak;

  const ProfileHeaderWidget({
    Key? key,
    required this.userName,
    required this.userEmail,
    this.avatarUrl,
    required this.quitDate,
    required this.currentStreak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysSinceQuit = DateTime.now().difference(quitDate).inDays;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: avatarUrl == null
                      ? CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey.shade600,
                          ),
                        )
                      : CustomImageWidget(
                          imageUrl: avatarUrl,
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      userEmail,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                    'Quit Date',
                    '${quitDate.day}/${quitDate.month}/${quitDate.year}',
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    context),
                Container(
                  height: 6.h,
                  width: 1,
                  color: Theme.of(context).dividerColor,
                ),
                _buildStatItem(
                    'Current Streak',
                    '$currentStreak days',
                    CustomIconWidget(
                      iconName: 'local_fire_department',
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 20,
                    ),
                    context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, Widget icon, BuildContext context) {
    return Column(
      children: [
        icon,
        SizedBox(height: 1.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
