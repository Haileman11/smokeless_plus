import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/services/user_data_service.dart';
import 'package:smokeless_plus/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import './widgets/breathing_exercise_widget.dart';
import './widgets/distraction_games_widget.dart';
import './widgets/quick_tips_carousel_widget.dart';

class CravingSupport extends StatefulWidget {
  const CravingSupport({Key? key}) : super(key: key);

  @override
  State<CravingSupport> createState() => _CravingSupportState();
}

class _CravingSupportState extends State<CravingSupport>
    with TickerProviderStateMixin {
  bool _showBreathingExercise = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "quitDate": DateTime.now().subtract(const Duration(days: 15)),
    "cigarettesNotSmoked": 225,
    "moneySaved": 67.50,
    "currentStreak": 15,
    "dailyCigarettePrice": 4.50,
  };

  // Mock craving session data
  late final List<Map<String, dynamic>> _cravingSessions;

  @override
  void initState() {
    super.initState();
    _initializePulseAnimation();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cravingSessions = [
      {
        "id": 1,
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
        "method": AppLocalizations.of(context)!.breathingExercise,
        "duration": 5,
      "intensity": "Medium",
      "success": true,
    },
    {
      "id": 2,
      "timestamp": DateTime.now().subtract(const Duration(hours: 8)),
      "method": AppLocalizations.of(context)!.callSupport,
      "duration": 12,
      "intensity": "High",
      "success": true,
    },
    {
      "id": 3,
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "method": AppLocalizations.of(context)!.distractionGames,
      "duration": 7,
      "intensity": "Low",
      "success": true,
    },
  ];
  }

  void _initializePulseAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startBreathingExercise() {
    HapticFeedback.mediumImpact();
    setState(() {
      _showBreathingExercise = true;
    });
  }

  void _closeBreathingExercise() {
    setState(() {
      _showBreathingExercise = false;
    });

    // Log the session
    _logCravingSession('Breathing Exercise');
  }

  void _callSupport() async {
    HapticFeedback.lightImpact();

    // Show support options
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSupportOptionsSheet(),
    );
  }

  void _viewProgress() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/progress-tracking');
  }

  void _logCravingSession(String method) {
    // In a real app, this would save to database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.cravingSessionLogged(method),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildSupportOptionsSheet() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            AppLocalizations.of(context)!.getSupport,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),

          // Quitline option
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'phone',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'National Quitline',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              '1-800-QUIT-NOW (Free & Confidential)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              final Uri phoneUri = Uri(scheme: 'tel', path: '1-800-784-8669');
              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              }
              _logCravingSession('Call Support');
            },
          ),

          Divider(height: 3.h),

          // Emergency contact option
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'contact_phone',
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.callEmergencyContact,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.reachOutToYourDesignatedContact,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
            onTap: () async {
              final userData = await UserDataService.loadUserData();
              callNumber(userData?["emergencyContact"]);
              // Navigator.pop(context);
              // In a real app, this would call the user's designated emergency contact
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.callingEmergencyContact),
                  action: SnackBarAction(
                    label: AppLocalizations.of(context)!.settings,
                    onPressed: () =>
                        Navigator.pushNamed(context, '/user-profile'),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildMotivationBanner() {
    final daysSinceQuit =
        DateTime.now().difference(_userData["quitDate"] as DateTime).inDays;

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.youreDoingGreat,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      AppLocalizations.of(context)!.daysSinceQuit(daysSinceQuit),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'emoji_events',
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 32,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '\$${(_userData["moneySaved"] as double).toStringAsFixed(2)}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.moneySaved,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${_userData["cigarettesNotSmoked"]}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.notSmoked,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Primary action buttons
          Row(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: ElevatedButton(
                        onPressed: _startBreathingExercise,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Column(
                          children: [
                            CustomIconWidget(
                              iconName: 'air',
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 28,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              AppLocalizations.of(context)!.breathingExercise,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _callSupport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'phone',
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: 28,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        AppLocalizations.of(context)!.callSupport,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.w),

          // Secondary action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _viewProgress,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'trending_up',
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        AppLocalizations.of(context)!.viewProgress,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _logCravingSession(AppLocalizations.of(context)!.distractionGames);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'games',
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 28,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        AppLocalizations.of(context)!.distractionGames,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showBreathingExercise) {
      return Scaffold(
        body: BreathingExerciseWidget(
          onClose: _closeBreathingExercise,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.cravingSupport,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/statistics-dashboard');
            },
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Motivation banner
              _buildMotivationBanner(),

              SizedBox(height: 2.h),

              // Emergency message
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.tertiary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.havingACraving,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Action buttons
              _buildActionButtons(),

              SizedBox(height: 4.h),

              // Quick tips carousel
              const QuickTipsCarouselWidget(),

              SizedBox(height: 3.h),

              // Distraction games
              const DistractionGamesWidget(),

              SizedBox(height: 3.h),

              // Recent sessions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.recentCopingSessions,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _cravingSessions.length > 3
                          ? 3
                          : _cravingSessions.length,
                      itemBuilder: (context, index) {
                        final session = _cravingSessions[index];
                        final timestamp = session["timestamp"] as DateTime;
                        final timeAgo = DateTime.now().difference(timestamp);

                        String timeAgoText;
                        if (timeAgo.inDays > 0) {
                          timeAgoText = '${timeAgo.inDays}d ago';
                        } else if (timeAgo.inHours > 0) {
                          timeAgoText = '${timeAgo.inHours}h ago';
                        } else {
                          timeAgoText = '${timeAgo.inMinutes}m ago';
                        }

                        return Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'check_circle',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      session["method"] as String,
                                      style: Theme.of(context).textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      '${session["duration"]} min • ${session["intensity"]} intensity',
                                      style: Theme.of(context).textTheme.bodySmall
                                          ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                timeAgoText,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startBreathingExercise,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'air',
          color: Theme.of(context).colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          AppLocalizations.of(context)!.quickBreathe,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
