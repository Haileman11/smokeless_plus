import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/achievement_system/achievement_system.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/craving_support/craving_support.dart';
import '../presentation/progress_tracking/progress_tracking.dart';
import '../presentation/statistics_dashboard/statistics_dashboard.dart';
import '../presentation/health_milestones/health_milestones.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/health_score_dashboard/health_score_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String achievementSystem = '/achievement-system';
  static const String userProfile = '/user-profile';
  static const String onboardingFlow = '/onboarding-flow';
  static const String cravingSupport = '/craving-support';
  static const String progressTracking = '/progress-tracking';
  static const String statisticsDashboard = '/statistics-dashboard';
  static const String healthMilestones = '/health-milestones';
  static const String dashboardHome = '/dashboard-home';
  static const String healthScoreDashboard = '/health-score-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    achievementSystem: (context) => const AchievementSystem(),
    userProfile: (context) {
      // This is handled in onGenerateRoute for language callback support
      return const UserProfile();
    },
    onboardingFlow: (context) => const OnboardingFlow(),
    cravingSupport: (context) => const CravingSupport(),
    progressTracking: (context) => const ProgressTracking(),
    statisticsDashboard: (context) => const StatisticsDashboard(),
    healthMilestones: (context) => const HealthMilestones(),
    dashboardHome: (context) => const DashboardHome(),
    healthScoreDashboard: (context) => const HealthScoreDashboard(),
    // TODO: Add your other routes here
  };
}
