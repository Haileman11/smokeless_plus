import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimePeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const TimePeriodSelector({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final periods = ['Week', 'Month', '3 Months', 'Year'];

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: periods.map((period) {
          final isSelected = selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPeriodChanged(period),
              child: Container(
                margin: EdgeInsets.all(0.5.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    period,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
