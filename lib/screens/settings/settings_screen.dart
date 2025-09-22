import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smokeless_plus/services/theme_service.dart';
import '../../services/app_state.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection
            _buildSettingsSection(
              context: context,
              title: localizations.language,
              children: [
                _buildLanguageTile(
                  context,
                  appState,
                  'en',
                  localizations.english,
                  '🇺🇸',
                ),
                _buildLanguageTile(
                  context,
                  appState,
                  'fr',
                  localizations.french,
                  '🇫🇷',
                ),
                _buildLanguageTile(
                  context,
                  appState,
                  'es',
                  localizations.spanish,
                  '🇪🇸',
                ),
                _buildLanguageTile(
                  context,
                  appState,
                  'ar',
                  localizations.arabic,
                  '🇸🇦',
                ),
              ],
            ),
            SizedBox(height: 32),

            // Data Management
            _buildSettingsSection(
              context: context,
              title: 'Data Management',
              children: [
                _buildSettingsTile(
                  icon: Icons.download,
                  title: localizations.exportData,
                  subtitle: 'Export your data as JSON',
                  onTap: () => _showComingSoonDialog(context),
                  context: context
                ),
                _buildSettingsTile(
                  icon: Icons.delete_forever,
                  title: localizations.clearData,
                  subtitle: 'Delete all app data',
                  textColor: AppColors.error,
                  onTap: () => _showClearDataDialog(context, appState),
                  context: context
                ),
              ],
            ),
            SizedBox(height: 32),

            // About
            _buildSettingsSection(
              context: context,
              title: localizations.about,
              children: [
                _buildSettingsTile(
                  icon: Icons.info_outline,
                  title: localizations.version,
                  subtitle: '1.0.0',
                  onTap: null,
                  context: context
                ),
                _buildSettingsTile(
                  icon: Icons.code,
                  title: 'Open Source',
                  subtitle: 'Built with Flutter',
                  onTap: null,
                  context: context
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
    required BuildContext context,
  }) {
    final themeService = Provider.of<ThemeService>(context);
    final textColor = themeService.isDarkMode ? AppColors.background : AppColors.textPrimary;
    final cardColor = themeService.isDarkMode ? AppColors.darkCard : AppColors.lightCard;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h4.copyWith(color: textColor)),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    final themeService = Provider.of<ThemeService>(context);
    final textThemeColor = themeService.isDarkMode ? AppColors.background : AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.textSecondary),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(color: textColor?? textThemeColor),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTextStyles.bodySmall)
          : null,
      trailing: onTap != null
          ? Icon(Icons.chevron_right, color: AppColors.textMuted)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    AppState appState,
    String languageCode,
    String languageName,
    String flag,
  ) {
    final isSelected = appState.currentLanguage == languageCode;
    final themeService = Provider.of<ThemeService>(context);
    final textColor = themeService.isDarkMode ? AppColors.background : AppColors.textPrimary;
    return ListTile(
      leading: Text(flag, style: TextStyle(fontSize: 24)),
      title: Text(languageName, style: AppTextStyles.bodyMedium.copyWith(color: textColor)),
      trailing: isSelected
          ? Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () async {
        await appState.changeLanguage(languageCode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).languageChanged),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Coming Soon'),
        content: Text('This feature will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Data'),
        content: Text(
          'Are you sure you want to delete all your data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await appState.clearAllData();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All data has been cleared'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}