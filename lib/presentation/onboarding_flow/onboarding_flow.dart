import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/app_export.dart';
import '../../services/user_data_service.dart';
import './widgets/dashboard_preview_widget.dart';
import './widgets/feature_preview_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/onboarding_step_widget.dart';
import './widgets/quit_date_picker_widget.dart';
import './widgets/smoking_habits_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentStep = 0;
  final int _totalSteps = 5;

  // User data
  DateTime? _quitDate;
  int _cigarettesPerDay = 0;
  double _costPerPack = 0.0;
  double _yearsSmoking = 0.0;
  bool _dailyMotivation = true;
  bool _milestoneAlerts = true;
  bool _cravingSupport = true;
  TimeOfDay _motivationTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    try {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);
    } catch (e) {
      // Fallback navigation
      Navigator.pushReplacementNamed(context, '/dashboard-home');
    }
  }

  void _completeOnboarding() {
    // Save user data with years of smoking
      print(_quitDate);
    if (_quitDate != null) {
      UserDataService.saveUserData(
        quitDate: _quitDate!,
        cigarettesPerDay: _cigarettesPerDay,
        costPerPack: _costPerPack,
        cigarettesPerPack: 20,
        userName: 'User',
        yearsSmoking: _yearsSmoking,
      );
    }

    // Show celebration animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary.withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomIconWidget(
                iconName: 'celebration',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 15.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Welcome to Your Journey!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'You\'re all set to start your smoke-free life. Let\'s begin this amazing journey together!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(
                    context,
                    '/dashboard-home',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Start My Journey',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _quitDate != null;
      case 1:
        return _cigarettesPerDay > 0 && _costPerPack > 0 && _yearsSmoking > 0;
      case 2:
      case 3:
      case 4:
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              )
            : null,
        actions: [
          if (_currentStep < _totalSteps - 1)
            TextButton(
              onPressed: _skipToEnd,
              child: Text(
                'Skip',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentStep + 1} of $_totalSteps',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                AnimatedSmoothIndicator(
                  activeIndex: _currentStep,
                  count: _totalSteps,
                  effect: WormEffect(
                    dotColor: AppTheme.lightTheme.colorScheme.outline,
                    activeDotColor: AppTheme.lightTheme.colorScheme.primary,
                    dotHeight: 1.h,
                    dotWidth: 15.w,
                    spacing: 2.w,
                  ),
                ),
              ],
            ),
          ),
          // Page content
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                  _animationController.reset();
                  _animationController.forward();
                },
                children: [
                  // Step 1: Quit Date
                  OnboardingStepWidget(
                    title: 'When did you quit smoking?',
                    description:
                        'Select your quit date to track your progress and celebrate milestones.',
                    imageUrl:
                        'https://images.pexels.com/photos/6975474/pexels-photo-6975474.jpeg?auto=compress&cs=tinysrgb&w=800',
                    customContent: QuitDatePickerWidget(
                      selectedDate: _quitDate,
                      onDateSelected: (date) {
                        setState(() {
                          _quitDate = date;
                        });
                      },
                    ),
                    onNext: _canProceed() ? _nextStep : null,
                    buttonText: 'Continue',
                  ),
                  // Step 2: Smoking Habits - UPDATED
                  OnboardingStepWidget(
                    title: 'Tell us about your smoking habits',
                    description:
                        'This helps us calculate your savings and personalize your experience.',
                    imageUrl:
                        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=800&q=80',
                    customContent: SmokingHabitsWidget(
                      cigarettesPerDay: _cigarettesPerDay,
                      costPerPack: _costPerPack,
                      yearsSmoking: _yearsSmoking,
                      onCigarettesChanged: (value) {
                        setState(() {
                          _cigarettesPerDay = value;
                        });
                      },
                      onCostChanged: (value) {
                        setState(() {
                          _costPerPack = value;
                        });
                      },
                      onYearsSmokingChanged: (value) {
                        setState(() {
                          _yearsSmoking = value;
                        });
                      },
                    ),
                    onNext: _canProceed() ? _nextStep : null,
                    buttonText: 'Continue',
                  ),
                  // Step 3: Notification Preferences
                  OnboardingStepWidget(
                    title: 'Stay motivated with notifications',
                    description:
                        'Choose how you\'d like to receive support and encouragement.',
                    imageUrl:
                        'https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&w=800',
                    customContent: NotificationPreferencesWidget(
                      dailyMotivation: _dailyMotivation,
                      milestoneAlerts: _milestoneAlerts,
                      cravingSupport: _cravingSupport,
                      motivationTime: _motivationTime,
                      onDailyMotivationChanged: (value) {
                        setState(() {
                          _dailyMotivation = value;
                        });
                      },
                      onMilestoneAlertsChanged: (value) {
                        setState(() {
                          _milestoneAlerts = value;
                        });
                      },
                      onCravingSupportChanged: (value) {
                        setState(() {
                          _cravingSupport = value;
                        });
                      },
                      onMotivationTimeChanged: (time) {
                        setState(() {
                          _motivationTime = time;
                        });
                      },
                    ),
                    onNext: _nextStep,
                    buttonText: 'Continue',
                  ),
                  // Step 4: Feature Preview
                  OnboardingStepWidget(
                    title: 'Discover powerful features',
                    description:
                        'Explore the tools that will support you on your smoke-free journey.',
                    imageUrl:
                        'https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=800',
                    customContent: const FeaturePreviewWidget(),
                    onNext: _nextStep,
                    buttonText: 'Continue',
                  ),
                  // Step 5: Dashboard Preview
                  OnboardingStepWidget(
                    title: 'Your personalized dashboard',
                    description:
                        'Here\'s a preview of your progress based on the information you provided.',
                    imageUrl:
                        'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=800',
                    customContent: _quitDate != null
                        ? DashboardPreviewWidget(
                            quitDate: _quitDate!,
                            cigarettesPerDay: _cigarettesPerDay,
                            costPerPack: _costPerPack,
                          )
                        : null,
                    onNext: _nextStep,
                    buttonText: 'Complete Setup',
                    isLastStep: true,
                    showSkip: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
