import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DataExportDialog extends StatefulWidget {
  final Function(String) onExport;

  const DataExportDialog({
    Key? key,
    required this.onExport,
  }) : super(key: key);

  @override
  State<DataExportDialog> createState() => _DataExportDialogState();
}

class _DataExportDialogState extends State<DataExportDialog> {
  String _selectedFormat = 'PDF';
  bool _isExporting = false;

  final List<Map<String, dynamic>> _exportFormats = [
    {
      'format': 'PDF',
      'description': 'Complete quit history with charts and milestones',
      'icon': 'picture_as_pdf',
    },
    {
      'format': 'CSV',
      'description': 'Raw data for spreadsheet analysis',
      'icon': 'table_chart',
    },
    {
      'format': 'JSON',
      'description': 'Technical data format for backup',
      'icon': 'code',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 70.h),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'download',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Export Your Data',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Choose the format for your quit smoking data export:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _exportFormats.length,
                itemBuilder: (context, index) {
                  final format = _exportFormats[index];
                  return _buildFormatOption(format);
                },
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Your data will be exported securely and can be used for personal records or sharing with healthcare providers.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _isExporting ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: _isExporting
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.5)
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                ElevatedButton(
                  onPressed: _isExporting ? null : _exportData,
                  child: _isExporting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text('Export Data'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatOption(Map<String, dynamic> format) {
    final isSelected = _selectedFormat == format['format'];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFormat = format['format'] as String;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                    .withValues(alpha: 0.2)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: format['icon'] as String,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      format['format'] as String,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      format['description'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportData() async {
    setState(() {
      _isExporting = true;
    });

    try {
      // Simulate export process
      await Future.delayed(const Duration(seconds: 2));

      widget.onExport(_selectedFormat);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported successfully as $_selectedFormat'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }
}
