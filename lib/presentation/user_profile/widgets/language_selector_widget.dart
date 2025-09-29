import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smokeless_plus/l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/language_service.dart';

class LanguageSelectorWidget extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelectorWidget({
    Key? key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'language',
                  size: 6.w,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                l10n.languageSettings,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary, 
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            l10n.selectLanguage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          _buildLanguageGrid(context),
        ],
      ),
    );
  }

  Widget _buildLanguageGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 1.h,
      ),
      itemCount: LanguageProvider.supportedLanguages.length,
      itemBuilder: (context, index) {
        final language = LanguageProvider.supportedLanguages[index];
        final isSelected = widget.currentLanguage == language['code'];

        return _buildLanguageOption(context, language, isSelected);
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    Map<String, String> language,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => _selectLanguage(language['code']!),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withAlpha(26)
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withAlpha(51),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (isSelected)
              Container(
                margin: EdgeInsets.only(right: 2.w),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  size: 4.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    language['nativeName']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (language['nativeName'] != language['name'])
                    Text(
                      language['name']!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectLanguage(String languageCode) async {
    if (languageCode == widget.currentLanguage) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 2.h),
              Text(
                'Switching language...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );

    // Small delay to show loading
    await Future.delayed(const Duration(milliseconds: 300));

    // Save language preference
    await context.read<LanguageProvider>().setLanguage(languageCode);

    // Close loading dialog
    // if (mounted) Navigator.of(context).pop();

    if (true) {
      // Call the callback to update the app language
      widget.onLanguageChanged(languageCode);

      // Wait for the language to be applied
      await Future.delayed(const Duration(milliseconds: 500));

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Language changed to ${context.read<LanguageProvider>().getNativeLanguageName(languageCode)}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppTheme.successLight,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            duration: const Duration(seconds: 2),
          ),
        );

        // Force a complete widget tree rebuild by navigating back and forth
        // Navigator.of(context).pop();
        await Future.delayed(const Duration(milliseconds: 100));
        // Navigator.of(context).pushNamed('/user-profile');
      }
    } else {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Failed to change language. Please try again.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
