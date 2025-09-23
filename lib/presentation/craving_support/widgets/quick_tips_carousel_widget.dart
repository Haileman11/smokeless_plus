import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickTipsCarouselWidget extends StatefulWidget {
  const QuickTipsCarouselWidget({Key? key}) : super(key: key);

  @override
  State<QuickTipsCarouselWidget> createState() =>
      _QuickTipsCarouselWidgetState();
}

class _QuickTipsCarouselWidgetState extends State<QuickTipsCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _copingStrategies = [
    {
      "id": 1,
      "title": "Drink Water",
      "description":
          "Hydrate your body and keep your hands busy. Water helps flush toxins and reduces cravings.",
      "icon": "local_drink",
      "color": 0xFF2196F3,
      "duration": "2-3 minutes",
      "effectiveness": "High"
    },
    {
      "id": 2,
      "title": "Take a Walk",
      "description":
          "Get moving! Physical activity releases endorphins and distracts from cravings.",
      "icon": "directions_walk",
      "color": 0xFF4CAF50,
      "duration": "5-10 minutes",
      "effectiveness": "Very High"
    },
    {
      "id": 3,
      "title": "Call a Friend",
      "description":
          "Reach out for support. Talking to someone can provide motivation and distraction.",
      "icon": "phone",
      "color": 0xFFFF9800,
      "duration": "5-15 minutes",
      "effectiveness": "High"
    },
    {
      "id": 4,
      "title": "Review Your Reasons",
      "description":
          "Remember why you decided to quit. Focus on your health, family, and financial goals.",
      "icon": "favorite",
      "color": 0xFFE91E63,
      "duration": "3-5 minutes",
      "effectiveness": "Very High"
    },
    {
      "id": 5,
      "title": "Deep Breathing",
      "description":
          "Practice slow, deep breaths. Inhale for 4, hold for 4, exhale for 4 seconds.",
      "icon": "air",
      "color": 0xFF9C27B0,
      "duration": "2-5 minutes",
      "effectiveness": "High"
    },
    {
      "id": 6,
      "title": "Chew Gum",
      "description":
          "Keep your mouth busy with sugar-free gum. It helps with oral fixation habits.",
      "icon": "bubble_chart",
      "color": 0xFF00BCD4,
      "duration": "Ongoing",
      "effectiveness": "Medium"
    },
    {
      "id": 7,
      "title": "Listen to Music",
      "description":
          "Put on your favorite playlist. Music can improve mood and provide distraction.",
      "icon": "music_note",
      "color": 0xFF795548,
      "duration": "3-10 minutes",
      "effectiveness": "Medium"
    },
    {
      "id": 8,
      "title": "Practice Gratitude",
      "description":
          "Think of three things you're grateful for. Positive thinking reduces stress and cravings.",
      "icon": "sentiment_very_satisfied",
      "color": 0xFFFFEB3B,
      "duration": "2-3 minutes",
      "effectiveness": "High"
    }
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextTip() {
    if (_currentIndex < _copingStrategies.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousTip() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Color _getEffectivenessColor(String effectiveness) {
    switch (effectiveness.toLowerCase()) {
      case 'very high':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'high':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quick Coping Tips',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${_copingStrategies.length}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Carousel
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _copingStrategies.length,
              itemBuilder: (context, index) {
                final strategy = _copingStrategies[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(strategy["color"] as int)
                                .withValues(alpha: 0.1),
                            AppTheme.lightTheme.colorScheme.surface,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon and title
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: Color(strategy["color"] as int)
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: CustomIconWidget(
                                  iconName: strategy["icon"] as String,
                                  color: Color(strategy["color"] as int),
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      strategy["title"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.w, vertical: 0.5.h),
                                          decoration: BoxDecoration(
                                            color: _getEffectivenessColor(
                                                    strategy["effectiveness"]
                                                        as String)
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            strategy["effectiveness"] as String,
                                            style: AppTheme
                                                .lightTheme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: _getEffectivenessColor(
                                                  strategy["effectiveness"]
                                                      as String),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        CustomIconWidget(
                                          iconName: 'schedule',
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                          size: 14,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          strategy["duration"] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 3.h),

                          // Description
                          Text(
                            strategy["description"] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              height: 1.5,
                            ),
                          ),

                          const Spacer(),

                          // Action button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Log the selected coping strategy
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Great choice! "${strategy["title"]}" is an effective coping strategy.',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    backgroundColor: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color(strategy["color"] as int),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Try This Now',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Navigation controls
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _currentIndex > 0 ? _previousTip : null,
                  icon: CustomIconWidget(
                    iconName: 'arrow_back_ios',
                    color: _currentIndex > 0
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.3),
                    size: 20,
                  ),
                ),

                // Page indicators
                Row(
                  children: List.generate(
                    _copingStrategies.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      width: _currentIndex == index ? 3.w : 2.w,
                      height: _currentIndex == index ? 3.w : 2.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: _currentIndex < _copingStrategies.length - 1
                      ? _nextTip
                      : null,
                  icon: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: _currentIndex < _copingStrategies.length - 1
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.3),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
