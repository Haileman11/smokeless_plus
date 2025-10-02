import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';

import '../../../core/app_export.dart';

/// An animated counter widget that shows time elapsed since quit date
/// Displays days, hours, and minutes with real-time updates
class AnimatedTimeCounterWidget extends StatefulWidget {
  final DateTime quitDate;
  final String title;
  final Color? primaryColor;
  final Color? accentColor;

  const AnimatedTimeCounterWidget({
    Key? key,
    required this.quitDate,
    this.title = 'Time Smoke-Free',
    this.primaryColor,
    this.accentColor,
  }) : super(key: key);

  @override
  State<AnimatedTimeCounterWidget> createState() =>
      _AnimatedTimeCounterWidgetState();
}

class _AnimatedTimeCounterWidgetState extends State<AnimatedTimeCounterWidget>
    with TickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  int _days = 0;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  bool _hasStartedQuitting = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create animations
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _pulseController.repeat(reverse: true);
    _scaleController.forward();

    // Calculate initial time and start timer
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final difference = now.difference(widget.quitDate);
    final hasStarted = now.isAfter(widget.quitDate);

    if (mounted) {
      setState(() {
        _hasStartedQuitting = hasStarted;
        if (hasStarted) {
          _days = difference.inDays;
          _hours = difference.inHours % 24;
          _minutes = difference.inMinutes % 60;
          _seconds = difference.inSeconds % 60;
        } else {
          // Show countdown to quit date
          final untilQuit = widget.quitDate.difference(now);
          _days = untilQuit.inDays;
          _hours = untilQuit.inHours % 24;
          _minutes = untilQuit.inMinutes % 60;
          _seconds = untilQuit.inSeconds % 60;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.primaryColor ?? Theme.of(context).colorScheme.primary;
    final accentColor = widget.accentColor ?? AppTheme.accentLight;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _hasStartedQuitting ? primaryColor : Colors.orange,
              (_hasStartedQuitting ? primaryColor : Colors.orange)
                  .withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (_hasStartedQuitting ? primaryColor : Colors.orange)
                  .withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Title with pulse animation
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName:
                            _hasStartedQuitting ? 'access_time' : 'schedule',
                        color: AppTheme.onPrimaryLight,
                        size: 8.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        _hasStartedQuitting
                            ? widget.title
                            : 'Time Until Quit Date',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.onPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),

            // Time counters row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeUnit(AppLocalizations.of(context)!.days, _days, primaryColor),
                _buildSeparator(),
                _buildTimeUnit(AppLocalizations.of(context)!.hours, _hours, accentColor),
                _buildSeparator(),
                _buildTimeUnit(AppLocalizations.of(context)!.minutes, _minutes, AppTheme.successLight),
              ],
            ),

            SizedBox(height: 2.h),

            // Subtitle with live seconds and motivational message
            Text(
              _hasStartedQuitting
                  ? AppLocalizations.of(context)!.everySecondCounts(_seconds)
                  : AppLocalizations.of(context)!.getReady(_seconds),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.onPrimaryLight.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(String label, int value, Color color) {
    return Column(
      children: [
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: value),
          duration: const Duration(milliseconds: 800),
          builder: (context, animatedValue, child) {
            return Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: AppTheme.onPrimaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  animatedValue.toString().padLeft(2, '0'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.onPrimaryLight,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.onPrimaryLight.withValues(alpha: 0.9),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Column(
      children: [
        SizedBox(height: 8.w),
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Opacity(
              opacity: _pulseAnimation.value - 0.3,
              child: Text(
                ':',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.onPrimaryLight,
                  fontWeight: FontWeight.w800,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
