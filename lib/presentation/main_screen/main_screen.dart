import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/presentation/achievement_system/achievement_system.dart';
import 'package:smokeless_plus/presentation/dashboard_home/dashboard_home.dart';
import 'package:smokeless_plus/presentation/health_score_dashboard/health_score_dashboard.dart';
import 'package:smokeless_plus/presentation/progress_tracking/progress_tracking.dart';
import 'package:smokeless_plus/presentation/user_profile/user_profile.dart';
import 'package:smokeless_plus/services/notification_sevice.dart';
import 'package:smokeless_plus/services/theme_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Use PageController to maintain state across tab switches
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const DashboardHome(),
    const ProgressTracking(),
    const HealthScoreDashboard(),    
    const AchievementSystem(),
    const UserProfile(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(onPressed: (){
        sendTestNotification();
      }),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, l10n.navigationHome, 0, isDarkMode),
                _buildNavItem(
                    Icons.trending_up, l10n.navigationProgress, 1, isDarkMode),
                _buildNavItem(
                    Icons.favorite, l10n.navigationHealthScore, 2, isDarkMode),
                _buildNavItem(Icons.emoji_events, l10n.navigationAchievements,
                    3, isDarkMode),
                _buildNavItem(
                    Icons.person, l10n.navigationProfile, 4, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, int index, bool isDarkMode) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 5 - 4,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
