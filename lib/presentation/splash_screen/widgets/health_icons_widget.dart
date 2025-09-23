import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HealthIconsWidget extends StatefulWidget {
  const HealthIconsWidget({Key? key}) : super(key: key);

  @override
  State<HealthIconsWidget> createState() => _HealthIconsWidgetState();
}

class _HealthIconsWidgetState extends State<HealthIconsWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  final List<Map<String, dynamic>> _healthIcons = [
    {'icon': 'favorite', 'color': Colors.red, 'delay': 0},
    {'icon': 'air', 'color': Colors.blue, 'delay': 200},
    {'icon': 'local_hospital', 'color': Colors.green, 'delay': 400},
    {'icon': 'psychology', 'color': Colors.purple, 'delay': 600},
  ];

  @override
  void initState() {
    super.initState();
    _controllers = [];
    _animations = [];

    for (int i = 0; i < _healthIcons.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );

      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));

      _controllers.add(controller);
      _animations.add(animation);

      Future.delayed(Duration(milliseconds: _healthIcons[i]['delay']), () {
        if (mounted) {
          controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_healthIcons.length, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _animations[index].value,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: (_healthIcons[index]['color'] as Color)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: _healthIcons[index]['icon'],
                    color: _healthIcons[index]['color'],
                    size: 6.w,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}