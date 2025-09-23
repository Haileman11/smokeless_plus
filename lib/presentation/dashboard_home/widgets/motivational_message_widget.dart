import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/motivational_quotes_service.dart';

class MotivationalMessageWidget extends StatefulWidget {
  final String? message;
  final String? author;

  const MotivationalMessageWidget({
    Key? key,
    this.message,
    this.author,
  }) : super(key: key);

  @override
  State<MotivationalMessageWidget> createState() =>
      _MotivationalMessageWidgetState();
}

class _MotivationalMessageWidgetState extends State<MotivationalMessageWidget> {
  Map<String, String>? _currentQuote;
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadDailyQuote();
  }

  Future<void> _loadDailyQuote() async {
    try {
      final quote = await MotivationalQuotesService.getDailyMotivationalQuote();
      if (mounted) {
        setState(() {
          _currentQuote = quote;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to provided message or default
      if (mounted) {
        setState(() {
          _currentQuote = {
            'message': widget.message ??
                'Every day smoke-free is a victory. You\'re building a healthier, stronger version of yourself.',
            'author': widget.author ?? 'Health Coach',
          };
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshQuote() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    try {
      final newQuote = await MotivationalQuotesService.forceRefreshQuote();
      if (mounted) {
        setState(() {
          _currentQuote = newQuote;
        });

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New motivational quote loaded!'),
            backgroundColor: AppTheme.successLight,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh quote. Try again later.'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Future<void> _showQuoteInfo() async {
    try {
      final scheduleInfo =
          await MotivationalQuotesService.getQuoteScheduleInfo();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Quote Schedule',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Current Period', scheduleInfo['currentPeriod']),
                SizedBox(height: 2.h),
                _buildInfoRow('Total Quotes',
                    '${scheduleInfo['totalQuotes']} unique quotes'),
                SizedBox(height: 2.h),
                _buildInfoRow(
                    'Refresh Schedule', scheduleInfo['refreshFrequency']),
                SizedBox(height: 2.h),
                _buildInfoRow(
                  'Next Refresh',
                  '${scheduleInfo['nextRefreshPeriod']} in ${scheduleInfo['hoursUntilRefresh']}h ${scheduleInfo['minutesUntilRefresh']}m',
                ),
                SizedBox(height: 3.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Quotes automatically refresh at 6 AM and 6 PM every day to keep you motivated throughout your quit-smoking journey!',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Got it!',
                  style: TextStyle(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle error silently or show simple message
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$label:',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        height: 20.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              AppTheme.accentLight.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      );
    }

    final quote = _currentQuote!;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.accentLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'format_quote',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Daily Motivation',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _showQuoteInfo,
                  icon: CustomIconWidget(
                    iconName: 'info_outline',
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.7),
                    size: 5.w,
                  ),
                  padding: EdgeInsets.all(1.w),
                  constraints: BoxConstraints(),
                ),
                SizedBox(width: 1.w),
                IconButton(
                  onPressed: _isRefreshing ? null : _refreshQuote,
                  icon: _isRefreshing
                      ? SizedBox(
                          width: 4.w,
                          height: 4.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'refresh',
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.7),
                          size: 5.w,
                        ),
                  padding: EdgeInsets.all(1.w),
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              quote['message']!,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 2.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '- ${quote['author']}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Auto-refreshes 2x daily',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  '${MotivationalQuotesService.getTotalQuotesCount()}+ unique quotes',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                    fontWeight: FontWeight.w500,
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
