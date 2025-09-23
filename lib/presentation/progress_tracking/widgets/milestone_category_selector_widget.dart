import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MilestoneCategorySelectorWidget extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const MilestoneCategorySelectorWidget({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'id': 'All',
        'label': 'All Milestones',
        'icon': 'view_list',
        'description': 'Show all health milestones',
      },
      {
        'id': 'Short-Term',
        'label': 'Short-Term',
        'icon': 'schedule',
        'description': '20 min - 48 hours',
      },
      {
        'id': 'Medium-Term',
        'label': 'Medium-Term',
        'icon': 'trending_up',
        'description': '2 weeks - 9 months',
      },
      {
        'id': 'Long-Term',
        'label': 'Long-Term',
        'icon': 'military_tech',
        'description': '1-10+ years',
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Milestone Categories',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  categories.map((category) {
                    final isSelected = selectedCategory == category['id'];
                    return Container(
                      margin: EdgeInsets.only(right: 3.w),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            onCategoryChanged(category['id'] as String);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.5.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme.lightTheme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppTheme.lightTheme.primaryColor
                                        : AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .outline
                                            .withValues(alpha: 0.2),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: AppTheme
                                              .lightTheme
                                              .primaryColor
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                      : [
                                        BoxShadow(
                                          color: AppTheme
                                              .lightTheme
                                              .colorScheme
                                              .shadow
                                              .withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconWidget(
                                      iconName: category['icon'] as String,
                                      color:
                                          isSelected
                                              ? AppTheme
                                                  .lightTheme
                                                  .colorScheme
                                                  .onPrimary
                                              : AppTheme
                                                  .lightTheme
                                                  .primaryColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      category['label'] as String,
                                      style: AppTheme
                                          .lightTheme
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                isSelected
                                                    ? AppTheme
                                                        .lightTheme
                                                        .colorScheme
                                                        .onPrimary
                                                    : AppTheme
                                                        .lightTheme
                                                        .colorScheme
                                                        .onSurface,
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  category['description'] as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                        color:
                                            isSelected
                                                ? AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onPrimary
                                                    .withValues(alpha: 0.8)
                                                : AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.6),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
