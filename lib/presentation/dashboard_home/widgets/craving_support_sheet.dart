import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CravingSupportSheet extends StatefulWidget {
  const CravingSupportSheet({Key? key}) : super(key: key);

  @override
  State<CravingSupportSheet> createState() => _CravingSupportSheetState();
}

class _CravingSupportSheetState extends State<CravingSupportSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _breathingAnimation;
  bool _isBreathing = false;

  final List<Map<String, dynamic>> _supportOptions = [
    {
      "title": "Breathing Exercise",
      "subtitle": "4-7-8 technique to reduce cravings",
      "icon": "air",
      "color": Color(0xFF4CAF50),
      "action": "breathing"
    },
    {
      "title": "Motivational Quote",
      "subtitle": "Get instant encouragement",
      "icon": "psychology",
      "color": Color(0xFF2E7D8F),
      "action": "quote"
    },
    {
      "title": "Emergency Contact",
      "subtitle": "Call your support person",
      "icon": "phone",
      "color": Color(0xFFFF6B35),
      "action": "contact"
    },
    {
      "title": "Distraction Activity",
      "subtitle": "Quick 5-minute activities",
      "icon": "sports_esports",
      "color": Color(0xFF9C27B0),
      "action": "activity"
    }
  ];

  final List<String> _motivationalQuotes = [
    "Every cigarette you don't smoke is doing you good.",
    "You are stronger than your cravings.",
    "This craving will pass. You've got this!",
    "Think of how proud you'll be tomorrow.",
    "Your health is worth more than any cigarette."
  ];

  final List<String> _distractionActivities = [
    "Do 10 jumping jacks",
    "Drink a glass of water slowly",
    "Take 5 deep breaths",
    "Call a friend or family member",
    "Go for a short walk",
    "Listen to your favorite song"
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.textDisabledLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'support_agent',
                  color: AppTheme.accentLight,
                  size: 7.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Craving Support',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          if (_isBreathing)
            _buildBreathingExercise()
          else
            _buildSupportOptions(),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSupportOptions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Text(
            'Choose what helps you most right now:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ..._supportOptions.map((option) => _buildSupportOption(option)),
        ],
      ),
    );
  }

  Widget _buildSupportOption(Map<String, dynamic> option) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      child: ElevatedButton(
        onPressed: () => _handleSupportAction(option['action']),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: AppTheme.textHighEmphasisLight,
          elevation: 2,
          padding: EdgeInsets.all(4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: (option['color'] as Color).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: (option['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: option['icon'],
                  color: option['color'],
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option['title'],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    option['subtitle'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.textMediumEmphasisLight,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingExercise() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          Text(
            '4-7-8 Breathing Exercise',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Breathe in for 4, hold for 7, exhale for 8',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          AnimatedBuilder(
            animation: _breathingAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _breathingAnimation.value,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Theme.of(context).primaryColor.withValues(alpha: 0.3),
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'air',
                      color: Theme.of(context).primaryColor,
                      size: 12.w,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _startBreathing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                ),
                child: Text(
                  'Start',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.onPrimaryLight,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () => setState(() => _isBreathing = false),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                ),
                child: Text('Back'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSupportAction(String action) {
    switch (action) {
      case 'breathing':
        setState(() => _isBreathing = true);
        break;
      case 'quote':
        _showMotivationalQuote();
        break;
      case 'contact':
        _showEmergencyContact();
        break;
      case 'activity':
        _showDistractionActivity();
        break;
    }
  }

  void _startBreathing() {
    _animationController.repeat();
  }

  void _showMotivationalQuote() {
    final quote = (_motivationalQuotes..shuffle()).first;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'psychology',
              color: Theme.of(context).primaryColor,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text('You\'ve Got This!'),
          ],
        ),
        content: Text(
          quote,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontStyle: FontStyle.italic,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Thank You'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyContact() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'phone',
              color: AppTheme.accentLight,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text('Emergency Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Call your support person or quitline:'),
            SizedBox(height: 2.h),
            ElevatedButton.icon(
              onPressed: () {},
              icon: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.onPrimaryLight,
                size: 5.w,
              ),
              label: Text('1-800-QUIT-NOW'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentLight,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDistractionActivity() {
    final activity = (_distractionActivities..shuffle()).first;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'sports_esports',
              color: Color(0xFF9C27B0),
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text('Quick Activity'),
          ],
        ),
        content: Text(
          activity,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done!'),
          ),
        ],
      ),
    );
  }
}
