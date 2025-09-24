import 'package:flutter/material.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/utils/utils.dart';

import '../../../core/app_export.dart';

class SmokingPeriodStatsWidget extends StatelessWidget {
  final int totalCigarettesSmoked;
  final double totalMoneySpent;
  final int smokingPeriodDays;
  final double yearsSmoking;

  const SmokingPeriodStatsWidget({
    Key? key,
    required this.totalCigarettesSmoked,
    required this.totalMoneySpent,
    required this.smokingPeriodDays,
    required this.yearsSmoking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Calculate life lost based on smoking period
    final lifeLostMinutes =
        totalCigarettesSmoked * 11; // 11 minutes per cigarette
    final lifeLostDuration = formatLifeLost(lifeLostMinutes);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE74C3C).withAlpha(26),
            Color(0xFFE74C3C).withAlpha(13),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFE74C3C).withAlpha(51),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and icon
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Color(0xFFE74C3C).withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'history',
                    color: Color(0xFFE74C3C),
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'During the period that you smoked:',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE74C3C),
                        ),
                      ),
                      Text(
                        yearsSmoking > 0
                            ? '${yearsSmoking.toStringAsFixed(1)} years'
                            : 'Smoking period',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Statistics grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: 'smoking_rooms',
                    value: _formatNumber(totalCigarettesSmoked),
                    label: 'Cigarettes Smoked',
                    color: Color(0xFF8E44AD),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildStatCard(
                    icon: 'attach_money',
                    value: '\$${totalMoneySpent.toStringAsFixed(0)}',
                    label: 'Money Wasted',
                    color: Color(0xFFE67E22),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Life lost section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Color(0xFFE74C3C).withAlpha(13),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFFE74C3C).withAlpha(26),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Color(0xFFE74C3C).withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'schedule',
                      color: Color(0xFFE74C3C),
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lifeLostDuration,
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE74C3C),
                          ),
                        ),
                        Text(
                          'Life Lost',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.textMediumEmphasisLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Motivational message
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.successLight.withAlpha(77),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb',
                    color: AppTheme.successLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'The good news? Every day smoke-free, you\'re reclaiming your health and savings!',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.successLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha(51),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 6.w,
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
  
}
