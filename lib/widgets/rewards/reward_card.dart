import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/reward.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../constants/currencies.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;

  const RewardCard({Key? key, required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final localizations = AppLocalizations.of(context);
    final stats = appState.getQuitStats();
    final moneySaved = stats['moneySaved'] ?? 0.0;
    final canAfford = moneySaved >= reward.costAmount;
    final currencySymbol = currencySymbols[reward.currency] ?? reward.currency;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: reward.isRedeemed ? AppColors.success.withOpacity(0.1) : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: reward.isRedeemed ? AppColors.success : 
                 canAfford ? AppColors.primary : AppColors.border,
          width: reward.isRedeemed || canAfford ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: reward.isRedeemed ? AppColors.success.withOpacity(0.2) :
                         canAfford ? AppColors.primary.withOpacity(0.1) : AppColors.border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  reward.isRedeemed ? Icons.check_circle : Icons.card_giftcard,
                  color: reward.isRedeemed ? AppColors.success :
                         canAfford ? AppColors.primary : AppColors.textMuted,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.title,
                      style: AppTextStyles.h4.copyWith(
                        color: reward.isRedeemed ? AppColors.success : AppColors.textPrimary,
                        decoration: reward.isRedeemed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$currencySymbol${reward.costAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (reward.isRedeemed)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Redeemed',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (!reward.isRedeemed) ...[
            SizedBox(height: 16),
            if (canAfford)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showRedeemDialog(context, reward),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(localizations.redeem),
                ),
              )
            else
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.savings, color: AppColors.warning, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Save ${currencySymbol}${(reward.costAmount - moneySaved).toStringAsFixed(2)} more to unlock',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (reward.isRedeemed) ...[
            SizedBox(height: 12),
            Text(
              'Redeemed on ${_formatDate(reward.redeemedAt!)}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  void _showRedeemDialog(BuildContext context, Reward reward) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.congratulationsReward),
        content: Text(localizations.enjoyReward),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final appState = Provider.of<AppState>(context, listen: false);
              await appState.redeemReward(reward.id);
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🎉 Reward redeemed! Enjoy it!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(localizations.redeem),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}