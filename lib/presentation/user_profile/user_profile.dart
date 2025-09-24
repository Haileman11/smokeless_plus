import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/language_service.dart';
import '../../services/user_data_service.dart';
import './widgets/data_export_dialog.dart';
import './widgets/language_selector_widget.dart';
import './widgets/notification_time_picker.dart';
import './widgets/profile_header_widget.dart';
import './widgets/quit_details_dialog.dart';
import './widgets/settings_section_widget.dart';

class UserProfile extends StatefulWidget {
  final Function(String)? onLanguageChanged;
  final VoidCallback? onUserDataChanged; // New callback to notify data changes

  const UserProfile({
    Key? key,
    this.onLanguageChanged,
    this.onUserDataChanged,
  }) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // Real user data loaded from persistent storage
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String _errorMessage = '';

  // Notification settings
  bool _dailyMotivation = true;
  bool _milestoneAlerts = true;
  bool _cravingReminders = false;
  bool _bedtimeEncouragement = true;
  bool _socialFeatures = true;
  bool _darkMode = false;

  TimeOfDay _motivationTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _bedtimeTime = const TimeOfDay(hour: 22, minute: 0);

  String _selectedTheme = 'Light';
  String _selectedCurrency = 'USD (\$)';
  String _selectedUnits = 'Imperial';

  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCurrentLanguage();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final userData = await UserDataService.loadUserData();

      if (userData != null) {
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'No user data found. Please complete the onboarding process.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading user data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCurrentLanguage() async {
    final language = await context.read<LanguageProvider>().currentLanguage;
    setState(() {
      _currentLanguage = language;
    });
  }

