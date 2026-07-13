import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/src/models/sort_option.dart';
import 'package:task_manager/src/models/task.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final DateTime Function() _now;

  int _nextId = 0;

  TaskCubit({DateTime Function()? now})
    : _now = now ?? DateTime.now,
      super(const TaskState());

  void addTask({required String title, required String description}) {
    final task = Task.create(
      id: _nextId++,
      title: title,
      description: description,
      createdAt: _now(),
    );
    emit(state.copyWith(tasks: [task, ...state.tasks]));
  }

  void completeTask(int id) {
    emit(
      state.copyWith(
        tasks: state.tasks.map((t) => t.id == id ? t.complete() : t).toList(),
      ),
    );
  }

  void deleteTask(int id) {
    emit(state.copyWith(tasks: state.tasks.where((t) => t.id != id).toList()));
  }

  void search(String query) => emit(state.copyWith(query: query));

  void sortBy(SortOption option) => emit(state.copyWith(sortOption: option));
}
