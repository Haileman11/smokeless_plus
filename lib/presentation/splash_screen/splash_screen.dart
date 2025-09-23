import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/gradient_background_widget.dart';
import './widgets/health_icons_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _loadingProgress = 0.0;
  bool _isInitialized = false;
  String _loadingMessage = 'Initializing your quit journey...';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupStatusBar();
    _initializeAnimations();
    _startInitialization();
  }

  void _setupStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
  }

  Future<void> _startInitialization() async {
    try {
      // Step 1: Check user preferences
      await _updateProgress(0.2, 'Loading user preferences...');
      await Future.delayed(const Duration(milliseconds: 300));

      // Step 2: Check quit date
      await _updateProgress(0.4, 'Checking quit date...');
      final hasQuitDate = await _checkQuitDate();
      await Future.delayed(const Duration(milliseconds: 300));

      // Step 3: Load progress data
      await _updateProgress(0.6, 'Loading progress data...');
      await _loadProgressData();
      await Future.delayed(const Duration(milliseconds: 300));

      // Step 4: Calculate current streak
      await _updateProgress(0.8, 'Calculating streak...');
      await _calculateCurrentStreak();
      await Future.delayed(const Duration(milliseconds: 300));

      // Step 5: Prepare motivational content
      await _updateProgress(1.0, 'Preparing motivational content...');
      await _prepareMotivationalContent();
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isInitialized = true;
      });

      // Navigate based on user status
      await Future.delayed(const Duration(milliseconds: 800));
      await _navigateToNextScreen(hasQuitDate);
    } catch (e) {
      await _handleInitializationError(e);
    }
  }

  Future<void> _updateProgress(double progress, String message) async {
    if (mounted) {
      setState(() {
        _loadingProgress = progress;
        _loadingMessage = message;
      });
    }
  }

  Future<bool> _checkQuitDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final quitDateString = prefs.getString('quit_date');
      return quitDateString != null && quitDateString.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadProgressData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load basic progress data
      final smokeFreeHours = prefs.getInt('smoke_free_hours') ?? 0;
      final moneySaved = prefs.getDouble('money_saved') ?? 0.0;
      final cigarettesAvoided = prefs.getInt('cigarettes_avoided') ?? 0;

      // Simulate data validation
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      // Handle data corruption gracefully
      await _resetCorruptedData();
    }
  }

  Future<void> _calculateCurrentStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final quitDateString = prefs.getString('quit_date');

      if (quitDateString != null) {
        final quitDate = DateTime.parse(quitDateString);
        final now = DateTime.now();
        final difference = now.difference(quitDate);

        // Store current streak
        await prefs.setInt('current_streak_days', difference.inDays);
        await prefs.setInt('current_streak_hours', difference.inHours);
      }
    } catch (e) {
      // Handle calculation errors
    }
  }

  Future<void> _prepareMotivationalContent() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Prepare daily motivational messages
      final List<String> motivationalMessages = [
        "Every smoke-free moment is a victory! 🎉",
        "Your lungs are thanking you right now! 💚",
        "You're stronger than any craving! 💪",
        "Each day smoke-free is an investment in your health! 📈",
        "Your future self will thank you for this decision! ✨",
      ];

      final today = DateTime.now().day;
      final messageIndex = today % motivationalMessages.length;
      await prefs.setString(
          'daily_motivation', motivationalMessages[messageIndex]);

      // Prepare achievement data
      await _checkForNewAchievements();
    } catch (e) {
      // Handle content preparation errors
    }
  }

  Future<void> _checkForNewAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentStreakDays = prefs.getInt('current_streak_days') ?? 0;

      // Check for milestone achievements
      final List<int> milestones = [1, 3, 7, 14, 30, 90, 365];
      final List<String> unlockedBadges =
          prefs.getStringList('unlocked_badges') ?? [];

      for (int milestone in milestones) {
        if (currentStreakDays >= milestone &&
            !unlockedBadges.contains('${milestone}_days')) {
          unlockedBadges.add('${milestone}_days');
        }
      }

      await prefs.setStringList('unlocked_badges', unlockedBadges);
    } catch (e) {
      // Handle achievement check errors
    }
  }

  Future<void> _resetCorruptedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Reset only corrupted data, keep user preferences
      await prefs.remove('smoke_free_hours');
      await prefs.remove('money_saved');
      await prefs.remove('cigarettes_avoided');

      // Show recovery options to user later
      await prefs.setBool('show_data_recovery', true);
    } catch (e) {
      // Handle reset errors
    }
  }

  Future<void> _navigateToNextScreen(bool hasQuitDate) async {
    await _fadeController.forward();

    if (mounted) {
      if (hasQuitDate) {
        Navigator.pushReplacementNamed(context, '/dashboard-home');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      }
    }
  }

  Future<void> _handleInitializationError(dynamic error) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('initialization_error', true);
      await prefs.setString('error_details', error.toString());

      if (mounted) {
        setState(() {
          _loadingMessage = 'Preparing app...';
          _loadingProgress = 1.0;
        });
      }

      // Navigate to onboarding as fallback
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      }
    } catch (e) {
      // Ultimate fallback
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: GradientBackgroundWidget(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),

                      // Animated Logo Section
                      const AnimatedLogoWidget(),

                      SizedBox(height: 4.h),

                      // Health Icons Animation
                      const HealthIconsWidget(),

                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),

                      // Loading Section
                      LoadingIndicatorWidget(progress: _loadingProgress),

                      SizedBox(height: 2.h),

                      // Loading Message
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _loadingMessage,
                          key: ValueKey(_loadingMessage),
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                            fontSize: 12.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // App Version and Copyright
                      Column(
                        children: [
                          Text(
                            'Version 1.0.0',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                              fontSize: 10.sp,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '© 2024 QuitSmoking Tracker',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
