import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementCategoryTabWidget extends StatelessWidget {
  final String title;
  final String iconName;
  final bool isSelected;
  final VoidCallback onTap;

  const AchievementCategoryTabWidget({
    Key? key,
    required this.title,
    required this.iconName,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.outline
                    .withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface
                      .withValues(alpha: 0.7),
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface
                        .withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
