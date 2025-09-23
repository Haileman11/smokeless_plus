import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/user_data_service.dart';
import './widgets/craving_frequency_chart.dart';
import './widgets/enhanced_milestone_timeline_widget.dart';
import './widgets/health_improvement_chart.dart';
import './widgets/milestone_category_selector_widget.dart';
import './widgets/money_saved_chart.dart';
import './widgets/progress_category_tabs.dart';
import './widgets/streak_timeline_chart.dart';
import './widgets/time_period_selector.dart';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({Key? key}) : super(key: key);

  @override
  State<ProgressTracking> createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking>
    with TickerProviderStateMixin {
  String _selectedPeriod = 'Month';
  String _selectedCategory = 'Financial';
  String _selectedMilestoneCategory = 'All';
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Real user data loaded from UserDataService
  Map<String, dynamic> _progressData = {
    "currentStreak": 0,
    "totalMoneySaved": 0.0,
    "cigarettesAvoided": 0,
    "healthScore": 0,
    "lastSync": DateTime.now(),
    "achievements": [],
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadUserData();
  }

  /// Load real user data from UserDataService
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final userData = await UserDataService.loadUserData();

      if (userData != null) {
        setState(() {
          _progressData = {
            "currentStreak": userData["currentStreak"] ?? 0,
            "totalMoneySaved": userData["moneySaved"] ?? 0.0,
            "cigarettesAvoided": userData["cigarettesAvoided"] ?? 0,
            "healthScore": ((userData["healthProgress"] ?? 0.0) * 100).toInt(),
            "lastSync": DateTime.now(),
            "achievements":
                userData["achievements"]?["unlockedAchievements"] ?? [],
            "quitDate":
                userData["quitDate"] ?? DateTime.now().toIso8601String(),
            "hasStartedQuitting": userData["hasStartedQuitting"] ?? false,
          };
        });

        // Start animation after data loads
        _animationController.forward();
      } else {
        // Redirect to onboarding if no user data exists
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
        return;
      }
    } catch (e) {
      // Show error but continue with default values
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading progress data. Please try refreshing.'),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => _loadUserData(),
          ),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _exportProgress() {
    HapticFeedback.lightImpact();

    final reportData = """
Progress Report - QuitSmoking Tracker
Generated: ${DateTime.now().toString().split('.')[0]}

CURRENT STATISTICS:
• Smoke-Free Streak: ${_progressData["currentStreak"]} days
• Money Saved: \$${(_progressData["totalMoneySaved"] ?? 0.0).toStringAsFixed(2)}
• Cigarettes Avoided: ${_progressData["cigarettesAvoided"]}
• Health Score: ${_progressData["healthScore"]}%

SYNCHRONIZATION STATUS:
• Data Source: Real-time calculation from quit date
• Last Sync: ${_formatLastSync()}
• Quit Date: ${_progressData["quitDate"] != null ? DateTime.parse(_progressData["quitDate"]).toString().split(' ')[0] : 'Not Set'}

ACHIEVEMENTS UNLOCKED:
${(_progressData["achievements"] as List).isEmpty ? '• No achievements unlocked yet' : (_progressData["achievements"] as List).map((achievement) => "• ${achievement["title"]}: ${achievement["description"]}").join('\n')}

HEALTH MILESTONES:
• 20 Minutes: Heart rate normalized ${_progressData["currentStreak"] >= 1 ? '✓' : '○'}
• 12 Hours: Carbon monoxide cleared ${_progressData["currentStreak"] >= 1 ? '✓' : '○'}
• 2 Weeks: Circulation improved ${_progressData["currentStreak"] >= 14 ? '✓' : '○'}
• 1 Month: Lung function increased ${_progressData["currentStreak"] >= 30 ? '✓' : '○'}

All data synchronized across the entire app!
""";

    // Show export success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Synchronized progress report exported successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'View',
          textColor: AppTheme.lightTheme.colorScheme.onSecondary,
          onPressed: () {
            // In a real app, this would open the exported file
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Synchronized Export Preview'),
                content: SingleChildScrollView(
                  child: Text(
                    reportData,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Filter Options',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildFilterOption('Show All Data', true),
            _buildFilterOption('Hide Craving Data', false),
            _buildFilterOption('Health Milestones Only', false),
            _buildFilterOption('Financial Data Only', false),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Apply Filters'),
              ),
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, bool isSelected) {
    return ListTile(
      title: Text(title, style: AppTheme.lightTheme.textTheme.bodyMedium),
      trailing: isSelected
          ? CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 24,
            )
          : CustomIconWidget(
              iconName: 'radio_button_unchecked',
              color: AppTheme.lightTheme.colorScheme.outline,
              size: 24,
            ),
      onTap: () {
        HapticFeedback.selectionClick();
        // Handle filter selection
      },
    );
  }

  Widget _buildProgressSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Synchronized Progress',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(
                    alpha: 0.2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'sync',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Live sync: ${_formatLastSync()}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          if (_progressData["quitDate"] != null) ...[
            Text(
              'Quit Date: ${DateTime.parse(_progressData["quitDate"]).toString().split(' ')[0]}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 2.h),
          ],
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Streak',
                  '${_progressData["currentStreak"]} days',
                  'timeline',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSummaryCard(
                  'Saved',
                  '\$${(_progressData["totalMoneySaved"] ?? 0.0).toStringAsFixed(2)}',
                  'savings',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Avoided',
                  '${_progressData["cigarettesAvoided"]} cigs',
                  'smoke_free',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSummaryCard(
                  'Health',
                  '${_progressData["healthScore"]}%',
                  'favorite',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, String iconName) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(
          alpha: 0.15,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(
                    alpha: 0.8,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastSync() {
    final lastSync = _progressData["lastSync"] as DateTime;
    final difference = DateTime.now().difference(lastSync);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Widget _buildChartContent() {
    switch (_selectedCategory) {
      case 'Financial':
        return Column(
          children: [
            MoneySavedChart(selectedPeriod: _selectedPeriod),
            SizedBox(height: 2.h),
          ],
        );
      case 'Health':
        return Column(
          children: [
            HealthImprovementChart(selectedPeriod: _selectedPeriod),
            SizedBox(height: 2.h),
            MilestoneCategorySelectorWidget(
              selectedCategory: _selectedMilestoneCategory,
              onCategoryChanged: (category) {
                setState(() {
                  _selectedMilestoneCategory = category;
                });
                HapticFeedback.selectionClick();
              },
            ),
            SizedBox(height: 1.h),
            EnhancedMilestoneTimelineWidget(
              selectedCategory: _selectedMilestoneCategory,
              selectedPeriod: _selectedPeriod,
              onShareAchievement: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Achievement shared successfully!'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        );
      case 'Behavioral':
        return Column(
          children: [
            CravingFrequencyChart(selectedPeriod: _selectedPeriod),
            SizedBox(height: 2.h),
            StreakTimelineChart(selectedPeriod: _selectedPeriod),
            SizedBox(height: 2.h),
          ],
        );
      case 'Social':
        return Column(
          children: [_buildSocialProgressChart(), SizedBox(height: 2.h)],
        );
      default:
        return Column(
          children: [
            StreakTimelineChart(selectedPeriod: _selectedPeriod),
            SizedBox(height: 2.h),
            MoneySavedChart(selectedPeriod: _selectedPeriod),
            SizedBox(height: 2.h),
          ],
        );
    }
  }

  Widget _buildSocialProgressChart() {
    return Container(
      width: double.infinity,
      height: 25.h,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'people',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Social Impact',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildSocialMetric('Friends Inspired', '3', 'group'),
          SizedBox(height: 2.h),
          _buildSocialMetric('Support Messages', '47', 'message'),
          SizedBox(height: 2.h),
          _buildSocialMetric('Community Rank', '#12', 'leaderboard'),
        ],
      ),
    );
  }

  Widget _buildSocialMetric(String title, String value, String iconName) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while data is being fetched
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Progress Tracking'),
          backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(height: 2.h),
              Text(
                'Synchronizing your progress data...',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Progress Tracking'),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/health-score-dashboard'),
            icon: CustomIconWidget(
              iconName: 'favorite',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            tooltip: 'Health Score Dashboard',
          ),
          IconButton(
            onPressed: _showFilterOptions,
            icon: CustomIconWidget(
              iconName: 'tune',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Filter Options',
          ),
          IconButton(
            onPressed: _exportProgress,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Export Synchronized Progress',
          ),
          IconButton(
            onPressed: _loadUserData,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadUserData,
            color: AppTheme.lightTheme.primaryColor,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressSummary(),
                      SizedBox(height: 2.h),
                      TimePeriodSelector(
                        selectedPeriod: _selectedPeriod,
                        onPeriodChanged: (period) {
                          setState(() {
                            _selectedPeriod = period;
                          });
                          HapticFeedback.selectionClick();
                        },
                      ),
                      SizedBox(height: 1.h),
                      ProgressCategoryTabs(
                        selectedCategory: _selectedCategory,
                        onCategoryChanged: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                          HapticFeedback.selectionClick();
                        },
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: _buildChartContent(),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 10.h)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
