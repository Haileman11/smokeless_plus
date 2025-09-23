import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SmokingHabitsWidget extends StatefulWidget {
  final int cigarettesPerDay;
  final double costPerPack;
  final double yearsSmoking;
  final Function(int) onCigarettesChanged;
  final Function(double) onCostChanged;
  final Function(double) onYearsSmokingChanged;

  const SmokingHabitsWidget({
    super.key,
    required this.cigarettesPerDay,
    required this.costPerPack,
    required this.yearsSmoking,
    required this.onCigarettesChanged,
    required this.onCostChanged,
    required this.onYearsSmokingChanged,
  });

  @override
  State<SmokingHabitsWidget> createState() => _SmokingHabitsWidgetState();
}

class _SmokingHabitsWidgetState extends State<SmokingHabitsWidget> {
  late int _cigarettesPerDay;
  late TextEditingController _costController;
  late TextEditingController _yearsController;

  @override
  void initState() {
    super.initState();
    _cigarettesPerDay = widget.cigarettesPerDay;
    _costController = TextEditingController(
      text: widget.costPerPack > 0 ? widget.costPerPack.toStringAsFixed(2) : '',
    );
    _yearsController = TextEditingController(
      text:
          widget.yearsSmoking > 0 ? widget.yearsSmoking.toStringAsFixed(1) : '',
    );
  }

  @override
  void dispose() {
    _costController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  void _updateCigarettes(int value) {
    if (value >= 0 && value <= 100) {
      setState(() {
        _cigarettesPerDay = value;
      });
      widget.onCigarettesChanged(value);
    }
  }

  void _updateCost(String value) {
    final cost = double.tryParse(value) ?? 0.0;
    widget.onCostChanged(cost);
  }

  void _updateYearsSmoking(String value) {
    final years = double.tryParse(value) ?? 0.0;
    widget.onYearsSmokingChanged(years);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Years of Smoking - NEW FIELD
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How many years have you been smoking?',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Years smoked before quitting',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              TextFormField(
                controller: _yearsController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
                ],
                decoration: InputDecoration(
                  hintText: '0.0',
                  suffixText: 'years',
                  suffixStyle:
                      AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: _updateYearsSmoking,
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        // Cigarettes per day
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'smoking_rooms',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cigarettes per Day',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'How many cigarettes do you smoke daily?',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decrease button
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: _cigarettesPerDay > 0
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: _cigarettesPerDay > 0
                          ? () => _updateCigarettes(_cigarettesPerDay - 1)
                          : null,
                      icon: CustomIconWidget(
                        iconName: 'remove',
                        color: Colors.white,
                        size: 5.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // Count display
                  Container(
                    width: 20.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _cigarettesPerDay.toString(),
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // Increase button
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: _cigarettesPerDay < 100
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: _cigarettesPerDay < 100
                          ? () => _updateCigarettes(_cigarettesPerDay + 1)
                          : null,
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: Colors.white,
                        size: 5.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        // Cost per pack
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'attach_money',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cost per Pack',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Average cost of a cigarette pack',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              TextFormField(
                controller: _costController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  prefixStyle:
                      AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: '0.00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: _updateCost,
              ),
            ],
          ),
        ),
        // Live calculation preview - NEW FEATURE
        if (_cigarettesPerDay > 0 &&
            double.tryParse(_yearsController.text) != null &&
            double.tryParse(_yearsController.text)! > 0)
          _buildCalculationPreview(),
      ],
    );
  }

  Widget _buildCalculationPreview() {
    final yearsSmoking = double.tryParse(_yearsController.text) ?? 0.0;
    final packCost = double.tryParse(_costController.text) ?? 0.0;

    if (yearsSmoking > 0 && _cigarettesPerDay > 0) {
      final totalDays = (yearsSmoking * 365.25).round();
      final totalCigarettes = totalDays * _cigarettesPerDay;
      final totalSpent = packCost > 0
          ? (totalCigarettes * (packCost / 20)).toStringAsFixed(0)
          : '0';

      return Container(
        margin: EdgeInsets.only(top: 3.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer.withAlpha(77),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.primary.withAlpha(77),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calculate',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Estimated Smoking Impact',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              '• Total cigarettes smoked: ${totalCigarettes.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (packCost > 0)
              Text(
                '• Total money spent: \$$totalSpent',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            Text(
              '• Smoking period: ${totalDays.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} days',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox.shrink();
  }
}
