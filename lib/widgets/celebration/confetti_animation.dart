import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ConfettiAnimation extends StatefulWidget {
  final bool trigger;
  final VoidCallback? onComplete;

  const ConfettiAnimation({
    Key? key,
    required this.trigger,
    this.onComplete,
  }) : super(key: key);

  @override
  _ConfettiAnimationState createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _fallAnimations = [];
  List<Animation<double>> _rotationAnimations = [];
  List<Color> _colors = [];
  List<Offset> _positions = [];
  Timer? _cleanupTimer;

  final List<Color> _confettiColors = [
    Color(0xFF10b981), // green
    Color(0xFF3b82f6), // blue
    Color(0xFFf59e0b), // amber
    Color(0xFFef4444), // red
    Color(0xFF8b5cf6), // purple
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(ConfettiAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.trigger && !oldWidget.trigger) {
      _createConfetti();
    }
  }

  void _createConfetti() {
    // Clear existing animations
    _disposeControllers();

    final random = Random();
    const int confettiCount = 50;

    for (int i = 0; i < confettiCount; i++) {
      final controller = AnimationController(
        duration: Duration(
          milliseconds: 2000 + random.nextInt(3000), // 2-5 seconds
        ),
        vsync: this,
      );

      final fallAnimation = Tween<double>(
        begin: -50,
        end: MediaQuery.of(context).size.height + 50,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ));

      final rotationAnimation = Tween<double>(
        begin: 0,
        end: random.nextDouble() * 4 * pi, // 0 to 4π radians
      ).animate(controller);

      _controllers.add(controller);
      _fallAnimations.add(fallAnimation);
      _rotationAnimations.add(rotationAnimation);
      _colors.add(_confettiColors[random.nextInt(_confettiColors.length)]);
      _positions.add(Offset(
        random.nextDouble() * MediaQuery.of(context).size.width,
        -50,
      ));

      // Start animation with random delay
      Future.delayed(Duration(milliseconds: random.nextInt(2000)), () {
        if (mounted) {
          controller.forward();
        }
      });
    }

    setState(() {});

    // Clean up after 6 seconds
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer(Duration(seconds: 6), () {
      _disposeControllers();
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  void _disposeControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    _fallAnimations.clear();
    _rotationAnimations.clear();
    _colors.clear();
    _positions.clear();
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.trigger || _controllers.isEmpty) {
      return SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: List.generate(_controllers.length, (index) {
            return AnimatedBuilder(
              animation: _controllers[index],
              builder: (context, child) {
                return Positioned(
                  left: _positions[index].dx,
                  top: _fallAnimations[index].value,
                  child: Transform.rotate(
                    angle: _rotationAnimations[index].value,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _colors[index],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}