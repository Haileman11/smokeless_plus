import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/services/notification_sevice.dart';
import 'package:smokeless_plus/services/theme_service.dart';
import 'package:smokeless_plus/utils/utils.dart';

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

  late TimeOfDay _motivationTime;
  TimeOfDay _bedtimeTime = const TimeOfDay(hour: 22, minute: 0);

  String _selectedTheme = 'Light';
  late String _selectedCurrency;
  String _selectedUnits = 'Imperial';

  late String _currentLanguage;

  @override
  void initState() {
    super.initState();
    _selectedTheme =
        context.read<ThemeProvider>().isDarkMode ? 'Dark' : 'Light';
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
          _selectedCurrency = userData['currency'] as String? ?? 'USD (\$)';
          _motivationTime = TimeOfDay(
              hour: int.parse(userData['motivationTime'].split(' ')[0]),
              minute: int.parse(userData['motivationTime'].split(' ')[1]));
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
    final language = context.read<LanguageProvider>().currentLanguage;
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                'Loading your profile...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: Theme.of(context).colorScheme.error,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  _errorMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'Profile',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'edit',
            color: Theme.of(context).colorScheme.primary,
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
                title: AppLocalizations.of(context)!.editQuitDetails,
                items: [
                  SettingsItem(
                    title: AppLocalizations.of(context)!.editQuitDetails,
                    subtitle: 'Quit date, daily cigarettes, pack cost',
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: _showQuitDetailsDialog,
                  ),
                  SettingsItem(
                    title: 'Reset Progress',
                    subtitle: 'Start your journey over',
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: Theme.of(context).colorScheme.error,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                    title: AppLocalizations.of(context)!.dailyMotivation,
                    subtitle: _dailyMotivation
                        ? 'Enabled at ${_formatTime(_motivationTime)}'
                        : 'Disabled',
                    icon: CustomIconWidget(
                      iconName: 'notifications',
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _dailyMotivation,
                      onChanged: (value) {
                        if (value) {
                          scheduleDailyReminder(_motivationTime);
                        }
                        else {
                          cancelDailyNotifications();
                        }
                        setState(() {
                          _dailyMotivation = value;
                        });
                      },
                    ),
                    onTap: _dailyMotivation
                        ? () => _showTimePicker(
                                AppLocalizations.of(context)!.dailyMotivation,
                                _motivationTime, (time) {
                              setState(() {
                                _motivationTime = time;
                                _updateUserData();
                              });
                            })
                        : null,
                  ),
                  SettingsItem(
                    title: AppLocalizations.of(context)!.milestoneAlerts,
                    subtitle: 'Celebrate your achievements',
                    icon: CustomIconWidget(
                      iconName: 'emoji_events',
                      color: Theme.of(context).colorScheme.tertiary,
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
                      color: Theme.of(context).colorScheme.secondary,
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
                      color: Theme.of(context).colorScheme.primary,
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
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: _showDataExportDialog,
                  ),
                  SettingsItem(
                    title: 'Privacy Policy',
                    subtitle: 'How we protect your data',
                    icon: CustomIconWidget(
                      iconName: 'privacy_tip',
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'open_in_new',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      color: Theme.of(context).colorScheme.error,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () => _showSelectionDialog(
                      'Theme',
                      [
                        'Light',
                        'Dark',
                      ],
                      _selectedTheme,
                      (value) {
                        setState(() {
                          _selectedTheme = value;
                          context
                              .read<ThemeProvider>()
                              .setDarkMode(value == 'Dark');
                        });
                      },
                    ),
                  ),
                  SettingsItem(
                    title: 'Currency',
                    subtitle: _selectedCurrency,
                    icon: CustomIconWidget(
                      iconName: 'attach_money',
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      (value) async {
                        await UserDataService.saveUserData(
                          quitDate:
                              DateTime.parse(_userData!["quitDate"] as String),
                          cigarettesPerDay:
                              _userData!["cigarettesPerDay"] as int,
                          costPerPack: _userData!["costPerPack"] as double,
                          currency: value,
                          cigarettesPerPack:
                              _userData!["cigarettesPerPack"] as int,
                          userName: _userData!["name"] as String,
                          yearsSmoking:
                              _userData!["yearsSmoking"] as double? ?? 0.0,
                        );
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
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onTap: () => _showSelectionDialog(
                      'Units',
                      ['Imperial', 'Metric'],
                      _selectedUnits,
                      (value) async {
                        await UserDataService.saveUserData(
                          quitDate:
                              DateTime.parse(_userData!["quitDate"] as String),
                          cigarettesPerDay:
                              _userData!["cigarettesPerDay"] as int,
                          costPerPack: _userData!["costPerPack"] as double,
                          currency: value,
                          cigarettesPerPack:
                              _userData!["cigarettesPerPack"] as int,
                          userName: _userData!["name"] as String,
                          yearsSmoking:
                              _userData!["yearsSmoking"] as double? ?? 0.0,
                        );
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
                      color: Theme.of(context).colorScheme.primary,
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
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'open_in_new',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'open_in_new',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 24,
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'open_in_new',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
          currency: _selectedCurrency,
          currentYearsSmoking: currentYearsSmoking, // Pass years of smoking
          onSave: (newDate, newCigarettes, newCost, newYearsSmoking) async {
            // FIXED: Save all data including years of smoking
            final success = await UserDataService.saveUserData(
              quitDate: newDate,
              cigarettesPerDay: newCigarettes,
              costPerPack: newCost,
              cigarettesPerPack: 20,
              currency: _selectedCurrency,
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Failed to update quit details. Please try again.'),
                    backgroundColor: Theme.of(context).colorScheme.error,
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

  Future<void> _updateUserData() async {
    try {
      // Save the updated data with years of smoking
      final success = await UserDataService.saveUserData(
        quitDate: _userData!["quitDate"],
        cigarettesPerDay:_userData!["cigarettesPerDay"],
        costPerPack: _userData!["costPerPack"],
        currency: _userData!["currency"],
        cigarettesPerPack: _userData!["cigarettesPerPack"] as int,
        userName: _userData!["name"] as String,
        yearsSmoking: _userData!["yearsSmoking"], // Include years of smoking
        motivationTime: "${_motivationTime.hour} ${_motivationTime.minute}"
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
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      } else {
        throw Exception('Failed to save data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update quit details: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
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
          generateExportData(_userData!, format);
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
          style: Theme.of(context).textTheme.titleLarge,
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
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text('Reset Progress'),
          ],
        ),
        content: Text(
          'Are you sure you want to reset your quit progress? This action cannot be undone and will clear all your achievements and statistics.',
          style: Theme.of(context).textTheme.bodyMedium,
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
              backgroundColor: Theme.of(context).colorScheme.error,
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
              color: Theme.of(context).colorScheme.error,
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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              '• Quit progress and statistics\n• Achievement history\n• Personal preferences\n• All saved data',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 2.h),
            Text(
              'This action cannot be undone.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
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
              backgroundColor: Theme.of(context).colorScheme.error,
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
        currency: _selectedCurrency,
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
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset progress: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
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
          backgroundColor: Theme.of(context).colorScheme.error,
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
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
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
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
        currency: _selectedCurrency,
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
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
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
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }
}
