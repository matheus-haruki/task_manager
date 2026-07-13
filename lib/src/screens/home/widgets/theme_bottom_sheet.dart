import 'package:flutter/material.dart';
import 'package:task_manager/src/theme/app_theme_extension.dart';
import 'package:task_manager/src/widgets/app_bottom_sheet.dart';

class ThemeBottomSheet extends StatelessWidget {
  final ThemeMode currentTheme;

  const ThemeBottomSheet({super.key, required this.currentTheme});

  static Future<ThemeMode?> show(BuildContext context, ThemeMode currentTheme) {
    return AppBottomSheet.show<ThemeMode>(
      context,
      child: ThemeBottomSheet(currentTheme: currentTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aparência',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ThemeOptionCard(
              label: 'Clara',
              icon: Icons.light_mode,
              isSelected: currentTheme == ThemeMode.light,
              onTap: () => Navigator.pop(context, ThemeMode.light),
            ),
            _ThemeOptionCard(
              label: 'Escura',
              icon: Icons.dark_mode,
              isSelected: currentTheme == ThemeMode.dark,
              onTap: () => Navigator.pop(context, ThemeMode.dark),
            ),
            _ThemeOptionCard(
              label: 'Auto',
              icon: Icons.brightness_auto,
              isSelected: currentTheme == ThemeMode.system,
              onTap: () => Navigator.pop(context, ThemeMode.system),
            ),
          ],
        ),
      ],
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 90,
            height: 120,
            decoration: BoxDecoration(
              color: isSelected
                  ? context.appColors.brand.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? context.appColors.brand
                    : context.appColors.inputBorder,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 32,
                color: isSelected
                    ? context.appColors.brand
                    : context.appColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Icon(Icons.check, size: 16, color: colorScheme.primary),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? colorScheme.primary : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
