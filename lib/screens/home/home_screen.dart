import 'package:flutter/material.dart';
import '../../widgets/navigation/bottom_navigation.dart';
import '../dashboard/dashboard_screen.dart';
import '../health/health_timeline_screen.dart';
import '../rewards/rewards_screen.dart';
import '../journal/journal_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
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
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}