import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/services/notification_sevice.dart';
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
  String _selectedCurrency = 'USD (\$)';

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
        currency: _selectedCurrency,
        motivationTime: "${_motivationTime.hour} ${_motivationTime.minute}",
      );
    }
    scheduleMilestoneNotifications();
    scheduleDailyReminder( _motivationTime);
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
                color: Theme.of(context).colorScheme.secondary.withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomIconWidget(
                iconName: 'celebration',
                color: Theme.of(context).colorScheme.secondary,
                size: 15.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              AppLocalizations.of(context)!.welcomeToYourJourney,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              AppLocalizations.of(context)!.youAreAllSetToStartYourSmokeFreeLife,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              // height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(
                    context,
                    '/dashboard-home',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Start My Journey',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: Theme.of(context).colorScheme.onSurface,
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      AppLocalizations.of(context)!.stepXofY(_currentStep + 1, _totalSteps),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
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
                    dotColor: Theme.of(context).colorScheme.outline,
                    activeDotColor: Theme.of(context).colorScheme.primary,
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
                    title: AppLocalizations.of(context)!.whenDidYouQuitSmoking,
                    description:
                        AppLocalizations.of(context)!.selectYourQuitDateToTrackProgress,
                    imageUrl:
                        'assets/images/step-one.png',
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
                    title: AppLocalizations.of(context)!.tellUsAboutYourSmokingHabits,
                    description:
                        AppLocalizations.of(context)!.thisHelpsUsCalculateYourSavings,
                    imageUrl:
                        'assets/images/step-two.png',
                    customContent: SmokingHabitsWidget(
                      cigarettesPerDay: _cigarettesPerDay,
                      costPerPack: _costPerPack,
                      yearsSmoking: _yearsSmoking,
                      currency: _selectedCurrency,
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
                      onCurrencyChanged: (value) {
                        setState(() {
                          _selectedCurrency = value;
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
                    title: AppLocalizations.of(context)!.stayMotivatedWithNotifications,
                    description:
                        AppLocalizations.of(context)!.chooseHowYoudLikeToReceiveSupport,
                    imageUrl:
                        'assets/images/step-three.png',
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
                    title: AppLocalizations.of(context)!.discoverPowerfulFeatures,
                    description:
                        AppLocalizations.of(context)!.exploreTheToolsThatWillSupportYou,
                    imageUrl:
                        'assets/images/step-four.png',
                    customContent: const FeaturePreviewWidget(),
                    onNext: _nextStep,
                    buttonText: AppLocalizations.of(context)!.continueText,
                  ),
                  // Step 5: Dashboard Preview
                  OnboardingStepWidget(
                    title: AppLocalizations.of(context)!.yourPersonalizedDashboard,
                    description:
                        AppLocalizations.of(context)!.dashboardPreviewDescription,
                    imageUrl:
                        'assets/images/step-five.png',
                    customContent: _quitDate != null
                        ? DashboardPreviewWidget(
                            quitDate: _quitDate!,
                            cigarettesPerDay: _cigarettesPerDay,
                            costPerPack: _costPerPack,
                          )
                        : null,
                    onNext: _nextStep,
                    buttonText: AppLocalizations.of(context)!.completeSetup,
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
