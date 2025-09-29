import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;

  const SettingsSectionWidget({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return _buildSettingsItem(item, isLast ,context);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(SettingsItem item, bool isLast, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              )
            : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        leading: item.icon,
        title: Text(
          item.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: item.subtitle != null
            ? Text(
                item.subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: item.trailing,
        onTap: item.onTap,
      ),
    );
  }
}

class SettingsItem {
  final String title;
  final String? subtitle;
  final Widget icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  SettingsItem({
    required this.title,
    this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
  });
}
