import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/user_data_service.dart';

class EnhancedMilestoneTimelineWidget extends StatefulWidget {
  final String selectedCategory;
  final String selectedPeriod;
  final VoidCallback? onShareAchievement;

  const EnhancedMilestoneTimelineWidget({
    Key? key,
    required this.selectedCategory,
    required this.selectedPeriod,
    this.onShareAchievement,
  }) : super(key: key);

  @override
  State<EnhancedMilestoneTimelineWidget> createState() =>
      _EnhancedMilestoneTimelineWidgetState();
}

class _EnhancedMilestoneTimelineWidgetState
    extends State<EnhancedMilestoneTimelineWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressAnimationController;
  late AnimationController _pulseAnimationController;
  List<Map<String, dynamic>> _milestones = [];
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimationController.repeat(reverse: true);
    _loadUserData();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await UserDataService.loadUserData();
      if (userData != null) {
        final quitDate = DateTime.parse(userData['quitDate']);
        final milestones = UserDataService.getDetailedHealthMilestones(
          quitDate: quitDate,
          hasStartedQuitting: userData['hasStartedQuitting'],
        );

        setState(() {
          _userData = userData;
          _milestones = _filterMilestonesByCategory(milestones);
          _isLoading = false;
        });

        _progressAnimationController.forward();
      } else {
        setState(() {
          _isLoading = false;
          _milestones = [];
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _milestones = [];
      });
    }
  }

  List<Map<String, dynamic>> _filterMilestonesByCategory(
    List<Map<String, dynamic>> milestones,
  ) {
    switch (widget.selectedCategory) {
      case 'Short-Term':
        return milestones.where((m) => m['category'] == 'Short-Term').toList();
      case 'Medium-Term':
        return milestones.where((m) => m['category'] == 'Medium-Term').toList();
      case 'Long-Term':
        return milestones.where((m) => m['category'] == 'Long-Term').toList();
      default:
        return milestones;
    }
  }

  void _shareMilestone(Map<String, dynamic> milestone) {
    HapticFeedback.lightImpact();

    final shareText = """
🎉 Milestone Achieved! 🎉

${milestone['title']} - ${milestone['timeframe']}
${milestone['description']}

Scientific Fact: ${milestone['scientificBasis']}

#QuitSmoking #HealthJourney #MilestoneAchieved
""";

    // In a real app, this would use the share package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Achievement copied to share!'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'View',
          textColor: Theme.of(context).colorScheme.onSecondary,
          onPressed: () {
            _showMilestoneDetail(milestone);
          },
        ),
      ),
    );

    if (widget.onShareAchievement != null) {
      widget.onShareAchievement!();
    }
  }

  void _showMilestoneDetail(Map<String, dynamic> milestone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: 70.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 10.w,
                  height: 0.5.h,
                  margin: EdgeInsets.only(top: 2.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 15.w,
                              height: 15.w,
                              decoration: BoxDecoration(
                                color:
                                    milestone['isAchieved']
                                        ? AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .secondary
                                        : Theme.of(context).primaryColor
                                            .withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: milestone['icon'],
                                  color:
                                      milestone['isAchieved']
                                          ? AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .onSecondary
                                          : Theme.of(context).primaryColor,
                                  size: 28,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    milestone['timeframe'],
                                    style: AppTheme
                                        .lightTheme
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Theme.of(context).primaryColor,
                                        ),
                                  ),
                                  Text(
                                    milestone['title'],
                                    style: AppTheme
                                        .lightTheme
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        _buildProgressSection(milestone),
                        SizedBox(height: 3.h),
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          milestone['description'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Scientific Basis',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).primaryColor
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'science',
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  milestone['scientificBasis'],
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (milestone['isAchieved']) ...[
                          SizedBox(height: 3.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _shareMilestone(milestone);
                              },
                              icon: CustomIconWidget(
                                iconName: 'share',
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                size: 20,
                              ),
                              label: Text('Share Achievement'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildProgressSection(Map<String, dynamic> milestone) {
    final progress = milestone['progress'] as double;
    final countdownText = milestone['countdownText'] as String;
    final isAchieved = milestone['isAchieved'] as bool;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color:
                      isAchieved
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          AnimatedBuilder(
            animation: _progressAnimationController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: progress * _progressAnimationController.value,
                backgroundColor: Theme.of(context).colorScheme.outline
                    .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isAchieved
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).primaryColor,
                ),
                minHeight: 1.h,
              );
            },
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: isAchieved ? 'check_circle' : 'schedule',
                color:
                    isAchieved
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                countdownText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      isAchieved
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onSurface
                              .withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(Map<String, dynamic> milestone, int index) {
    final isAchieved = milestone['isAchieved'] as bool;
    final progress = milestone['progress'] as double;

    return AnimatedBuilder(
      animation: _pulseAnimationController,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isAchieved
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.outline.withValues(
                        alpha: 0.2,
                      ),
              width: isAchieved ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isAchieved
                        ? Theme.of(context).colorScheme.secondary.withValues(
                          alpha: 0.2,
                        )
                        : Theme.of(context).colorScheme.shadow.withValues(
                          alpha: 0.1,
                        ),
                blurRadius: isAchieved ? 12 : 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showMilestoneDetail(milestone),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 15.w,
                              height: 15.w,
                              decoration: BoxDecoration(
                                color:
                                    isAchieved
                                        ? AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .secondary
                                        : Theme.of(context).primaryColor
                                            .withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: milestone['icon'],
                                  color:
                                      isAchieved
                                          ? AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .onSecondary
                                          : Theme.of(context).primaryColor,
                                  size: 24,
                                ),
                              ),
                            ),
                            if (isAchieved)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 4.w,
                                  height: 4.w,
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .secondary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .surface,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: 'check',
                                      color:
                                          AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .onSecondary,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                milestone['timeframe'],
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                milestone['title'],
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        if (isAchieved)
                          GestureDetector(
                            onTap: () => _shareMilestone(milestone),
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'share',
                                color:
                                    Theme.of(context).colorScheme.secondary,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      milestone['description'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(alpha: 0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    // Progress Bar
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isAchieved
                                            ? AppTheme
                                                .lightTheme
                                                .colorScheme
                                                .secondary
                                            : Theme.of(context).primaryColor,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        AnimatedBuilder(
                          animation: _progressAnimationController,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value:
                                  progress * _progressAnimationController.value,
                              backgroundColor: AppTheme
                                  .lightTheme
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isAchieved
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).primaryColor,
                              ),
                              minHeight: 0.8.h,
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 1.5.h),
                    // Timer/Status
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: (isAchieved
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).primaryColor)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: isAchieved ? 'check_circle' : 'schedule',
                            color:
                                isAchieved
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).primaryColor,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            milestone['countdownText'],
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color:
                                      isAchieved
                                          ? AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .secondary
                                          : Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    if (_milestones.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(
              alpha: 0.2,
            ),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'info',
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: 0.6,
              ),
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Complete Setup First',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Set your quit date to track health milestones',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: 0.6,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'timeline',
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Health Milestones Timeline',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Track your scientifically-based recovery progress',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Milestones List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _milestones.length,
            itemBuilder: (context, index) {
              return _buildMilestoneCard(_milestones[index], index);
            },
          ),
        ],
      ),
    );
  }
}
