import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterOptionsWidget extends StatelessWidget {
  final String selectedDateRange;
  final String selectedMetricType;
  final String selectedComparison;
  final Function(String) onDateRangeChanged;
  final Function(String) onMetricTypeChanged;
  final Function(String) onComparisonChanged;

  const FilterOptionsWidget({
    super.key,
    required this.selectedDateRange,
    required this.selectedMetricType,
    required this.selectedComparison,
    required this.onDateRangeChanged,
    required this.onMetricTypeChanged,
    required this.onComparisonChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: CustomIconWidget(
          iconName: 'tune',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        title: Text(
          'Filter Options',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '$selectedDateRange • $selectedMetricType',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterSection(
                  'Date Range',
                  [
                    'Last 7 Days',
                    'Last 30 Days',
                    'Last 3 Months',
                    'Last Year',
                    'All Time'
                  ],
                  selectedDateRange,
                  onDateRangeChanged,
                ),
                SizedBox(height: 2.h),
                _buildFilterSection(
                  'Metric Type',
                  [
                    'All Metrics',
                    'Health Progress',
                    'Financial Savings',
                    'Behavioral Changes'
                  ],
                  selectedMetricType,
                  onMetricTypeChanged,
                ),
                SizedBox(height: 2.h),
                _buildFilterSection(
                  'Comparison',
                  [
                    'Personal Goals',
                    'Community Average',
                    'Previous Period',
                    'No Comparison'
                  ],
                  selectedComparison,
                  onComparisonChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  option,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
