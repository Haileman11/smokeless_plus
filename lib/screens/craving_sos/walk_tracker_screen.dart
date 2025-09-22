import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/custom_button.dart';

class WalkTrackerScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const WalkTrackerScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  _WalkTrackerScreenState createState() => _WalkTrackerScreenState();
}

class _WalkTrackerScreenState extends State<WalkTrackerScreen> {
  bool _isActive = false;
  int _timeLeft = 300; // 5 minutes in seconds
  bool _isComplete = false;
  int _steps = 0;
  Timer? _mainTimer;
  Timer? _stepTimer;

  @override
  void dispose() {
    _mainTimer?.cancel();
    _stepTimer?.cancel();
    super.dispose();
  }

  void _startWalk() {
    setState(() {
      _isActive = true;
      _timeLeft = 300;
      _isComplete = false;
      _steps = 0;
    });

    // Main countdown timer
    _mainTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _completeWalk();
      }
    });

    // Simulate step counting
    _stepTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_isActive && _timeLeft > 0) {
        // Simulate steps (average 120 steps per minute)
        if (Random().nextBool()) {
          setState(() => _steps++);
        }
      }
    });
  }

  void _pauseWalk() {
    setState(() => _isActive = false);
    _mainTimer?.cancel();
    _stepTimer?.cancel();
  }

  void _resumeWalk() {
    _startWalk();
  }

  void _completeWalk() {
    setState(() {
      _isComplete = true;
      _isActive = false;
    });
    _mainTimer?.cancel();
    _stepTimer?.cancel();
    
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
    return (300 - _timeLeft) / 300;
  }

  String _getEncouragement() {
    final elapsed = 300 - _timeLeft;
    if (elapsed < 60) return "Great start! Keep moving! 🚶‍♀️";
    if (elapsed < 120) return "You're doing amazing! 💪";
    if (elapsed < 180) return "Halfway there! Keep it up! 🎯";
    if (elapsed < 240) return "Almost done! You've got this! 🔥";
    return "Final stretch! Amazing work! 🌟";
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('5-Minute Walk', style: AppTextStyles.h3),
        backgroundColor: Colors.green.shade500,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade400, Colors.green.shade600],
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
                  '${(_getProgress() * 100).toInt()}% Complete',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 48),

                // Stats
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Steps counter
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.directions_walk, size: 48, color: Colors.white),
                            SizedBox(height: 16),
                            Text(
                              '$_steps',
                              style: AppTextStyles.h1.copyWith(
                                color: Colors.white,
                                fontSize: 42,
                              ),
                            ),
                            Text(
                              'Steps',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Encouragement
                      if (_isActive && !_isComplete)
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getEncouragement(),
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Control buttons
                if (!_isComplete) ...[
                  if (!_isActive)
                    CustomButton(
                      text: _timeLeft == 300 ? 'Start Walk' : 'Resume',
                      onPressed: _startWalk,
                      backgroundColor: Colors.white,
                      textColor: Colors.green.shade600,
                      icon: Icons.play_arrow,
                    )
                  else
                    CustomButton(
                      text: 'Pause',
                      onPressed: _pauseWalk,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      textColor: Colors.green.shade600,
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
                          'Excellent!',
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                        Text(
                          'You completed your 5-minute walk with $_steps steps!',
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