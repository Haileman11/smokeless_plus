import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/stat_card.dart';
import '../../widgets/common/custom_button.dart';
import '../craving_sos/craving_sos_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final localizations = AppLocalizations.of(context);
    
    if (appState.profile == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, size: 64, color: AppColors.textMuted),
              SizedBox(height: 16),
              Text(
                localizations.completeProfile,
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final stats = appState.getQuitStats();
    final isInFuture = stats['isInFuture'] ?? false;

    if (isInFuture) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, size: 80, color: AppColors.primary),
                SizedBox(height: 24),
                Text(
                  localizations.quitJourneyBeginsSoon,
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  localizations.prepareForJourney,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                localizations.welcomeBack,
                style: AppTextStyles.h2,
              ),
              SizedBox(height: 8),
              Text(
                localizations.motivationalQuote,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 32),

              // Main stats
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.primaryGradient,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      '${stats['days']} ${localizations.timeSmokeFreeDaysLabel}',
                      style: AppTextStyles.h1.copyWith(
                        color: Colors.white,
                        fontSize: 42,
                      ),
                    ),
                    Text(
                      localizations.timeSmokeFreeDays,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${stats['hours']} ${localizations.timeSmokeFreHours}',
                          style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Text(
                          '${stats['minutes']} ${localizations.timeSmokeFreMinutes}',
                          style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Emergency button
              CustomButton(
                text: localizations.emergency,
                icon: Icons.sos,
                backgroundColor: AppColors.error,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CravingSOSScreen()),
                  );
                },
                isLarge: true,
              ),
              SizedBox(height: 24),

              // Stats grid
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    title: localizations.cigarettesAvoided,
                    value: stats['cigsAvoided']?.toString() ?? '0',
                    icon: Icons.smoke_free,
                    iconColor: AppColors.success,
                  ),
                  StatCard(
                    title: localizations.moneySaved,
                    value: '${stats['currencySymbol']}${(stats['moneySaved'] ?? 0).toStringAsFixed(2)}',
                    icon: Icons.savings,
                    iconColor: AppColors.warning,
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Insight
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppColors.success, size: 28),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        appState.getPersonalizedInsight(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}