import 'package:flutter/material.dart';
import 'dart:async';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/custom_button.dart';

class BreathingExerciseScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const BreathingExerciseScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  _BreathingExerciseScreenState createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> with TickerProviderStateMixin {
  bool _isActive = false;
  int _timeLeft = 120; // 2 minutes in seconds
  String _phase = 'inhale'; // 'inhale', 'hold', 'exhale'
  int _phaseTime = 4;
  int _cycle = 1;
  bool _isComplete = false;
  Timer? _mainTimer;
  Timer? _phaseTimer;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _mainTimer?.cancel();
    _phaseTimer?.cancel();
    _breathingController.dispose();
    super.dispose();
  }

  void _startExercise() {
    _ensureTimersCleared();
    
    setState(() {
      _isActive = true;
      if (_timeLeft == 120) {
        // Fresh start
        _timeLeft = 120;
        _phase = 'inhale';
        _phaseTime = 4;
        _cycle = 1;
        _isComplete = false;
      }
      // Resume from current state if paused
    });

    // Start main countdown timer
    _mainTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _completeExercise();
      }
    });

    // Start breathing animation based on current phase with correct duration
    switch (_phase) {
      case 'inhale':
        _breathingController.duration = Duration(seconds: 4);
        _breathingController.forward();
        break;
      case 'exhale':
        _breathingController.duration = Duration(seconds: 8);
        _breathingController.reverse();
        break;
      case 'hold':
        _breathingController.stop();
        break;
    }

    // Start phase timer
    _startPhaseTimer();
  }

  void _startPhaseTimer() {
    _phaseTimer?.cancel();
    _phaseTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_phaseTime > 1) {
        setState(() => _phaseTime--);
      } else {
        _moveToNextPhase();
      }
    });
  }

  void _ensureTimersCleared() {
    _mainTimer?.cancel();
    _phaseTimer?.cancel();
    _mainTimer = null;
    _phaseTimer = null;
  }

  void _moveToNextPhase() {
    setState(() {
      switch (_phase) {
        case 'inhale':
          _phase = 'hold';
          _phaseTime = 7;
          _breathingController.stop();
          break;
        case 'hold':
          _phase = 'exhale';
          _phaseTime = 8;
          _breathingController.reverse();
          break;
        case 'exhale':
          _phase = 'inhale';
          _phaseTime = 4;
          _cycle++;
          _breathingController.forward();
          break;
      }
    });

    // Update animation based on phase
    switch (_phase) {
      case 'inhale':
        _breathingController.duration = Duration(seconds: 4);
        _breathingController.forward();
        break;
      case 'hold':
        _breathingController.stop();
        break;
      case 'exhale':
        _breathingController.duration = Duration(seconds: 8);
        _breathingController.reverse();
        break;
    }
  }

  void _pauseExercise() {
    setState(() => _isActive = false);
    _mainTimer?.cancel();
    _phaseTimer?.cancel();
    _breathingController.stop();
  }

  void _resumeExercise() {
    _ensureTimersCleared();
    
    setState(() => _isActive = true);
    
    // Resume timers without resetting state
    _mainTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _completeExercise();
      }
    });

    // Resume breathing animation based on current phase with correct duration
    switch (_phase) {
      case 'inhale':
        _breathingController.duration = Duration(seconds: 4);
        _breathingController.forward();
        break;
      case 'exhale':
        _breathingController.duration = Duration(seconds: 8);
        _breathingController.reverse();
        break;
      case 'hold':
        _breathingController.stop();
        break;
    }

    _startPhaseTimer();
  }

  void _completeExercise() {
    setState(() {
      _isComplete = true;
      _isActive = false;
    });
    _mainTimer?.cancel();
    _phaseTimer?.cancel();
    _breathingController.stop();
    
    // Call completion callback after a short delay
    Future.delayed(Duration(milliseconds: 1500), () {
      widget.onComplete();
      Navigator.of(context).pop();
    });
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins}:${secs.toString().padLeft(2, '0')}';
  }

  double _getProgress() {
    return (120 - _timeLeft) / 120;
  }

  String _getPhaseInstruction() {
    switch (_phase) {
      case 'inhale':
        return 'Breathe In';
      case 'hold':
        return 'Hold';
      case 'exhale':
        return 'Breathe Out';
      default:
        return '';
    }
  }

  Color _getPhaseColor() {
    switch (_phase) {
      case 'inhale':
        return Colors.green;
      case 'hold':
        return Colors.orange;
      case 'exhale':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('4-7-8 Breathing', style: AppTextStyles.h3),
        backgroundColor: Colors.blue.shade500,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.blue.shade600],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                // Progress bar
                LinearProgressIndicator(
                  value: _getProgress(),
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 24),

                // Time remaining
                Text(
                  _formatTime(_timeLeft),
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Cycle $_cycle',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 48),

                // Breathing animation circle
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _breathingAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 200 * _breathingAnimation.value,
                          height: 200 * _breathingAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getPhaseColor().withOpacity(0.3),
                            border: Border.all(
                              color: _getPhaseColor(),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _getPhaseInstruction(),
                                  style: AppTextStyles.h2.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '$_phaseTime',
                                  style: AppTextStyles.h1.copyWith(
                                    color: Colors.white,
                                    fontSize: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 48),

                // Control buttons
                if (!_isComplete) ...[
                  if (!_isActive)
                    CustomButton(
                      text: _timeLeft == 120 ? 'Start Exercise' : 'Resume',
                      onPressed: _timeLeft == 120 ? _startExercise : _resumeExercise,
                      backgroundColor: Colors.white,
                      textColor: Colors.blue.shade600,
                      icon: Icons.play_arrow,
                    )
                  else
                    CustomButton(
                      text: 'Pause',
                      onPressed: _pauseExercise,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      textColor: Colors.blue.shade600,
                      icon: Icons.pause,
                    ),
                ] else ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 48),
                        SizedBox(height: 8),
                        Text(
                          'Well Done!',
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                        Text(
                          'You completed the breathing exercise',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}