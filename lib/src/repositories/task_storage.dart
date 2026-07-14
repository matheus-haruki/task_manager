import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/src/models/task.dart';

class TaskStorage {
  static const String _storageKey = 'tasks_data';

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson = jsonEncode(tasks.map((t) => t.toMap()).toList());
    await prefs.setString(_storageKey, tasksJson);
  }

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(_storageKey);

    if (tasksString == null) return [];

    try {
      final List<dynamic> decodedData = jsonDecode(tasksString);
      return decodedData
          .map((map) => Task.fromMap(map as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
