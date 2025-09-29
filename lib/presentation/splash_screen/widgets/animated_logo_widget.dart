import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnimatedLogoWidget extends StatefulWidget {
  const AnimatedLogoWidget({Key? key}) : super(key: key);

  @override
  State<AnimatedLogoWidget> createState() => _AnimatedLogoWidgetState();
}

class _AnimatedLogoWidgetState extends State<AnimatedLogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.3),
                    blurRadius: 20.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'smoke_free',
                    color: Theme.of(context).colorScheme.primary,
                    size: 8.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'QuitSmoking',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    'Tracker',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
