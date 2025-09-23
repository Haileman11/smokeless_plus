import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BreathingExerciseWidget extends StatefulWidget {
  final VoidCallback onClose;

  const BreathingExerciseWidget({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  State<BreathingExerciseWidget> createState() =>
      _BreathingExerciseWidgetState();
}

class _BreathingExerciseWidgetState extends State<BreathingExerciseWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _timerController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _timerAnimation;

  bool _isExerciseActive = false;
  int _currentCycle = 0;
  int _totalCycles = 4;
  String _currentPhase = 'Inhale';
  int _phaseCountdown = 4;

  final List<String> _motivationalQuotes = [
    "Every breath is a new beginning",
    "You are stronger than your cravings",
    "This moment will pass, you will overcome",
    "Breathe in peace, breathe out stress",
    "Your health is worth every breath",
    "One breath at a time, one day at a time",
  ];

  String _currentQuote = "";

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setRandomQuote();
  }

  void _initializeAnimations() {
    _breathingController = AnimationController(
      duration: const Duration(seconds: 19), // 4-7-8 cycle
      vsync: this,
    );

    _timerController = AnimationController(
      duration: Duration(seconds: _totalCycles * 19),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _timerAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_timerController);
  }

  void _setRandomQuote() {
    _motivationalQuotes.shuffle();
    _currentQuote = _motivationalQuotes.first;
  }

  void _startBreathingExercise() {
    setState(() {
      _isExerciseActive = true;
      _currentCycle = 0;
    });

    _timerController.forward();
    _runBreathingCycle();
  }

  void _runBreathingCycle() async {
    for (int cycle = 0; cycle < _totalCycles; cycle++) {
      if (!_isExerciseActive) break;

      setState(() {
        _currentCycle = cycle + 1;
      });

      // Inhale phase (4 seconds)
      await _runPhase('Inhale', 4, 0.3, 1.0);

      // Hold phase (7 seconds)
      await _runPhase('Hold', 7, 1.0, 1.0);

      // Exhale phase (8 seconds)
      await _runPhase('Exhale', 8, 1.0, 0.3);
    }

    if (_isExerciseActive) {
      _completeExercise();
    }
  }

  Future<void> _runPhase(
      String phase, int duration, double startValue, double endValue) async {
    if (!_isExerciseActive) return;

    setState(() {
      _currentPhase = phase;
      _phaseCountdown = duration;
    });

    _breathingController.reset();
    _breathingAnimation = Tween<double>(
      begin: startValue,
      end: endValue,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _breathingController.duration = Duration(seconds: duration);
    _breathingController.forward();

    // Haptic feedback for breathing rhythm
    HapticFeedback.lightImpact();

    for (int i = duration; i > 0; i--) {
      if (!_isExerciseActive) break;

      setState(() {
        _phaseCountdown = i;
      });

      await Future.delayed(const Duration(seconds: 1));

      // Light haptic feedback every second
      if (i > 1) HapticFeedback.selectionClick();
    }
  }

  void _completeExercise() {
    setState(() {
      _isExerciseActive = false;
    });

    HapticFeedback.mediumImpact();

    // Show completion message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Great job! You completed the breathing exercise.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _stopExercise() {
    setState(() {
      _isExerciseActive = false;
    });

    _breathingController.stop();
    _timerController.stop();
    widget.onClose();
  }

  void _extendSession() {
    setState(() {
      _totalCycles += 2;
    });

    _timerController.duration = Duration(seconds: _totalCycles * 19);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with close button
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Breathing Exercise',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: _stopExercise,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Progress indicator
            if (_isExerciseActive) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cycle $_currentCycle of $_totalCycles',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _timerAnimation,
                          builder: (context, child) {
                            int remainingTime =
                                (_timerAnimation.value * _totalCycles * 19)
                                    .round();
                            int minutes = remainingTime ~/ 60;
                            int seconds = remainingTime % 60;
                            return Text(
                              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    AnimatedBuilder(
                      animation: _timerAnimation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: 1.0 - _timerAnimation.value,
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
            ],

            // Breathing circle animation
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Breathing circle
                    AnimatedBuilder(
                      animation: _breathingAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 60.w * _breathingAnimation.value,
                          height: 60.w * _breathingAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.3),
                                AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.1),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.8),
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'air',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 4.h),

                    // Phase instruction
                    if (_isExerciseActive) ...[
                      Text(
                        _currentPhase,
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _phaseCountdown.toString(),
                        style: AppTheme.lightTheme.textTheme.displaySmall
                            ?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: AppTheme.lightTheme.colorScheme.secondary,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Ready to breathe?',
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '4-7-8 Breathing Technique',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Motivational quote
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _currentQuote,
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Control buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  if (!_isExerciseActive) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _startBreathingExercise,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Start Exercise',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _extendSession,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Extend (+2 cycles)',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _stopExercise,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Stop',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onError,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
