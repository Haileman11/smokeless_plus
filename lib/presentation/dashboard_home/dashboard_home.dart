import 'package:flutter/material.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/language_service.dart';
import '../../services/user_data_service.dart';
import './widgets/animated_time_counter_widget.dart';
import './widgets/craving_support_sheet.dart';
import './widgets/daily_motivation_widget.dart';
import './widgets/health_timeline_widget.dart';
import './widgets/metric_card_widget.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  String _currentLanguage = 'en';
  int _currentTabIndex = 0;

  // User data - now loaded dynamically
  Map<String, dynamic> _userData = {
    "name": "User",
    "currentStreak": 0,
    "moneySaved": 0.0,
    "cigarettesAvoided": 0,
    "healthStage": "Starting Recovery",
    "healthProgress": 0.0,
    "nextMilestone": "Circulation Improving",
    "timeToNext": "Soon",
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
    _loadUserData();
  }

  Future<void> _loadCurrentLanguage() async {
    final language = await LanguageService.loadLanguage();
    if (mounted) {
      setState(() {
        _currentLanguage = language;
      });
    }
  }

  /// Load user data and calculate metrics from scratch
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final userData = await UserDataService.loadUserData();

      if (userData != null) {
        setState(() {
          _userData = userData;
        });
      } else {
        // If no user data, redirect to onboarding
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
        return;
      }
    } catch (e) {
      // Show error message but continue with default values
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorLoadingData),
          backgroundColor: Colors.orange,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.appTitle,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/user-profile'),
            icon: CustomIconWidget(
              iconName: 'account_circle',
              color: AppTheme.lightTheme.primaryColor,
              size: 7.w,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Greeting Header
              _buildGreetingHeader(l10n),

              SizedBox(height: 2.h),

              // Animated Time Counter
              AnimatedTimeCounterWidget(
                quitDate: DateTime.parse(_userData['quitDate'] as String),
                title: l10n.timeSmokeFree,
                primaryColor: AppTheme.lightTheme.primaryColor,
                accentColor: AppTheme.lightTheme.colorScheme.secondary,
              ),

              SizedBox(height: 3.h),

              // Simple Progress Metrics
              _buildSimpleMetrics(l10n),

              SizedBox(height: 3.h),

              // Health Timeline
              HealthTimelineWidget(
                currentStage: _userData["healthStage"] ?? "Starting Recovery",
                progress: _userData["healthProgress"] ?? 0.0,
                nextMilestone:
                    _userData["nextMilestone"] ?? "Circulation Improving",
                timeToNext: _userData["timeToNext"] ?? "Soon",
              ),

              SizedBox(height: 2.h),

              // Daily Motivation Widget (positioned below health timeline)
              DailyMotivationWidget(),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildCravingSupportFAB(),
      bottomNavigationBar: _buildBottomNavigation(l10n),
    );
  }

  Widget _buildGreetingHeader(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? l10n.goodMorning
        : hour < 17
            ? l10n.goodAfternoon
            : l10n.goodEvening;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, ${_userData["name"]}!',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            l10n.smokeFreeJourney,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleMetrics(AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // First Row - Money & Cigarettes
          Row(
            children: [
              Expanded(
                child: MetricCardWidget(
                  title: l10n.moneySaved,
                  value:
                      '\$${(_userData['moneySaved'] as double).toStringAsFixed(0)}',
                  subtitle: l10n.keepItUp,
                  iconName: 'savings',
                  iconColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: MetricCardWidget(
                  title: l10n.cigarettesAvoided,
                  value: '${_userData['cigarettesAvoided']}',
                  subtitle: l10n.basedOnProgress,
                  iconName: 'smoke_free',
                  iconColor: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Second Row - Health & Achievements (Now Clickable)
          Row(
            children: [
              Expanded(
                child: MetricCardWidget(
                  title: l10n.healthScore,
                  value:
                      '${((_userData['healthProgress'] as double) * 100).round()}%',
                  subtitle: l10n.improvingDaily,
                  iconName: 'favorite',
                  iconColor: AppTheme.lightTheme.colorScheme.primary,
                  onTap: () {
                    // Navigate to Health Score Dashboard to show health data and notifications
                    Navigator.pushNamed(context, '/health-score-dashboard');
                  },
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: MetricCardWidget(
                  title: l10n.achievements,
                  value: '${_calculateAchievementCount()}',
                  subtitle: 'Unlocked',
                  iconName: 'emoji_events',
                  iconColor: const Color(0xFFFFD700),
                  onTap: () {
                    // Navigate to Achievement System to show clickable achievements
                    Navigator.pushNamed(context, '/achievement-system');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _calculateAchievementCount() {
    final streak = _userData["currentStreak"] ?? 0;
    int count = 0;
    if (streak >= 1) count++; // First day
    if (streak >= 7) count++; // First week
    if (streak >= 30) count++; // First month
    if (streak >= 90) count++; // Three months
    if (streak >= 365) count++; // One year
    return count;
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
        "label": l10n.navigationHealthScore,
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
                  if (item["route"] != "/dashboard-home") {
                    Navigator.pushReplacementNamed(context, item["route"]);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
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
                          fontSize: 8.5.sp,
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

  Widget _buildCravingSupportFAB() {
    return Container(
      width: 14.w,
      height: 14.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.secondary,
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.8),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _showCravingSupport,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: CustomIconWidget(
          iconName: 'support_agent',
          color: Colors.white,
          size: 7.w,
        ),
      ),
    );
  }

  void _showCravingSupport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CravingSupportSheet(),
    );
  }
}
