import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingStepWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final Widget? customContent;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final bool showSkip;
  final String buttonText;
  final bool isLastStep;

  const OnboardingStepWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.customContent,
    this.onNext,
    this.onSkip,
    this.showSkip = true,
    this.buttonText = 'Continue',
    this.isLastStep = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 4.h),
                    // Illustration
                    Container(
                      width: 80.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          imageUrl,
                          width: 80.w,
                          height: 30.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Title
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2.h),
                    // Description
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    // Custom content
                    if (customContent != null) ...[
                      customContent!,
                      SizedBox(height: 4.h),
                    ],
                  ],
                ),
              ),
            ),
            // Bottom buttons
            Column(
              children: [
                // Continue button
                SizedBox(
                  width: double.infinity,
                  // height: 6.h,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLastStep
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      buttonText,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: onNext!=null ? Colors.white : Theme.of(context).colorScheme.onSurface.withAlpha(100),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // if (showSkip) ...[
                //   SizedBox(height: 1.h),
                //   TextButton(
                //     onPressed: onSkip,
                //     child: Text(
                //       'Skip',
                //       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //         color: Theme.of(context).colorScheme.onSurfaceVariant,
                //       ),
                //     ),
                //   ),
                // ],
                // SizedBox(height: 2.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
