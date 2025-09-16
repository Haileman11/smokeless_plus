import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'welcome_screen.dart';
import 'reason_screen.dart';
import 'congratulations_screen.dart';
import 'profile_setup_screen.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedReason = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          WelcomeScreen(onNext: () => _nextPage()),
          ReasonScreen(
            onNext: (reason) {
              _selectedReason = reason;
              _nextPage();
            },
            onBack: () => _previousPage(),
          ),
          CongratulationsScreen(
            reason: _selectedReason,
            onNext: () => _nextPage(),
            onBack: () => _previousPage(),
          ),
          ProfileSetupScreen(
            reason: _selectedReason,
            onComplete: () => _completeOnboarding(),
            onBack: () => _previousPage(),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}