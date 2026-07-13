import 'package:flutter/foundation.dart';
import 'package:task_manager/src/models/sort_option.dart';
import 'package:task_manager/src/models/task.dart';

@immutable
class TaskState {
  final List<Task> tasks;
  final String query;
  final SortOption sortOption;
  const TaskState({
    this.tasks = const [],
    this.query = '',
    this.sortOption = SortOption.newestFirst,
  });
  int get pendingCount => tasks.where((t) => !t.isDone).length;
  List<Task> get visibleTasks {
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? tasks
        : tasks.where((t) => t.title.toLowerCase().contains(q));
    return filtered.toList()..sort(sortOption.compare);
  }

  bool get isSearching => query.trim().isNotEmpty;
  TaskState copyWith({
    List<Task>? tasks,
    String? query,
    SortOption? sortOption,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      query: query ?? this.query,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskState &&
        listEquals(other.tasks, tasks) &&
        other.query == query &&
        other.sortOption == sortOption;
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(tasks), query, sortOption);
}
