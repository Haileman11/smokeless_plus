import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/motivational_quotes_service.dart';

/// Daily Motivation Widget that displays below health recovery timeline
class DailyMotivationWidget extends StatefulWidget {
  const DailyMotivationWidget({Key? key}) : super(key: key);

  @override
  State<DailyMotivationWidget> createState() => _DailyMotivationWidgetState();
}

class _DailyMotivationWidgetState extends State<DailyMotivationWidget> {
  Map<String, String> _currentQuote = {
    "message": "Loading your daily motivation...",
    "author": "Loading..."
  };

  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadDailyQuote();
  }

  /// Load the daily motivational quote
  Future<void> _loadDailyQuote() async {
    setState(() => _isLoading = true);

    try {
      final quote = await MotivationalQuotesService.getDailyMotivationalQuote();
      if (mounted) {
        setState(() {
          _currentQuote = quote;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to a random quote if daily quote fails
      final fallbackQuote = MotivationalQuotesService.getRandomQuote();
      if (mounted) {
        setState(() {
          _currentQuote = fallbackQuote;
          _isLoading = false;
        });
      }
    }
  }

  /// Manually refresh the quote
  Future<void> _refreshQuote() async {
    setState(() => _isRefreshing = true);

    try {
      final newQuote = await MotivationalQuotesService.forceRefreshQuote();
      if (mounted) {
        setState(() {
          _currentQuote = newQuote;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      // Show error message but keep current quote
      if (mounted) {
        setState(() => _isRefreshing = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to refresh quote. Try again later.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and refresh button
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.5.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'auto_awesome',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 5.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Daily Motivation',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ),
                // Refresh button
                GestureDetector(
                  onTap: _isRefreshing ? null : _refreshQuote,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _isRefreshing
                          ? AppTheme.textDisabledLight.withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AnimatedRotation(
                      turns: _isRefreshing ? 1 : 0,
                      duration: const Duration(milliseconds: 800),
                      child: CustomIconWidget(
                        iconName: 'refresh',
                        color: _isRefreshing
                            ? AppTheme.textDisabledLight
                            : AppTheme.lightTheme.colorScheme.secondary,
                        size: 4.5.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // Quote content
            _isLoading ? _buildLoadingState() : _buildQuoteContent(),
          ],
        ),
      ),
    );
  }

  /// Build loading state widget
  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 2.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: AppTheme.textDisabledLight.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 2.h,
          width: 70.w,
          decoration: BoxDecoration(
            color: AppTheme.textDisabledLight.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          height: 1.5.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: AppTheme.textDisabledLight.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  /// Build the actual quote content
  Widget _buildQuoteContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quote message with quotation marks
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"',
              style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.6),
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentQuote["message"] ??
                        "Stay strong on your quit smoking journey!",
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: AppTheme.textHighEmphasisLight,
                    ),
                  ),
                  Text(
                    '"',
                    style:
                        AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.6),
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Author attribution with icon
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(1.5.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 3.5.w,
              ),
            ),
            SizedBox(width: 2.5.w),
            Expanded(
              child: Text(
                "- ${_currentQuote["author"] ?? "Anonymous"}",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: AppTheme.textMediumEmphasisLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Time-based message indicator
        _buildTimeIndicator(),
      ],
    );
  }

  /// Build time-based indicator (morning/evening)
  Widget _buildTimeIndicator() {
    final now = DateTime.now();
    final isMorning = now.hour >= 6 && now.hour < 18;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isMorning
            ? Colors.amber.withValues(alpha: 0.1)
            : Colors.indigo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMorning
              ? Colors.amber.withValues(alpha: 0.3)
              : Colors.indigo.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: isMorning ? 'wb_sunny' : 'nights_stay',
            color: isMorning ? Colors.amber.shade600 : Colors.indigo.shade600,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Text(
            isMorning ? 'Morning Motivation' : 'Evening Inspiration',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: isMorning ? Colors.amber.shade700 : Colors.indigo.shade700,
            ),
          ),
        ],
      ),
    );
  }
}