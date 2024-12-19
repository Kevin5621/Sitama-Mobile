// custom_alert_dialog.dart

import 'package:flutter/material.dart';
import 'package:Sitama/core/config/themes/app_color.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final Color? confirmColor;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final IconData? icon;
  final Color? iconColor;
  final Widget Function(BuildContext)? confirmButton;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText = 'Batal',
    this.confirmText = 'Setuju',
    this.confirmColor,
    this.onCancel,
    this.onConfirm,
    this.icon,
    this.iconColor,
    this.confirmButton,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String cancelText = 'Batal',
    String confirmText = 'Setuju',
    Color? confirmColor,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CustomAlertDialog(
        title: title,
        message: message,
        cancelText: cancelText,
        confirmText: confirmText,
        confirmColor: confirmColor,
        icon: icon,
        iconColor: iconColor,
        onCancel: () => Navigator.of(context).pop(false),
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
  }

  static Future<bool?> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      confirmColor: colorScheme.primary,
      icon: Icons.check_circle_outline,
      iconColor: colorScheme.primary,
    );
  }

  static Future<bool?> showError({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      confirmColor: AppColors.lightDanger,
      icon: Icons.error_outline,
      iconColor: AppColors.lightDanger,
    );
  }

  static Future<bool?> showWarning({
    required BuildContext context,
    required String title,
    required String message,
    String cancelText = 'Batal',
    String confirmText = 'Lanjutkan',
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      cancelText: cancelText,
      confirmText: confirmText,
      confirmColor: Colors.orange,
      icon: Icons.warning_amber_outlined,
      iconColor: Colors.orange,
    );
  }

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String cancelText = 'Batal',
    String confirmText = 'Setuju',
    IconData? icon, 
    Color? iconColor, 
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return show(
      context: context,
      title: title,
      message: message,
      cancelText: cancelText,
      confirmText: confirmText,
      confirmColor: colorScheme.primary,
      icon: icon ?? Icons.help_outline, 
      iconColor: iconColor ?? colorScheme.primary, 
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      title: Column(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 40,
              color: iconColor ?? colorScheme.primary,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        if (cancelText.isNotEmpty)
          TextButton(
            onPressed: onCancel ?? () {},
            child: Text(
              cancelText,
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        // Using confirmButton if available, otherwise use default ElevatedButton
        confirmButton?.call(context) ?? ElevatedButton(
          onPressed: onConfirm ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}