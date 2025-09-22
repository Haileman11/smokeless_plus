import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/app_state.dart';
import '../../models/craving_log.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/common/custom_button.dart';
import 'breathing_exercise_screen.dart';
import 'walk_tracker_screen.dart';
import 'memory_game_screen.dart';

class CravingSOSScreen extends StatefulWidget {
  final VoidCallback? onClose;

  const CravingSOSScreen({Key? key, this.onClose}) : super(key: key);

  @override
  _CravingSOSScreenState createState() => _CravingSOSScreenState();
}

class _CravingSOSScreenState extends State<CravingSOSScreen> {
  bool _isLogging = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                Icons.warning_amber,
                color: Colors.red.shade500,
                size: 32,
              ),
            ),
            SizedBox(height: 16),
            Text(
              localizations.cravingSOS,
              style: AppTextStyles.h2.copyWith(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              localizations.selectActivity,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),

            // Activities
            Flexible(
              child: Column(
                children: [
                  _buildActivityTile(
                    icon: Icons.air,
                    title: '4-7-8 Breathing',
                    description: 'Calm your mind in 2 minutes',
                    color: Colors.blue,
                    onTap: () => _openBreathingExercise(),
                  ),
                  SizedBox(height: 12),
                  _buildActivityTile(
                    icon: Icons.directions_walk,
                    title: '5-Minute Walk',
                    description: 'Get moving, clear your head',
                    color: Colors.green,
                    onTap: () => _openWalkTracker(),
                  ),
                  SizedBox(height: 12),
                  _buildActivityTile(
                    icon: Icons.videogame_asset,
                    title: 'Focus Game',
                    description: 'Distract with a quick puzzle',
                    color: Colors.purple,
                    onTap: () => _openMemoryGame(),
                  ),
                  SizedBox(height: 12),
                  _buildActivityTile(
                    icon: Icons.phone,
                    title: 'Call a Friend',
                    description: 'Reach out for support',
                    color: Colors.orange,
                    onTap: () => _callFriend(),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),
            
            // Close button
            CustomButton(
              text: _isLogging ? 'Logging activity...' : 'Not now',
              onPressed: _isLogging ? null : () {
                if (widget.onClose != null) {
                  widget.onClose!();
                } else {
                  Navigator.of(context).pop();
                }
              },
              backgroundColor: AppColors.textMuted,
              textColor: Colors.white,
              isLoading: _isLogging,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: _isLogging ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openBreathingExercise() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BreathingExerciseScreen(
          onComplete: () => _logActivity('breathing'),
        ),
      ),
    );
  }

  void _openWalkTracker() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalkTrackerScreen(
          onComplete: () => _logActivity('walk'),
        ),
      ),
    );
  }

  void _openMemoryGame() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MemoryGameScreen(
          onComplete: () => _logActivity('game'),
        ),
      ),
    );
  }

  void _callFriend() async {
    try {
      // Try to open phone dialer
      final Uri phoneUri = Uri.parse('tel:');
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
        _logActivity('call');
      } else {
        // Fallback: Show emergency numbers dialog
        _showEmergencyContacts();
      }
    } catch (e) {
      // Fallback: Show emergency numbers dialog
      _showEmergencyContacts();
    }
  }

  void _showEmergencyContacts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Emergency Contacts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Contact a trusted friend or family member:'),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('National Suicide Prevention Lifeline'),
              subtitle: Text('988'),
              onTap: () async {
                final Uri phoneUri = Uri.parse('tel:988');
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
    _logActivity('call');
  }

  Future<void> _logActivity(String activity) async {
    setState(() => _isLogging = true);

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final localizations = AppLocalizations.of(context);

      // Map activity string to CravingActionType
      CravingActionType? actionType;
      switch (activity) {
        case 'breathing':
          actionType = CravingActionType.breathing;
          break;
        case 'walk':
          actionType = CravingActionType.walk;
          break;
        case 'game':
          actionType = CravingActionType.game;
          break;
        case 'call':
          actionType = CravingActionType.call;
          break;
      }

      if (actionType != null) {
        await appState.addCravingLog(
          actionType,
          intensity: 3,
          triggers: ['emergency'],
          outcome: 'success',
        );
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.handledCravingPro),
          backgroundColor: AppColors.success,
        ),
      );

      // Close the dialog after a short delay
      await Future.delayed(Duration(milliseconds: 1000));
      if (widget.onClose != null) {
        widget.onClose!();
      } else {
        Navigator.of(context).pop();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log craving activity'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLogging = false);
      }
    }
  }
}