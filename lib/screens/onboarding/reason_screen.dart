import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/custom_button.dart';
import '../../l10n/app_localizations.dart';

class ReasonScreen extends StatefulWidget {
  final Function(String) onNext;
  final VoidCallback onBack;

  const ReasonScreen({Key? key, required this.onNext, required this.onBack}) : super(key: key);

  @override
  _ReasonScreenState createState() => _ReasonScreenState();
}

class _ReasonScreenState extends State<ReasonScreen> {
  String? selectedReason;

  final List<Map<String, dynamic>> reasons = [
    {'value': 'health', 'icon': Icons.favorite},
    {'value': 'money', 'icon': Icons.savings},
    {'value': 'family', 'icon': Icons.family_restroom},
    {'value': 'fitness', 'icon': Icons.fitness_center},
    {'value': 'freedom', 'icon': Icons.flight_takeoff},
    {'value': 'child', 'icon': Icons.child_care},
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.primaryGradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              SizedBox(height: 40),
              Text(
                localizations.whyQuitting,
                style: AppTextStyles.h2.copyWith(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Understanding your motivation helps us personalize your journey',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  itemCount: reasons.length,
                  itemBuilder: (context, index) {
                    final reason = reasons[index];
                    final isSelected = selectedReason == reason['value'];
                    
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => setState(() => selectedReason = reason['value']),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  reason['icon'],
                                  color: isSelected ? AppColors.primary : Colors.white,
                                  size: 28,
                                ),
                                SizedBox(width: 16),
                                Text(
                                  _getLocalizedReasonTitle(localizations, reason['value']),
                                  style: AppTextStyles.h4.copyWith(
                                    color: isSelected ? AppColors.primary : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              CustomButton(
                text: localizations.next,
                onPressed: selectedReason != null
                    ? () => widget.onNext(selectedReason!)
                    : null,
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
                isLarge: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedReasonTitle(AppLocalizations localizations, String reason) {
    switch (reason) {
      case 'health':
        return localizations.reasonHealth;
      case 'money':
        return localizations.reasonMoney;
      case 'family':
        return localizations.reasonFamily;
      case 'freedom':
        return localizations.reasonFreedom;
      case 'fitness':
        return 'Better fitness';
      case 'child':
        return 'For my children';
      default:
        return reason;
    }
  }
}