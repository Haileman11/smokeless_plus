import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturePreviewWidget extends StatelessWidget {
  const FeaturePreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        "title": "Progress Tracking",
        "description":
            "Monitor your smoke-free journey with detailed statistics",
        "icon": "trending_up",
        "color": Theme.of(context).colorScheme.primary,
        "route": "/progress-tracking",
      },
      {
        "title": "Health Milestones",
        "description": "See how your body recovers over time",
        "icon": "favorite",
        "color": Theme.of(context).colorScheme.secondary,
        "route": "/health-milestones",
      },
      {
        "title": "Achievement System",
        "description": "Earn badges and rewards for your progress",
        "icon": "emoji_events",
        "color": Theme.of(context).colorScheme.tertiary,
        "route": "/achievement-system",
      },
      {
        "title": "Craving Support",
        "description": "Get instant help when you need it most",
        "icon": "support_agent",
        "color": Theme.of(context).colorScheme.primary,
        "route": "/craving-support",
      },
    ];

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 0.85,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return _buildFeatureCard(
              context: context,
              title: feature["title"] as String,
              description: feature["description"] as String,
              iconName: feature["icon"] as String,
              color: feature["color"] as Color,
              route: feature["route"] as String,
            );
          },
        ),
        SizedBox(height: 3.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'info',
                  color: Colors.white,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tap any feature to explore',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Get a preview of what awaits you',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String description,
    required String iconName,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        // Show preview dialog
        _showFeaturePreview(
            context, title, description, iconName, color, route);
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 8.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showFeaturePreview(
    BuildContext context,
    String title,
    String description,
    String iconName,
    Color color,
    String route,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 12.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Close',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, route);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Explore',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
