import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgeWidget extends StatefulWidget {
  final Map<String, dynamic> achievement;
  final VoidCallback? onTap;

  const AchievementBadgeWidget({
    Key? key,
    required this.achievement,
    this.onTap,
  }) : super(key: key);

  @override
  State<AchievementBadgeWidget> createState() => _AchievementBadgeWidgetState();
}

class _AchievementBadgeWidgetState extends State<AchievementBadgeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.achievement['isUnlocked'] == true &&
        widget.achievement['isNew'] == true) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = widget.achievement['isUnlocked'] ?? false;
    final bool isNew = widget.achievement['isNew'] ?? false;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: isNew ? _scaleAnimation.value : 1.0,
            child: Opacity(
              opacity: isNew ? _opacityAnimation.value : 1.0,
              child: Container(
                margin: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.surface
                          .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isUnlocked
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isUnlocked ? 2 : 1,
                  ),
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary
                                .withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Badge Icon/Illustration
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: isUnlocked
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName:
                                  widget.achievement['icon'] ?? 'emoji_events',
                              color: isUnlocked
                                  ? Colors.white
                                  : Colors.grey.withValues(alpha: 0.5),
                              size: 6.w,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          // Badge Title
                          Text(
                            widget.achievement['title'] ?? 'Achievement',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                              color: isUnlocked
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          // Points
                          if (isUnlocked) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '+${widget.achievement['points'] ?? 0} pts',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ] else ...[
                            Text(
                              'Locked',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.grey.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // NEW Badge Indicator
                    if (isNew && isUnlocked)
                      Positioned(
                        top: 1.w,
                        right: 1.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.5.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'NEW',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
