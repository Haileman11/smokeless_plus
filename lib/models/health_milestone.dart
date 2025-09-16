import 'package:flutter/material.dart';

class HealthMilestone {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final int minutesAfterQuit;
  final IconData icon;
  final String category;
  final Color color;
  final Color bgColor;

  HealthMilestone({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.minutesAfterQuit,
    required this.icon,
    required this.category,
    required this.color,
    required this.bgColor,
  });
}