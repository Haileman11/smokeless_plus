import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/craving_log.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/custom_button.dart';

class CravingSOSScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.cravingSOS,
          style: AppTextStyles.h3,
        ),
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.error, AppColors.error.withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 32),
                Icon(
                  Icons.sos,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 24),
                Text(
                  'Need Help Right Now?',
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  localizations.selectActivity,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48),
                Expanded(
                  child: Column(
                    children: [
                      _buildActivityCard(
                        context,
                        icon: Icons.air,
                        title: localizations.breathingExercise,
                        description: 'Deep breathing helps reduce stress and distract from cravings',
                        action: CravingActionType.breathing,
                      ),
                      SizedBox(height: 16),
                      _buildActivityCard(
                        context,
                        icon: Icons.directions_walk,
                        title: localizations.walkingExercise,
                        description: 'Physical activity releases endorphins and reduces cravings',
                        action: CravingActionType.walk,
                      ),
                      SizedBox(height: 16),
                      _buildActivityCard(
                        context,
                        icon: Icons.games,
                        title: localizations.playGame,
                        description: 'Mental challenges redirect your focus away from smoking',
                        action: CravingActionType.game,
                      ),
                      SizedBox(height: 16),
                      _buildActivityCard(
                        context,
                        icon: Icons.phone,
                        title: 'Call Support',
                        description: 'Talk to someone who understands your journey',
                        action: CravingActionType.call,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required CravingActionType action,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _handleActivitySelection(context, action),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Icon(icon, size: 48, color: AppColors.primary),
            SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleActivitySelection(BuildContext context, CravingActionType action) async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    // Log the craving activity
    await appState.addCravingLog(action);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Great job! 🎉 You handled that craving like a pro.'),
        backgroundColor: AppColors.success,
      ),
    );
    
    // Navigate back
    Navigator.of(context).pop();
  }
}