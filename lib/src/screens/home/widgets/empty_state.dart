import 'package:flutter/material.dart';
import 'package:task_manager/src/theme/app_theme_extension.dart';

class EmptyState extends StatelessWidget {
  final bool isSearching;

  const EmptyState({super.key, required this.isSearching});

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.task_outlined,
              size: 80,
              color: context.appColors.inputBorder,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching
                  ? 'Nenhum resultado encontrado'
                  : 'Nenhuma tarefa ainda',
              style: TextStyle(
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Tente buscar por outro termo'
                  : 'Toque em "Criar Tarefa" para começar',
              style: TextStyle(fontSize: 14, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
