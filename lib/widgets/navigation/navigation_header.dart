import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../services/theme_service.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class NavigationHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onOpenSettings;

  const NavigationHeader({Key? key, this.onOpenSettings}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final themeService = Provider.of<ThemeService>(context);
    
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo and Title
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.eco_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'SmokeLess+',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Action buttons
              Row(
                children: [
                  if (onOpenSettings != null)
                    IconButton(
                      onPressed: onOpenSettings,
                      icon: Icon(
                        Icons.settings,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      padding: EdgeInsets.all(8),
                      constraints: BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement notifications
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notifications coming soon!')),
                      );
                    },
                    icon: Icon(
                      Icons.notifications_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      themeService.toggleTheme();
                    },
                    icon: Icon(
                      themeService.isDarkMode 
                        ? Icons.light_mode_outlined 
                        : Icons.dark_mode_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}