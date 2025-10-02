import 'package:flutter/material.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/presentation/onboarding_flow/widgets/smoking_habits_widget.dart';

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUserData,
          color: Theme.of(context).colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(l10n),
              _buildHealthScoreProgress(l10n),
              _buildHealthCategoryBreakdown(l10n),
              _buildRecoveryTimeline(l10n),
              _buildMedicalInsights(l10n),
              _buildComparisonChart(l10n),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  
                  child: EstimatedSmokingImpact(
                    yearsSmoking: _userData["yearsSmoking"] ?? 0.0,
                    packCost: _userData["packCost"] ?? 0.0,
                    cigarettesPerDay: _userData["cigarettesPerDay"] ?? 0,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      // leading: IconButton(
      //   onPressed: () => Navigator.pop(context),
      //   icon: CustomIconWidget(
      //     iconName: 'arrow_back',
      //     color: Theme.of(context).colorScheme.primary,
      //     size: 6.w,
      //   ),
      // ),
      title: Text(
        AppLocalizations.of(context)!.healthScoreDashboard,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,   
          color: Theme.of(context).colorScheme.primary,        
        ),
      ),
      actions: [
        IconButton(
          onPressed: _exportHealthReport,
          icon: CustomIconWidget(
            iconName: 'share',            
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

  void _exportHealthReport() {
    // Show share sheet functionality for health reports
    Navigator.pushNamed(context, AppRoutes.statisticsDashboard);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Health report export feature coming soon'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
