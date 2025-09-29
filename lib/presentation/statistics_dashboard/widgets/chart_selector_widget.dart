import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ChartSelectorWidget extends StatelessWidget {
  final List<String> chartTypes;
  final int selectedIndex;
  final Function(int) onSelectionChanged;

  const ChartSelectorWidget({
    super.key,
    required this.chartTypes,
    required this.selectedIndex,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: chartTypes.asMap().entries.map((entry) {
          int index = entry.key;
          String type = entry.value;
          bool isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelectionChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.all(0.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    type,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface
                              .withValues(alpha: 0.7),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
