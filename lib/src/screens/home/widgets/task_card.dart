import 'package:flutter/material.dart';
import 'package:task_manager/src/models/task.dart';
import 'package:task_manager/src/theme/app_colors.dart';
import 'package:task_manager/src/theme/app_theme_extension.dart';
import 'package:task_manager/src/utils/date_formatter.dart';
import 'package:task_manager/src/screens/home/widgets/task_status_chip.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onComplete,
    required this.onTap,
  });

  static const double _descriptionFontSize = 14;
  static const double _descriptionLineHeight = 1.3;
  static const double _descriptionBoxHeight =
      _descriptionFontSize * _descriptionLineHeight * 2;

  @override
  Widget build(BuildContext context) {
    final done = task.isDone;

    final theme = Theme.of(context);

    final colors = context.appColors;

    final primaryTextColor = done ? colors.completedText : colors.textPrimary;

    final secondaryTextColor = done
        ? colors.completedText
        : colors.textSecondary;

    final cardBackgroundColor = done
        ? colors.completedBackground
        : theme.cardTheme.color;

    return AnimatedOpacity(
      opacity: done ? 0.65 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Card(
        color: cardBackgroundColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusIndicator(done: done, onTap: done ? null : onComplete),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor,
                          decoration: done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: colors.completedText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: _descriptionBoxHeight,
                        child: Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: _descriptionFontSize,
                            height: _descriptionLineHeight,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: secondaryTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.createdAt.formatted,
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryTextColor,
                            ),
                          ),
                          const Spacer(),
                          TaskStatusChip(done: done),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final bool done;
  final VoidCallback? onTap;

  const _StatusIndicator({required this.done, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: done ? colors.completedText : colors.pendingIndicator,
            width: 2.5,
          ),
          color: done ? colors.completedText : null,
        ),
        child: done
            ? const Icon(Icons.check, size: 16, color: AppColors.surfaceLight)
            : null,
      ),
    );
  }
}
