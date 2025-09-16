import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 100.0
  final String? label;
  final String? value;
  final Color? progressColor;
  final Color? backgroundColor;
  final double height;
  final bool showPercentage;

  const CustomProgressIndicator({
    Key? key,
    required this.progress,
    this.label,
    this.value,
    this.progressColor,
    this.backgroundColor,
    this.height = 8,
    this.showPercentage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 100.0);
    final progressFraction = clampedProgress / 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || value != null || showPercentage)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(label!, style: AppTextStyles.bodySmall),
              Row(
                children: [
                  if (value != null)
                    Text(value!, style: AppTextStyles.bodySmall),
                  if (showPercentage) ...[
                    if (value != null) SizedBox(width: 8),
                    Text(
                      '${clampedProgress.toInt()}%',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: progressColor ?? AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        if (label != null || value != null || showPercentage)
          SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progressFraction,
            backgroundColor: backgroundColor ?? AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? AppColors.primary,
            ),
            minHeight: height,
          ),
        ),
      ],
    );
  }
}

class CustomCircularProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 100.0
  final String? centerText;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;

  const CustomCircularProgressIndicator({
    Key? key,
    required this.progress,
    this.centerText,
    this.size = 120,
    this.strokeWidth = 8,
    this.progressColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 100.0);
    final progressFraction = clampedProgress / 100.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progressFraction,
              backgroundColor: backgroundColor ?? AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? AppColors.primary,
              ),
              strokeWidth: strokeWidth,
            ),
          ),
          if (centerText != null)
            Positioned.fill(
              child: Center(
                child: Text(
                  centerText!,
                  style: AppTextStyles.h4.copyWith(
                    color: progressColor ?? AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}