import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../data/database_helper.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  List<Task> get todayTasks {
    final now = DateTime.now();
    return _tasks
        .where((task) =>
            task.dueDate.year == now.year &&
            task.dueDate.month == now.month &&
            task.dueDate.day == now.day)
        .toList();
  }

  List<Task> get historyTasks {
    final now = DateTime.now();
    return _tasks
        .where((task) =>
            task.dueDate.isBefore(DateTime(now.year, now.month, now.day)) ||
            task.isCompleted)
        .toList();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await DatabaseHelper.instance.getAllTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required Priority priority,
  }) async {
    final task = Task(
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
    );
    await DatabaseHelper.instance.createTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper.instance.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    await loadTasks();
  }
}
