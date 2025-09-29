import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressHeaderWidget extends StatefulWidget {
  final double progressPercentage;
  final int achievedCount;
  final int totalCount;

  const ProgressHeaderWidget({
    Key? key,
    required this.progressPercentage,
    required this.achievedCount,
    required this.totalCount,
  }) : super(key: key);

  @override
  State<ProgressHeaderWidget> createState() => _ProgressHeaderWidgetState();
}

class _ProgressHeaderWidgetState extends State<ProgressHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progressPercentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(5.w),
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
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header text
          Row(
            children: [
              CustomIconWidget(
                iconName: 'favorite',
                color: Colors.white,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Health Recovery Progress',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // Progress stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Milestones Achieved',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${widget.achievedCount}/${widget.totalCount}',
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
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
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Text(
                      '${_progressAnimation.value.toInt()}%',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Progress bar
          Container(
            height: 1.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progressAnimation.value / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 1.h),
          // Motivational text
          Text(
            widget.progressPercentage >= 50
                ? 'Amazing progress! Your body is healing beautifully.'
                : 'Every milestone brings you closer to complete recovery.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
