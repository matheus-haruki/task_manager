import 'package:flutter/material.dart';
import 'package:task_manager/src/models/task.dart';
import 'package:task_manager/src/theme/app_theme_extension.dart';
import 'package:task_manager/src/utils/date_formatter.dart';
import 'package:task_manager/src/widgets/app_bottom_sheet.dart';
import 'package:task_manager/src/screens/home/widgets/task_status_chip.dart';

class TaskDetailModal extends StatelessWidget {
  final Task task;
  const TaskDetailModal({super.key, required this.task});

  static Future<void> show(BuildContext context, Task task) {
    return AppBottomSheet.show<void>(
      context,
      isScrollControlled: true,
      child: TaskDetailModal(task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final done = task.isDone;
    final maxHeight = MediaQuery.of(context).size.height * 0.7;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: done ? colors.completedText : colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TaskStatusChip(done: done),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: colors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                task.createdAt.formatted,
                style: TextStyle(fontSize: 12, color: colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: colors.divider, height: 1),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                task.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: done ? colors.completedText : colors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
