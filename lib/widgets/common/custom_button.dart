import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isLarge;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final String? dataTestId;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isLarge = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.dataTestId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? 
        (isOutlined ? Colors.transparent : AppColors.primary);
    final effectiveTextColor = textColor ?? 
        (isOutlined ? AppColors.primary : Colors.white);

    return SizedBox(
      width: double.infinity,
      height: isLarge ? 56 : 48,
      child: ElevatedButton(
        key: dataTestId != null ? Key(dataTestId!) : null,
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          side: isOutlined ? BorderSide(color: AppColors.primary, width: 2) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isOutlined ? 0 : 2,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: isLarge ? AppTextStyles.buttonLarge : AppTextStyles.button,
                  ),
                ],
              ),
      ),
    );
  }
}