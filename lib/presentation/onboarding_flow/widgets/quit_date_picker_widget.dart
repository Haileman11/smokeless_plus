import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';

import '../../../core/app_export.dart';

class QuitDatePickerWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const QuitDatePickerWidget({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<QuitDatePickerWidget> createState() => _QuitDatePickerWidgetState();
}

class _QuitDatePickerWidgetState extends State<QuitDatePickerWidget> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.selectedDate;
  }

  Future<void> _selectDateTime() async {
    // Step 1: Pick date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    // Step 2: Pick time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    // Step 3: Combine date and time
    final DateTime combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedDateTime = combined;
    });

    widget.onDateSelected(combined);
  }


  List<String> getLocalizedMonthNames([String? locale]) {
    return List.generate(12, (index) {
      final date = DateTime(2024, index + 1, 1); // Any non-leap year works
      return DateFormat.MMMM(locale).format(date); // Full month name
    });
  }

  String _formatDateTime(DateTime dateTime) {
    final months = getLocalizedMonthNames(Localizations.localeOf(context).languageCode);

    final String formattedDate =
        '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';

    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final formattedTime = '$hour:$minute $period';

    return '$formattedDate at $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedDateTime != null
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: Theme.of(context).colorScheme.primary,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.quitDateTime,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _selectedDateTime != null
                          ? _formatDateTime(_selectedDateTime!)
                          : AppLocalizations.of(context)!.selectYourQuitDateAndTime,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _selectedDateTime != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            height: 5.h,
            child: OutlinedButton(
              onPressed: _selectDateTime,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _selectedDateTime != null ? AppLocalizations.of(context)!.changeDateAndTime : AppLocalizations.of(context)!.selectDateAndTime,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
