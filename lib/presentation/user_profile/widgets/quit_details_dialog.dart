import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuitDetailsDialog extends StatefulWidget {
  final DateTime currentQuitDate;
  final int currentDailyCigarettes;
  final double currentPackCost;
  final double currentYearsSmoking;
  final Function(DateTime, int, double, double) onSave;

  const QuitDetailsDialog({
    Key? key,
    required this.currentQuitDate,
    required this.currentDailyCigarettes,
    required this.currentPackCost,
    required this.currentYearsSmoking,
    required this.onSave,
  }) : super(key: key);

  @override
  State<QuitDetailsDialog> createState() => _QuitDetailsDialogState();
}

class _QuitDetailsDialogState extends State<QuitDetailsDialog> {
  late DateTime _selectedDate;
  late TextEditingController _cigarettesController;
  late TextEditingController _packCostController;
  late TextEditingController _yearsSmokingController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.currentQuitDate;
    _cigarettesController = TextEditingController(
      text: widget.currentDailyCigarettes.toString(),
    );
    _packCostController = TextEditingController(
      text: widget.currentPackCost.toStringAsFixed(2),
    );
    _yearsSmokingController = TextEditingController(
      text: widget.currentYearsSmoking.toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _cigarettesController.dispose();
    _packCostController.dispose();
    _yearsSmokingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxHeight: 85.h),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Edit Quit Details',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Update your quit information. Changes will sync across all app features.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            _buildDateSelector(),
            SizedBox(height: 3.h),
            _buildNumberInput(
              'Years of Smoking',
              _yearsSmokingController,
              'years smoked before quitting',
              const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 3.h),
            _buildNumberInput(
              'Daily Cigarettes',
              _cigarettesController,
              'cigarettes per day',
              TextInputType.number,
            ),
            SizedBox(height: 3.h),
            _buildNumberInput(
              'Pack Cost',
              _packCostController,
              '\$ per pack',
              const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 2.h),
            _buildCalculationPreview(),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _isSaving ? null : () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                SizedBox(width: 3.w),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  child: _isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text('Save Changes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationPreview() {
    final yearsSmoking = double.tryParse(_yearsSmokingController.text) ?? 0.0;
    final cigarettesPerDay = int.tryParse(_cigarettesController.text) ?? 0;
    final packCost = double.tryParse(_packCostController.text) ?? 0.0;

    if (yearsSmoking > 0 && cigarettesPerDay > 0) {
      final totalDays = (yearsSmoking * 365.25).round();
      final totalCigarettes = totalDays * cigarettesPerDay;
      final totalSpent = (totalCigarettes * (packCost / 20)).toStringAsFixed(0);

      return Container(
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
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Smoking Period Impact',
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

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quit Date',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        InkWell(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberInput(
    String label,
    TextEditingController controller,
    String hint,
    TextInputType keyboardType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: label == 'Daily Cigarettes'
                    ? 'smoking_rooms'
                    : label == 'Pack Cost'
                        ? 'attach_money'
                        : 'schedule',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: AppTheme.lightTheme.colorScheme),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveChanges() async {
    final cigarettes = int.tryParse(_cigarettesController.text) ?? 0;
    final packCost = double.tryParse(_packCostController.text) ?? 0.0;
    final yearsSmoking = double.tryParse(_yearsSmokingController.text) ?? 0.0;

    if (cigarettes > 0 && packCost > 0 && yearsSmoking >= 0) {
      setState(() {
        _isSaving = true;
      });

      try {
        await widget.onSave(_selectedDate, cigarettes, packCost, yearsSmoking);
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save changes: $e'),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid values for all fields'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }
}
