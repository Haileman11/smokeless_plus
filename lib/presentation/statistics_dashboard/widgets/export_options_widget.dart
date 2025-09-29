import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportOptionsWidget extends StatelessWidget {
  final VoidCallback onExportInfographic;
  final VoidCallback onExportCSV;
  final VoidCallback onShareStats;

  const ExportOptionsWidget({
    super.key,
    required this.onExportInfographic,
    required this.onExportCSV,
    required this.onShareStats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
          children: [
            Text(
              'Export & Share',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildExportButton(
                    'Infographic',
                    'image',
                    'Share visual progress',
                    Theme.of(context).colorScheme.primary,
                    onExportInfographic,
                    context
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildExportButton(
                    'CSV Report',
                    'table_chart',
                    'Detailed data export',
                    Theme.of(context).colorScheme.secondary,
                    onExportCSV,
                    context
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: _buildShareButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton(
    String title,
    String iconName,
    String subtitle,
    Color color,
    VoidCallback onTap,
    BuildContext context
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 12.h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 28,
              ),
              SizedBox(height: 1.h),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return GestureDetector(
      onTap: onShareStats,
      child: Container(
        height: 7.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'share',
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Share Your Progress',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
