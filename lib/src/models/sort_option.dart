import 'package:flutter/material.dart';
import 'package:task_manager/src/models/task.dart';

enum SortOption {
  newestFirst('Mais recente primeiro', Icons.arrow_downward),
  oldestFirst('Mais antiga primeiro', Icons.arrow_upward),
  pendingFirst('Pendentes primeiro', Icons.radio_button_unchecked),
  completedFirst('Concluídas primeiro', Icons.check_circle_outline);

  final String label;
  final IconData icon;
  const SortOption(this.label, this.icon);

  int compare(Task a, Task b) {
    switch (this) {
      case SortOption.newestFirst:
        return b.createdAt.compareTo(a.createdAt);
      case SortOption.oldestFirst:
        return a.createdAt.compareTo(b.createdAt);
      case SortOption.pendingFirst:
        return a.isDone == b.isDone ? 0 : (a.isDone ? 1 : -1);
      case SortOption.completedFirst:
        return a.isDone == b.isDone ? 0 : (a.isDone ? -1 : 1);
    }
  }
}
