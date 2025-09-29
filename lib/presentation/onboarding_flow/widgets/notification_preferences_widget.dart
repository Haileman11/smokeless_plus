import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  final bool dailyMotivation;
  final bool milestoneAlerts;
  final bool cravingSupport;
  final TimeOfDay motivationTime;
  final Function(bool) onDailyMotivationChanged;
  final Function(bool) onMilestoneAlertsChanged;
  final Function(bool) onCravingSupportChanged;
  final Function(TimeOfDay) onMotivationTimeChanged;

  const NotificationPreferencesWidget({
    super.key,
    required this.dailyMotivation,
    required this.milestoneAlerts,
    required this.cravingSupport,
    required this.motivationTime,
    required this.onDailyMotivationChanged,
    required this.onMilestoneAlertsChanged,
    required this.onCravingSupportChanged,
    required this.onMotivationTimeChanged,
  });

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.motivationTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != widget.motivationTime) {
      widget.onMotivationTimeChanged(picked);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  Widget _buildNotificationOption({
    required String title,
    required String description,
    required String iconName,
    required Color iconColor,
    required bool value,
    required Function(bool) onChanged,
    Widget? additionalContent,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          width: value ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: iconColor,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          if (additionalContent != null) ...[
            SizedBox(height: 2.h),
            additionalContent,
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNotificationOption(
          title: 'Daily Motivation',
          description: 'Receive daily encouraging messages and tips',
          iconName: 'favorite',
          iconColor: Theme.of(context).colorScheme.secondary,
          value: widget.dailyMotivation,
          onChanged: widget.onDailyMotivationChanged,
          additionalContent: widget.dailyMotivation
              ? Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: Theme.of(context).colorScheme.secondary,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          'Notification Time: ${_formatTime(widget.motivationTime)}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _selectTime,
                        child: Text(
                          'Change',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        ),
        _buildNotificationOption(
          title: 'Milestone Alerts',
          description: 'Get notified when you reach important milestones',
          iconName: 'emoji_events',
          iconColor: Theme.of(context).colorScheme.tertiary,
          value: widget.milestoneAlerts,
          onChanged: widget.onMilestoneAlertsChanged,
        ),
        _buildNotificationOption(
          title: 'Craving Support',
          description: 'Instant help and motivation during difficult moments',
          iconName: 'support_agent',
          iconColor: Theme.of(context).colorScheme.primary,
          value: widget.cravingSupport,
          onChanged: widget.onCravingSupportChanged,
        ),
      ],
    );
  }
}
