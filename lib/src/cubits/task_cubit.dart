import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/src/models/sort_option.dart';
import 'package:task_manager/src/models/task.dart';
import 'package:task_manager/src/repositories/task_storage.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final DateTime Function() _now;
  final TaskStorage _storage;

  int _nextId = 0;

  TaskCubit({DateTime Function()? now, required this._storage})
    : _now = now ?? DateTime.now,
      super(const TaskState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final tasks = await _storage.loadTasks();
    if (tasks.isNotEmpty) {
      _nextId = tasks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    }
    emit(state.copyWith(tasks: tasks));
  }

  Future<void> _saveState(List<Task> tasks) async {
    await _storage.saveTasks(tasks);
  }

  void addTask({required String title, required String description}) {
    final task = Task.create(
      id: _nextId++,
      title: title,
      description: description,
      createdAt: _now(),
    );
    final newTasks = [task, ...state.tasks];

    emit(state.copyWith(tasks: newTasks));
    _saveState(newTasks);  
  }

  void completeTask(int id) {
    final newTasks = state.tasks
        .map((t) => t.id == id ? t.complete() : t)
        .toList();

    emit(state.copyWith(tasks: newTasks));
    _saveState(newTasks);
  }

  void deleteTask(int id) {
    final newTasks = state.tasks.where((t) => t.id != id).toList();

    emit(state.copyWith(tasks: newTasks));
    _saveState(newTasks);
  }

  void search(String query) => emit(state.copyWith(query: query));

  void sortBy(SortOption option) => emit(state.copyWith(sortOption: option));
}
