import 'package:flutter/material.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/user_data_service.dart';
import './widgets/comparison_chart_widget.dart';
import './widgets/health_category_breakdown_widget.dart';
import './widgets/health_score_progress_widget.dart';
import './widgets/medical_insights_widget.dart';
import './widgets/recovery_timeline_widget.dart';

class HealthScoreDashboard extends StatefulWidget {
  const HealthScoreDashboard({Key? key}) : super(key: key);

  @override
  State<HealthScoreDashboard> createState() => _HealthScoreDashboardState();
}

class _HealthScoreDashboardState extends State<HealthScoreDashboard>
    with TickerProviderStateMixin {
  int _currentTabIndex = 2; // Health Score tab
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final userData = await UserDataService.loadUserData();
      if (userData != null) {
        setState(() => _userData = userData);
      }
    } catch (e) {
      // Handle error silently
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUserData,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(l10n),
              _buildHealthScoreProgress(l10n),
              _buildHealthCategoryBreakdown(l10n),
              _buildRecoveryTimeline(l10n),
              _buildMedicalInsights(l10n),
              _buildComparisonChart(l10n),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(l10n),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.primaryColor,
          size: 6.w,
        ),
      ),
      title: Text(
        'Health Score Dashboard',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppTheme.lightTheme.primaryColor,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _exportHealthReport,
          icon: CustomIconWidget(
            iconName: 'share',
            color: AppTheme.lightTheme.primaryColor,
            size: 6.w,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildHealthScoreProgress(AppLocalizations l10n) {
    final healthProgress = _userData["healthProgress"] ?? 0.0;
    final healthScore = (healthProgress * 100).toInt();

    return SliverToBoxAdapter(
      child: HealthScoreProgressWidget(
        healthScore: healthScore,
        quitDate: _userData["quitDate"] != null
            ? DateTime.parse(_userData["quitDate"])
            : DateTime.now(),
        currentStreak: _userData["currentStreak"] ?? 0,
      ),
    );
  }

  Widget _buildHealthCategoryBreakdown(AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: HealthCategoryBreakdownWidget(
        quitDate: _userData["quitDate"] != null
            ? DateTime.parse(_userData["quitDate"])
            : DateTime.now(),
      ),
    );
  }

  Widget _buildRecoveryTimeline(AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: RecoveryTimelineWidget(
        quitDate: _userData["quitDate"] != null
            ? DateTime.parse(_userData["quitDate"])
            : DateTime.now(),
        healthProgress: _userData["healthProgress"] ?? 0.0,
      ),
    );
  }

  Widget _buildMedicalInsights(AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: MedicalInsightsWidget(
        currentStreak: _userData["currentStreak"] ?? 0,
        yearsSmoking: _userData["yearsSmoking"] ?? 0.0,
      ),
    );
  }

  Widget _buildComparisonChart(AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: ComparisonChartWidget(
        userProgress: _userData["healthProgress"] ?? 0.0,
        quitDays: _userData["currentStreak"] ?? 0,
      ),
    );
  }

  Widget _buildBottomNavigation(AppLocalizations l10n) {
    final List<Map<String, dynamic>> navItems = [
      {
        "icon": "home",
        "label": l10n.navigationHome,
        "route": "/dashboard-home",
      },
      {
        "icon": "trending_up",
        "label": l10n.navigationProgress,
        "route": "/progress-tracking",
      },
      {
        "icon": "favorite",
        "label": "Health Score",
        "route": "/health-score-dashboard",
      },
      {
        "icon": "emoji_events",
        "label": l10n.navigationAchievements,
        "route": "/achievement-system",
      },
      {
        "icon": "person",
        "label": l10n.navigationProfile,
        "route": "/user-profile",
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = index == _currentTabIndex;

              return GestureDetector(
                onTap: () {
                  setState(() => _currentTabIndex = index);
                  if (item["route"] != "/health-score-dashboard") {
                    Navigator.pushReplacementNamed(context, item["route"]);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.5.w,
                    vertical: 1.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: item["icon"],
                        color: isActive
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.textMediumEmphasisLight,
                        size: 5.5.w,
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        item["label"],
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: isActive
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.textMediumEmphasisLight,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _exportHealthReport() {
    // Show share sheet functionality for health reports
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Health report export feature coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }
}
