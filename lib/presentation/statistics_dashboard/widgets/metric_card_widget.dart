import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MetricCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String iconName;
  final Color? backgroundColor;
  final Color? textColor;

  const MetricCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconName,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      height: 18.h,
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor ??
                          Theme.of(context).colorScheme.onSurface
                              .withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                CustomIconWidget(
                  iconName: iconName,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color:
                        textColor ?? Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor ??
                        Theme.of(context).colorScheme.onSurface
                            .withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
