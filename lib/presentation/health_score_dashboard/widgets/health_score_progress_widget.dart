import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthScoreProgressWidget extends StatefulWidget {
  final int healthScore;
  final DateTime quitDate;
  final int currentStreak;

  const HealthScoreProgressWidget({
    Key? key,
    required this.healthScore,
    required this.quitDate,
    required this.currentStreak,
  }) : super(key: key);

  @override
  State<HealthScoreProgressWidget> createState() =>
      _HealthScoreProgressWidgetState();
}

class _HealthScoreProgressWidgetState extends State<HealthScoreProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.healthScore / 100.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getScoreColor().withAlpha(26),
            _getScoreColor().withAlpha(13),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getScoreColor().withAlpha(51),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overall Health Score',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getScoreColor().withAlpha(26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getScoreStatus(),
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: _getScoreColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Circular progress indicator
            SizedBox(
              height: 40.w,
              width: 40.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 40.w,
                    width: 40.w,
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return CircularProgressIndicator(
                          
                          value: _progressAnimation.value,
                          strokeWidth: 20,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getScoreColor(),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.healthScore}%',
                        style: AppTheme.lightTheme.textTheme.headlineLarge
                            ?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: _getScoreColor(),
                        ),
                      ),
                      Text(
                        'Health Score',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Days Quit',
                  '${widget.currentStreak}',
                  'calendar_today',
                ),
                Container(
                  height: 4.h,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                _buildStatItem(
                  'Quit Duration',
                  _getQuitDuration(),
                  'schedule',
                ),
                Container(
                  height: 4.h,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                _buildStatItem(
                  'Recovery',
                  '${widget.healthScore}%',
                  'trending_up',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String icon) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.primaryColor,
          size: 6.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
      ],
    );
  }

  Color _getScoreColor() {
    if (widget.healthScore >= 80) return AppTheme.successLight;
    if (widget.healthScore >= 60) return Color(0xFFFFB300);
    if (widget.healthScore >= 40) return Color(0xFFFF8F00);
    return Color(0xFFE74C3C);
  }

  String _getScoreStatus() {
    if (widget.healthScore >= 80) return 'Excellent';
    if (widget.healthScore >= 60) return 'Good';
    if (widget.healthScore >= 40) return 'Improving';
    return 'Recovery';
  }

  String _getQuitDuration() {
    final duration = DateTime.now().difference(widget.quitDate);
    if (duration.inDays > 365) {
      final years = duration.inDays ~/ 365;
      final months = (duration.inDays % 365) ~/ 30;
      return '${years}y ${months}m';
    } else if (duration.inDays > 30) {
      final months = duration.inDays ~/ 30;
      final days = duration.inDays % 30;
      return '${months}m ${days}d';
    } else {
      return '${duration.inDays}d';
    }
  }
}
