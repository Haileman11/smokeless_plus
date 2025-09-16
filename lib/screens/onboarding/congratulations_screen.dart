import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/custom_button.dart';
import '../../l10n/app_localizations.dart';

class CongratulationsScreen extends StatelessWidget {
  final String reason;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CongratulationsScreen({
    Key? key,
    required this.reason,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.successGradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.celebration,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 32),
              Text(
                localizations.congratulations,
                style: AppTextStyles.h1.copyWith(
                  fontSize: 36,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                localizations.healthyChoice,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getReasonIcon(reason),
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 12),
                    Text(
                      _getReasonMessage(reason),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Spacer(),
              CustomButton(
                text: localizations.setupProfile,
                onPressed: onNext,
                backgroundColor: Colors.white,
                textColor: AppColors.success,
                isLarge: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getReasonIcon(String reason) {
    switch (reason) {
      case 'health':
        return Icons.favorite;
      case 'money':
        return Icons.savings;
      case 'family':
        return Icons.family_restroom;
      case 'freedom':
        return Icons.flight_takeoff;
      case 'fitness':
        return Icons.fitness_center;
      case 'child':
        return Icons.child_care;
      default:
        return Icons.star;
    }
  }

  String _getReasonMessage(String reason) {
    switch (reason) {
      case 'health':
        return 'Your body will thank you for this decision. Every day smoke-free is a step toward better health!';
      case 'money':
        return 'Think of all the amazing things you can do with the money you\'ll save!';
      case 'family':
        return 'Your family will be so proud of you for taking this important step.';
      case 'freedom':
        return 'True freedom means not being controlled by cigarettes. You\'re on your way!';
      case 'fitness':
        return 'Your lungs and stamina will improve dramatically. Feel the difference!';
      case 'child':
        return 'You\'re setting an amazing example and creating a healthier future for your children.';
      default:
        return 'This is the beginning of an amazing transformation!';
    }
  }
}