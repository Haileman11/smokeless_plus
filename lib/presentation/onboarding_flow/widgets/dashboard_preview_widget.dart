import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DashboardPreviewWidget extends StatelessWidget {
  final DateTime quitDate;
  final int cigarettesPerDay;
  final double costPerPack;

  const DashboardPreviewWidget({
    super.key,
    required this.quitDate,
    required this.cigarettesPerDay,
    required this.costPerPack,
  });

  @override
  Widget build(BuildContext context) {
    final daysSinceQuit = DateTime.now().difference(quitDate).inDays;
    final cigarettesAvoided = daysSinceQuit * cigarettesPerDay;
    final moneySaved = (cigarettesAvoided / 20) * costPerPack;
    final healthProgress = (daysSinceQuit / 365 * 100).clamp(0, 100);

    return Column(
      children: [
        // Preview header
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                'Your Personalized Dashboard',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Based on your quit date and smoking habits',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        // Stats preview
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Days Smoke-Free',
                value: daysSinceQuit.toString(),
                icon: 'calendar_today',
                color: Theme.of(context).colorScheme.primary,
                context: context
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildStatCard(
                title: 'Money Saved',
                value: '\$${moneySaved.toStringAsFixed(0)}',
                icon: 'savings',
                color: Theme.of(context).colorScheme.secondary,
                context: context
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Cigarettes Avoided',
                value: cigarettesAvoided.toString(),
                icon: 'block',
                color: Theme.of(context).colorScheme.tertiary,
                context: context
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildStatCard(
                title: 'Health Progress',
                value: '${healthProgress.toInt()}%',
                icon: 'favorite',
                color: Theme.of(context).colorScheme.secondary,
                context: context
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        // Health milestone preview
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'health_and_safety',
                      color: Theme.of(context).colorScheme.secondary,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next Health Milestone',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          daysSinceQuit < 1
                              ? 'Blood oxygen levels normalize'
                              : daysSinceQuit < 7
                                  ? 'Taste and smell improve'
                                  : daysSinceQuit < 30
                                      ? 'Lung function increases'
                                      : 'Heart disease risk reduces',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              LinearProgressIndicator(
                value: healthProgress / 100,
                backgroundColor: Theme.of(context).colorScheme.secondary
                    .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        // Achievement preview
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.tertiary,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'emoji_events',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      daysSinceQuit >= 1
                          ? 'Achievement Unlocked!'
                          : 'First Achievement Awaits',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      daysSinceQuit >= 1
                          ? 'First Day Champion - You\'ve completed your first smoke-free day!'
                          : 'Complete your first smoke-free day to earn your first badge',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 5.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
