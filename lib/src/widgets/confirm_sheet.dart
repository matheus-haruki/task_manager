import 'package:flutter/material.dart';
import 'package:task_manager/src/theme/app_theme_extension.dart';
import 'package:task_manager/src/widgets/app_bottom_sheet.dart';

class ConfirmSheet extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String confirmLabel;
  final Color? confirmColor;

  const ConfirmSheet({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.confirmColor,
  });

  static Future<bool?> show(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String confirmLabel,
    Color? confirmColor,
  }) {
    return AppBottomSheet.show<bool>(
      context,
      isScrollControlled: true,
      child: ConfirmSheet(
        icon: icon,
        iconColor: iconColor,
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        confirmColor: confirmColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 36),
        const SizedBox(height: 16),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: confirmColor == null
                ? null
                : ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                    foregroundColor: Colors.white,
                  ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(foregroundColor: colors.textPrimary),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
        ),
      ],
    );
  }
}