  void _handleLanguageChange(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
    });

    // Call the callback from main.dart to update app language
    if (widget.onLanguageChanged != null) {
      widget.onLanguageChanged!(languageCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                'Loading your profile...',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  _errorMessage,
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: _loadUserData,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(l10n),
            _buildProfileHeader(),
            _buildLanguageSelector(),
            _buildSettingsSection(l10n),
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return SliverToBoxAdapter(
      child: LanguageSelectorWidget(
        currentLanguage: _currentLanguage,
        onLanguageChanged: _handleLanguageChange,
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return SliverAppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      title: Text('Profile',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          )),
      
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'edit',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          onPressed: _showEditProfileDialog,
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return SliverToBoxAdapter(
      child: ProfileHeaderWidget(
        userName: _userData!["name"] as String,
        userEmail:
            "user@quitsmoking.com", // You can add email to UserDataService if needed
        avatarUrl:
            "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400", // Default avatar
        quitDate: DateTime.parse(_userData!["quitDate"] as String),
        currentStreak: _userData!["currentStreak"] as int,
      ),
    );
  }

  Widget _buildSettingsSection(AppLocalizations l10n) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          switch (index) {
            case 0:
              return SettingsSectionWidget(
                title: 'Quit Details',
                items: [
                  SettingsItem(
                    title: 'Edit Quit Information',
                    subtitle: 'Quit date, daily cigarettes, pack cost',
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: _showQuitDetailsDialog,
                  ),
                  SettingsItem(
                    title: 'Reset Progress',
                    subtitle: 'Start your journey over',
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: _showResetConfirmation,
                  ),
                ],
              );
            case 1:
              return SettingsSectionWidget(
                title: 'Notifications',
                items: [
                  SettingsItem(
                    title: 'Daily Motivation',
                    subtitle: _dailyMotivation
                        ? 'Enabled at ${_formatTime(_motivationTime)}'
                        : 'Disabled',
                    icon: CustomIconWidget(
                      iconName: 'notifications',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _dailyMotivation,
                      onChanged: (value) {
                        setState(() {
                          _dailyMotivation = value;
                        });
                      },
                    ),
                    onTap: _dailyMotivation
                        ? () => _showTimePicker(
                                'Daily Motivation', _motivationTime, (time) {
                              setState(() {
                                _motivationTime = time;
                              });
                            })
                        : null,
                  ),
                  SettingsItem(
                    title: 'Milestone Alerts',
                    subtitle: 'Celebrate your achievements',
                    icon: CustomIconWidget(
                      iconName: 'emoji_events',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _milestoneAlerts,
                      onChanged: (value) {
                        setState(() {
                          _milestoneAlerts = value;
                        });
                      },
                    ),
                  ),
                  SettingsItem(
                    title: 'Craving Reminders',
                    subtitle: 'Get tips when you need them',
                    icon: CustomIconWidget(
                      iconName: 'psychology',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _cravingReminders,
                      onChanged: (value) {
                        setState(() {
                          _cravingReminders = value;
                        });
                      },
                    ),
                  ),
                  SettingsItem(
                    title: 'Bedtime Encouragement',
                    subtitle: _bedtimeEncouragement
                        ? 'Enabled at ${_formatTime(_bedtimeTime)}'
                        : 'Disabled',
                    icon: CustomIconWidget(
                      iconName: 'bedtime',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _bedtimeEncouragement,
                      onChanged: (value) {
                        setState(() {
                          _bedtimeEncouragement = value;
                        });
                      },
                    ),
                    onTap: _bedtimeEncouragement
                        ? () => _showTimePicker(
                                'Bedtime Encouragement', _bedtimeTime, (time) {
                              setState(() {
                                _bedtimeTime = time;
                              });
                            })
                        : null,
                  ),
                ],
              );
            case 2:
              return SettingsSectionWidget(
                title: 'Privacy & Data',
                items: [
                  SettingsItem(
                    title: 'Export Data',
                    subtitle: 'Download your progress history',
                    icon: CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: _showDataExportDialog,
                  ),
                  SettingsItem(
                    title: 'Privacy Policy',
                    subtitle: 'How we protect your data',
                    icon: CustomIconWidget(
                      iconName: 'privacy_tip',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'open_in_new',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () {
                      // Open privacy policy
                    },
                  ),
                  SettingsItem(
                    title: 'Delete Account',
                    subtitle: 'Permanently remove your data',
                    icon: CustomIconWidget(
                      iconName: 'delete_forever',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: _showDeleteAccountConfirmation,
                  ),
                ],
              );
            case 3:
              return SettingsSectionWidget(
                title: 'App Preferences',
                items: [
                  SettingsItem(
                    title: 'Theme',
                    subtitle: _selectedTheme,
                    icon: CustomIconWidget(
                      iconName: 'palette',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () => _showSelectionDialog(
                      'Theme',
                      ['Light', 'Dark', 'Auto'],
                      _selectedTheme,
                      (value) {
                        setState(() {
                          _selectedTheme = value;
                        });
                      },
                    ),
                  ),
                  SettingsItem(
                    title: 'Currency',
                    subtitle: _selectedCurrency,
                    icon: CustomIconWidget(
                      iconName: 'attach_money',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () => _showSelectionDialog(
                      'Currency',
                      [
                        'USD (\$)',
                        'EUR (€)',
                        'GBP (£)',
                        'CAD (\$)',
                        'AUD (\$)'
                      ],
                      _selectedCurrency,
                      (value) {
                        setState(() {
                          _selectedCurrency = value;
                        });
                      },
                    ),
                  ),
                  SettingsItem(
                    title: 'Measurement Units',
                    subtitle: _selectedUnits,
                    icon: CustomIconWidget(
                      iconName: 'straighten',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () => _showSelectionDialog(
                      'Units',
                      ['Imperial', 'Metric'],
                      _selectedUnits,
                      (value) {
                        setState(() {
                          _selectedUnits = value;
                        });
                      },
                    ),
                  ),
                  SettingsItem(
                    title: 'Social Features',
                    subtitle: 'Share achievements and compare progress',
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _socialFeatures,
                      onChanged: (value) {
                        setState(() {
                          _socialFeatures = value;
                        });
                      },
                    ),
                  ),
                ],
              );
            case 4:
              return SettingsSectionWidget(
                title: 'Support',
                items: [
                  SettingsItem(
                    title: 'Help Center',
                    subtitle: 'FAQs and user guides',
                    icon: CustomIconWidget(
                      iconName: 'help',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'open_in_new',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () {
                      // Navigate to help center
                    },
                  ),
                  SettingsItem(
                    title: 'Contact Support',
                    subtitle: 'Get help from our team',
                    icon: CustomIconWidget(
                      iconName: 'support_agent',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'open_in_new',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () {
                      // Open contact support
                    },
                  ),
                  SettingsItem(
                    title: 'Rate App',
                    subtitle: 'Share your experience',
                    icon: CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'open_in_new',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () {
                      // Open app store rating
                    },
                  ),
                ],
              );
            default:
              return SizedBox();
          }
        },
        childCount: 5,
      ),
    );
  }

  Future<void> _showQuitDetailsDialog() async {
    final userData = await UserDataService.loadUserData();
    if (userData == null) return;

    final currentQuitDate = DateTime.parse(userData['quitDate']);
    final currentCigarettes = userData['cigarettesPerDay'] as int;
    final currentCost = userData['costPerPack'] as double;
    final currentYearsSmoking =
        userData['yearsSmoking'] as double? ?? 0.0; // Load years of smoking

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => QuitDetailsDialog(
          currentQuitDate: currentQuitDate,
          currentDailyCigarettes: currentCigarettes,
          currentPackCost: currentCost,
          currentYearsSmoking: currentYearsSmoking, // Pass years of smoking
          onSave: (newDate, newCigarettes, newCost, newYearsSmoking) async {
            // FIXED: Save all data including years of smoking
            final success = await UserDataService.saveUserData(
              quitDate: newDate,
              cigarettesPerDay: newCigarettes,
              costPerPack: newCost,
              cigarettesPerPack: 20,
              userName: userData['name'] ?? 'User',
              yearsSmoking: newYearsSmoking, // Include years of smoking in save
            );

            if (success) {
              setState(() {
                _userData = null;
              });
              await _loadUserData();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Quit details updated successfully!'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                );
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Failed to update quit details. Please try again.'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  ),
                );
              }
            }
          },
        ),
      );
    }
  }

  // Add missing _handleEditQuitDetails method
  void _handleEditQuitDetails() {
    _showQuitDetailsDialog();
  }

  Future<void> _updateUserData(DateTime quitDate, int cigarettes, double cost,
      double yearsSmoking) async {
    try {
      // Save the updated data with years of smoking
      final success = await UserDataService.saveUserData(
        quitDate: quitDate,
        cigarettesPerDay: cigarettes,
        costPerPack: cost,
        cigarettesPerPack: _userData!["cigarettesPerPack"] as int,
        userName: _userData!["name"] as String,
        yearsSmoking: yearsSmoking, // Include years of smoking
      );

      if (success) {
        // Reload the user data to reflect changes
        await _loadUserData();

        // Notify other screens that user data has changed
        if (widget.onUserDataChanged != null) {
          widget.onUserDataChanged!();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quit details updated successfully'),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          ),
        );
      } else {
        throw Exception('Failed to save data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update quit details: $e'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _showTimePicker(
      String title, TimeOfDay currentTime, Function(TimeOfDay) onTimeChanged) {
    showDialog(
      context: context,
      builder: (context) => NotificationTimePicker(
        title: title,
        currentTime: currentTime,
        onTimeChanged: onTimeChanged,
      ),
    );
  }

  void _showDataExportDialog() {
    showDialog(
      context: context,
      builder: (context) => DataExportDialog(
        onExport: (format) {
          // Handle data export based on format
          _generateExportData(format);
        },
      ),
    );
  }

  void _showSelectionDialog(String title, List<String> options,
      String currentValue, Function(String) onChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select $title',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: currentValue,
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text('Reset Progress'),
          ],
        ),
        content: Text(
          'Are you sure you want to reset your quit progress? This action cannot be undone and will clear all your achievements and statistics.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetProgress();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'delete_forever',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text('Delete Account'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will permanently delete your account and all associated data including:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              '• Quit progress and statistics\n• Achievement history\n• Personal preferences\n• All saved data',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'This action cannot be undone.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _resetProgress() async {
    try {
      // Reset quit date to today while preserving years of smoking
      final success = await UserDataService.saveUserData(
        quitDate: DateTime.now(),
        cigarettesPerDay: _userData!["cigarettesPerDay"] as int,
        costPerPack: _userData!["costPerPack"] as double,
        cigarettesPerPack: _userData!["cigarettesPerPack"] as int,
        userName: _userData!["name"] as String,
        yearsSmoking: _userData!["yearsSmoking"] as double? ??
            0.0, // Preserve years of smoking
      );

      if (success) {
        await _loadUserData();

        // Notify other screens that user data has changed
        if (widget.onUserDataChanged != null) {
          widget.onUserDataChanged!();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Progress reset successfully. You can do this!'),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset progress: $e'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _deleteAccount() async {
    try {
      // Clear all user data
      await UserDataService.clearUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Account deletion initiated. You will be logged out shortly.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );

      // Navigate back to onboarding
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/onboarding-flow',
          (route) => false,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete account: $e'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _generateExportData(String format) {
    // Use real user data for export including years of smoking
    final quitDate = DateTime.parse(_userData!["quitDate"] as String);
    final daysSinceQuit = DateTime.now().difference(quitDate).inDays;
    final moneySaved = (_userData!["moneySaved"] as double).toStringAsFixed(2);
    final yearsSmoking = (_userData!["yearsSmoking"] as double? ?? 0.0);
    final totalCigarettesSmoked =
        (_userData!["totalCigarettesSmoked"] as int? ?? 0);
    final totalMoneySpent = (_userData!["totalMoneySpent"] as double? ?? 0.0);

    String exportData = '';

    switch (format) {
      case 'PDF':
        exportData = '''
QuitSmoking Tracker - Progress Report
Generated: ${DateTime.now().toString().split('.')[0]}

User Information:
- Name: ${_userData!["name"]}
- Quit Date: ${quitDate.day}/${quitDate.month}/${quitDate.year}
- Days Smoke-Free: $daysSinceQuit
- Current Streak: ${_userData!["currentStreak"]} days

Smoking History:
- Years of Smoking: ${yearsSmoking.toStringAsFixed(1)} years
- Total Cigarettes Smoked: ${totalCigarettesSmoked.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}
- Total Money Spent on Smoking: \$${totalMoneySpent.toStringAsFixed(0)}

Financial Impact:
- Daily Cigarettes: ${_userData!["cigarettesPerDay"]}
- Pack Cost: \${(_userData!["costPerPack"] as double).toStringAsFixed(2)}
- Money Saved: \$moneySaved

Health Progress:
- Health Progress: ${((_userData!["healthProgress"] as double) * 100).toStringAsFixed(1)}%
- Health Stage: ${_userData!["healthStage"]}
- Next Milestone: ${_userData!["nextMilestone"]}
        ''';
        break;
      case 'CSV':
        exportData = '''
Date,Days Smoke-Free,Money Saved,Cigarettes Avoided,Health Progress,Years Smoked,Total Cigarettes Smoked,Total Money Spent
${DateTime.now().toString().split(' ')[0]},${_userData!["currentStreak"]},\$moneySaved,${_userData!["cigarettesAvoided"]},${((_userData!["healthProgress"] as double) * 100).toStringAsFixed(1)}%,${yearsSmoking.toStringAsFixed(1)},${totalCigarettesSmoked},\$${totalMoneySpent.toStringAsFixed(2)}
        ''';
        break;
      case 'JSON':
        exportData = '''
{
  "user": {
    "name": "${_userData!["name"]}",
    "quitDate": "${_userData!["quitDate"]}",
    "cigarettesPerDay": ${_userData!["cigarettesPerDay"]},
    "costPerPack": ${_userData!["costPerPack"]},
    "yearsSmoking": ${yearsSmoking}
  },
  "smokingHistory": {
    "totalCigarettesSmoked": ${totalCigarettesSmoked},
    "totalMoneySpent": ${totalMoneySpent},
    "smokingPeriodDays": ${(_userData!["smokingPeriodDays"] as int? ?? 0)}
  },
  "progress": {
    "currentStreak": ${_userData!["currentStreak"]},
    "moneySaved": ${_userData!["moneySaved"]},
    "cigarettesAvoided": ${_userData!["cigarettesAvoided"]},
    "healthProgress": ${_userData!["healthProgress"]},
    "healthStage": "${_userData!["healthStage"]}"
  },
  "exportDate": "${DateTime.now().toIso8601String()}"
}
        ''';
        break;
    }

    // In a real app, this would trigger actual file download
    print('Export Data ($format):\n$exportData');
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _showEditProfileDialog() {
    final TextEditingController nameController = TextEditingController(
      text: _userData!["name"] as String,
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Edit Profile',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'person_outline',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      nameController.dispose();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 3.w),
                  ElevatedButton(
                    onPressed: () async {
                      final newName = nameController.text.trim();
                      if (newName.isNotEmpty && newName != _userData!["name"]) {
                        await _updateUserName(newName);
                      }
                      nameController.dispose();
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserName(String newName) async {
    try {
      // Save the updated name while preserving all other data including years of smoking
      await UserDataService.saveUserData(
        quitDate: DateTime.parse(_userData!["quitDate"] as String),
        cigarettesPerDay: _userData!["cigarettesPerDay"] as int,
        costPerPack: _userData!["costPerPack"] as double,
        cigarettesPerPack: _userData!["cigarettesPerPack"] as int,
        userName: newName,
        yearsSmoking: _userData!["yearsSmoking"] as double? ??
            0.0, // Preserve years of smoking
      );

      // Reload the user data to reflect changes
      await _loadUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  Widget _buildOverviewCard() {
    if (_userData == null) return const SizedBox.shrink();

    final yearsSmoking = _userData!['yearsSmoking'] as double? ?? 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Quit Journey Overview',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Quit Date',
                  _formatDate(DateTime.parse(_userData!['quitDate'])),
                  'calendar_today',
                ),
              ),
              Container(
                width: 1,
                height: 4.h,
                color: AppTheme.lightTheme.colorScheme.outline,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              Expanded(
                child: _buildStatItem(
                  'Daily Cigarettes',
                  '${_userData!['cigarettesPerDay']}',
                  'smoking_rooms',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Pack Cost',
                  '\$${(_userData!['costPerPack'] as double).toStringAsFixed(2)}',
                  'attach_money',
                ),
              ),
              Container(
                width: 1,
                height: 4.h,
                color: AppTheme.lightTheme.colorScheme.outline,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              Expanded(
                child: _buildStatItem(
                  'Years Smoking',
                  '${yearsSmoking.toStringAsFixed(1)} years',
                  'schedule',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Enhanced edit button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showQuitDetailsDialog,
              icon: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              label: Text('Edit Quit Details'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildStatItem(String label, String value, String icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
