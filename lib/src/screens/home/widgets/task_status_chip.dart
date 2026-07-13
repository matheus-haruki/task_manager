import 'package:flutter/material.dart';
import 'package:task_manager/src/theme/app_theme_extension.dart';

class TaskStatusChip extends StatelessWidget {
  final bool done;
  const TaskStatusChip({super.key, required this.done});
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = done ? colors.completedText : colors.pendingIndicator;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(done ? 30 : 20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        done ? 'Concluída' : 'Em progresso',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
