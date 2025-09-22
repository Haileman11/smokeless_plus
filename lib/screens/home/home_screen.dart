import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smokeless_plus/constants/colors.dart';
import 'package:smokeless_plus/services/app_state.dart';
import 'package:smokeless_plus/services/theme_service.dart';
import '../../widgets/navigation/bottom_navigation.dart';
import '../../widgets/navigation/navigation_header.dart';
import '../dashboard/dashboard_screen.dart';
import '../health/health_timeline_screen.dart';
import '../rewards/rewards_screen.dart';
import '../journal/journal_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    HealthTimelineScreen(),
    RewardsScreen(),
    JournalScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: NavigationHeader(
      //   onOpenSettings: () => setState(() => _currentIndex = 4), // Settings is at index 4
      // ),
      body: SafeArea(
        child: Column(          
          children: [
            _buildHeader(Provider.of<ThemeService>(context).isDarkMode, Provider.of<AppState>(context)),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
  Widget _buildHeader(bool isDarkMode, AppState appState) {
    final themeService = Provider.of<ThemeService>(context);

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.lightCard,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [

            Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.eco_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Smokeless +',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),                  
                ],
              ),
            ),
            // Search and Theme Toggle
            Row(
              children: [
                // IconButton(
                //   onPressed: () => setState(() => _showSearch = true),
                //   icon: Icon(
                //     Icons.search,
                //     color: isDarkMode ? Colors.white : Colors.black87,
                //   ),
                // ),
                IconButton(
                  onPressed: () => themeService.toggleTheme(),
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}