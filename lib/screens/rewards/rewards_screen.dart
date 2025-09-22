import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smokeless_plus/services/theme_service.dart';
import '../../services/app_state.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/rewards/reward_card.dart';

class RewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final localizations = AppLocalizations.of(context);
final themeService = Provider.of<ThemeService>(context);
    final textColor = themeService.isDarkMode ? AppColors.background : AppColors.textPrimary;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     localizations.yourRewards,
      //     style: AppTextStyles.h3.copyWith(color: textColor),
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   foregroundColor: AppColors.textPrimary,
      // ),
      body: appState.profile == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.card_giftcard_outlined, size: 64, color: AppColors.textMuted),
                  SizedBox(height: 16),
                  Text(
                    localizations.completeProfile,
                    style: AppTextStyles.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Money saved display
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.successGradient,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          localizations.moneySavedSoFar,
                          style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _getFormattedMoneySaved(appState),
                          style: AppTextStyles.h1.copyWith(
                            color: Colors.white,
                            fontSize: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Add reward button
                  CustomButton(
                    text: localizations.addReward,
                    icon: Icons.add,
                    onPressed: () => _showAddRewardDialog(context),
                    isLarge: true,
                  ),
                  SizedBox(height: 24),

                  // Rewards list
                  if (appState.rewards.isEmpty)
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Icon(Icons.card_giftcard_outlined, size: 64, color: AppColors.textMuted),
                          SizedBox(height: 16),
                          Text(
                            'No rewards yet',
                            style: AppTextStyles.h4.copyWith(color: AppColors.textMuted),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add your first reward to celebrate your progress!',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: appState.rewards.length,
                      separatorBuilder: (context, index) => SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final reward = appState.rewards[index];
                        return RewardCard(reward: reward);
                      },
                    ),
                ],
              ),
            ),
    );
  }

  String _getFormattedMoneySaved(AppState appState) {
    final stats = appState.getQuitStats();
    if (stats.isEmpty) return '\$0.00';
    
    final currencySymbol = stats['currencySymbol'] ?? '\$';
    final moneySaved = stats['moneySaved'] ?? 0.0;
    return '$currencySymbol${moneySaved.toStringAsFixed(2)}';
  }

  void _showAddRewardDialog(BuildContext context) {
    final titleController = TextEditingController();
    final costController = TextEditingController();
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.addNewReward),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: localizations.whatsYourReward,
                hintText: localizations.rewardPlaceholder,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: costController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: localizations.howMuchCost,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && costController.text.isNotEmpty) {
                final appState = Provider.of<AppState>(context, listen: false);
                final cost = double.tryParse(costController.text) ?? 0.0;
                final currency = appState.profile?.currency ?? 'USD';
                
                await appState.addReward(titleController.text, cost, currency);
                
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.rewardCreated),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: Text(localizations.save),
          ),
        ],
      ),
    );
  }
}