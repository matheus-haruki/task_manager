import 'package:flutter/material.dart';
import 'package:task_manager/src/models/sort_option.dart';
import 'package:task_manager/src/theme/app_theme_extension.dart';
import 'package:task_manager/src/widgets/app_bottom_sheet.dart';

class SortSheet extends StatelessWidget {
  final SortOption current;

  const SortSheet({super.key, required this.current});

  static Future<SortOption?> show(BuildContext context, SortOption current) {
    return AppBottomSheet.show<SortOption>(
      context,
      child: SortSheet(current: current),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ordenar por',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...SortOption.values.map((option) {
          final selected = option == current;
          final activeColor = colors.brand;
          return ListTile(
            leading: Icon(
              option.icon,
              color: selected ? activeColor : colors.textSecondary,
            ),
            title: Text(
              option.label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? activeColor : colors.textPrimary,
              ),
            ),
            trailing: selected ? Icon(Icons.check, color: activeColor) : null,
            onTap: () => Navigator.pop(context, option),
          );
        }),
      ],
    );
  }
}
