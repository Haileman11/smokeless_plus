import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:smokeless_plus/models/coping_strategies.dart';

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

  late final List<CopingStrategy> _copingStrategies;
  
@override
void didChangeDependencies() {
  super.didChangeDependencies();

  _copingStrategies = [
    {
      "id": 1,
      "title": AppLocalizations.of(context)!.coping_drink_water_title,
      "description":
          AppLocalizations.of(context)!.coping_drink_water_description,
      "icon": "local_drink",
      "color": 0xFF2196F3,
      "duration": AppLocalizations.of(context)!.coping_drink_water_duration,
      "effectiveness": "High"
    },
    {
      "id": 2,
      "title": AppLocalizations.of(context)!.coping_take_a_walk_title,
      "description":
          AppLocalizations.of(context)!.coping_take_a_walk_description,
      "icon": "directions_walk",
      "color": 0xFF4CAF50,
      "duration": AppLocalizations.of(context)!.coping_take_a_walk_duration,
      "effectiveness": "Very High"
    },
    {
      "id": 3,
      "title": AppLocalizations.of(context)!.coping_call_a_friend_title,
      "description":
          AppLocalizations.of(context)!.coping_call_a_friend_description,
      "icon": "phone",
      "color": 0xFFFF9800,
      "duration": AppLocalizations.of(context)!.coping_call_a_friend_duration,
      "effectiveness": "High"
    },
    {
      "id": 4,
      "title": AppLocalizations.of(context)!.coping_review_reasons_title,
      "description":
          AppLocalizations.of(context)!.coping_review_reasons_description,
      "icon": "favorite",
      "color": 0xFFE91E63,
      "duration": AppLocalizations.of(context)!.coping_review_reasons_duration,
      "effectiveness": "Very High"
    },
    {
      "id": 5,
      "title": AppLocalizations.of(context)!.coping_deep_breathing_title,
      "description":
          AppLocalizations.of(context)!.coping_deep_breathing_description,
      "icon": "air",
      "color": 0xFF9C27B0,
      "duration": AppLocalizations.of(context)!.coping_deep_breathing_duration,
      "effectiveness": "High"
    },
    {
      "id": 6,
      "title": AppLocalizations.of(context)!.coping_chew_gum_title,
      "description":
          AppLocalizations.of(context)!.coping_chew_gum_description,
      "icon": "bubble_chart",
      "color": 0xFF00BCD4,
      "duration": AppLocalizations.of(context)!.coping_chew_gum_duration,
      "effectiveness": "Medium"
    },
    {
      "id": 7,
      "title": AppLocalizations.of(context)!.coping_listen_music_title,
      "description":
          AppLocalizations.of(context)!.coping_listen_music_description,
      "icon": "music_note",
      "color": 0xFF795548,
      "duration": AppLocalizations.of(context)!.coping_listen_music_duration,
      "effectiveness": "Medium"
    },
    {
      "id": 8,
      "title": AppLocalizations.of(context)!.coping_gratitude_title,
      "description":
          AppLocalizations.of(context)!.coping_gratitude_description,
      "icon": "sentiment_very_satisfied",
      "color": 0xFFFFEB3B,
      "duration": AppLocalizations.of(context)!.coping_gratitude_duration,
      "effectiveness": "High"
    },
  ].map( (e) => CopingStrategy.fromMap(e)).toList();
}

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
        return Theme.of(context).colorScheme.secondary;
      case 'high':
        return Theme.of(context).colorScheme.primary;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,      
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
                  AppLocalizations.of(context)!.quickCopingTips,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${_copingStrategies.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
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
                      padding: EdgeInsets.symmetric( horizontal: 4.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(strategy.color)
                                .withValues(alpha: 0.1),
                            Theme.of(context).colorScheme.surface,
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
                                  color: Color(strategy.color)
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: CustomIconWidget(
                                  iconName: strategy.icon,
                                  color: Color(strategy.color),
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      strategy.title,
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
                                                    strategy.effectiveness)
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            strategy.effectiveness,
                                            style: AppTheme
                                                .lightTheme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: _getEffectivenessColor(
                                                  strategy.effectiveness),                                                      
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
                                          strategy.duration,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: Theme.of(context)
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
                            strategy.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
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
                                      AppLocalizations.of(context)!.greatCopingStrategyChoice(strategy.title),
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
                                    Color(strategy.color),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.tryThisNow,
                                style: Theme.of(context).textTheme.titleSmall
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
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface
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
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface
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
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface
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
