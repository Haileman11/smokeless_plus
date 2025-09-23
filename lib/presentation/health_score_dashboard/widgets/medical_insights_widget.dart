import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicalInsightsWidget extends StatelessWidget {
  final int currentStreak;
  final double yearsSmoking;

  const MedicalInsightsWidget({
    Key? key,
    required this.currentStreak,
    required this.yearsSmoking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final insights = _generatePersonalizedInsights();
    final upcomingMilestones = _getUpcomingMilestones();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor.withAlpha(26),
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
              'Medical Insights',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            SizedBox(height: 2.h),

            // Personalized health tips
            _buildSection(
              'Personalized Health Tips',
              'medical_information',
              AppTheme.successLight,
              insights,
            ),

            SizedBox(height: 2.h),

            // Upcoming milestones
            _buildSection(
              'Upcoming Recovery Milestones',
              'flag',
              AppTheme.accentLight,
              upcomingMilestones,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    String iconName,
    Color color,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        ...items.map((item) => _buildInsightItem(item, color)),
      ],
    );
  }

  Widget _buildInsightItem(String text, Color color) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha(26),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'fiber_manual_record',
            color: color,
            size: 3.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _generatePersonalizedInsights() {
    List<String> insights = [];

    if (currentStreak < 7) {
      insights.addAll([
        'Stay hydrated to help your body flush out toxins faster',
        'Deep breathing exercises can help manage cravings and improve oxygen flow',
        'Light exercise like walking will boost your energy and mood',
      ]);
    } else if (currentStreak < 30) {
      insights.addAll([
        'Your taste buds are recovering - enjoy healthier foods!',
        'Regular cardio exercise will accelerate lung healing',
        'Consider vitamin C supplements to boost your immune system',
      ]);
    } else if (currentStreak < 90) {
      insights.addAll([
        'Your lung function is significantly improving now',
        'Focus on stress management techniques for long-term success',
        'Regular health checkups will help track your progress',
      ]);
    } else {
      insights.addAll([
        'Congratulations! Your health improvements are substantial',
        'Maintain a heart-healthy diet to maximize cardiovascular benefits',
        'Consider sharing your success story to inspire others',
      ]);
    }

    // Add insights based on years smoking
    if (yearsSmoking > 0) {
      if (yearsSmoking >= 10) {
        insights
            .add('Given your smoking history, lung screenings are recommended');
      }
      if (yearsSmoking >= 20) {
        insights.add('Consider cardiac health monitoring with your doctor');
      }
    }

    return insights.take(3).toList();
  }

  List<String> _getUpcomingMilestones() {
    List<String> milestones = [];

    if (currentStreak < 14) {
      milestones.add(
          '2 weeks: Circulation improves and lung function increases by up to 30%');
    }
    if (currentStreak < 30) {
      milestones.add(
          '1 month: Coughing and shortness of breath decrease significantly');
    }
    if (currentStreak < 90) {
      milestones.add(
          '3 months: Lung function continues to improve, cilia begin to regrow');
    }
    if (currentStreak < 365) {
      milestones.add('1 year: Risk of coronary heart disease is cut in half');
    }
    if (currentStreak < 1825) {
      // 5 years
      milestones.add('5 years: Stroke risk is reduced to that of a non-smoker');
    }

    return milestones.take(2).toList();
  }
}
