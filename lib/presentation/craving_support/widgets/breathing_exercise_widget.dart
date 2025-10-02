import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/utils/utils.dart';

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
  BreathingPhase _currentPhase = BreathingPhase.inhale;
  int _phaseCountdown = 4;

  late final List<String> _motivationalQuotes;

  String _currentQuote = "";

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setRandomQuote();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _motivationalQuotes = [
      AppLocalizations.of(context)!.everyBreathIsANewBeginning,
      AppLocalizations.of(context)!.youAreStrongerThanYourCravings,
      AppLocalizations.of(context)!.thisMomentWillPass,
      AppLocalizations.of(context)!.breatheInPeace,
      AppLocalizations.of(context)!.yourHealthIsWorthEveryBreath,
      AppLocalizations.of(context)!.oneBreathAtATime,
  ];
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
      await _runPhase(BreathingPhase.inhale, 4, 0.3, 1.0);

      // Hold phase (7 seconds)
      await _runPhase(BreathingPhase.hold, 7, 1.0, 1.0);

      // Exhale phase (8 seconds)
      await _runPhase(BreathingPhase.exhale, 8, 1.0, 0.3);
    }

    if (_isExerciseActive) {
      _completeExercise();
    }
  }

  Future<void> _runPhase(
      BreathingPhase phase, int duration, double startValue, double endValue) async {
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
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
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: _stopExercise,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: Theme.of(context).colorScheme.primary,
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
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
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
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
                            Theme.of(context).colorScheme.secondary,
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
                                Theme.of(context).colorScheme.primary
                                    .withValues(alpha: 0.3),
                                Theme.of(context).colorScheme.secondary
                                    .withValues(alpha: 0.1),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary
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
                                color: Theme.of(context).colorScheme.primary
                                    .withValues(alpha: 0.8),
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'air',
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                        getLocalizedBreathingPhase(context, _currentPhase),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _phaseCountdown.toString(),
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ] else ...[
                      Text(
                        AppLocalizations.of(context)!.readyToBreathe,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                       AppLocalizations.of(context)!.fourSevenEightTechnique,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
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
                color: Theme.of(context).colorScheme.surface,
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurface,
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
                          AppLocalizations.of(context)!.startExercise,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
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
                          AppLocalizations.of(context)!.extendExercise,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
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
                              Theme.of(context).colorScheme.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.stopExercise,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.onError,
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
