import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';

import '../../../core/app_export.dart';

class PointsLevelHeaderWidget extends StatelessWidget {
  final int totalPoints;
  final int currentLevel;
  final int pointsToNextLevel;
  final int pointsForNextLevel;

  const PointsLevelHeaderWidget({
    Key? key,
    required this.totalPoints,
    required this.currentLevel,
    required this.pointsToNextLevel,
    required this.pointsForNextLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progressPercentage = pointsForNextLevel > 0
        ? (pointsForNextLevel - pointsToNextLevel) / pointsForNextLevel
        : 0.0;

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Points and Level Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.totalPoints,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    totalPoints.toString(),
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: Colors.white,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${AppLocalizations.of(context)!.level} $currentLevel',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Progress to Next Level
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.progressToLevel} ${currentLevel + 1}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$pointsToNextLevel ${AppLocalizations.of(context)!.pointsToGo}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              // Progress Bar
              Container(
                height: 1.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressPercentage.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
