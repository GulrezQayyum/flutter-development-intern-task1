import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskService {
  static const String _tasksKey = 'tasks_list';
  static late SharedPreferences _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get all tasks
  static Future<List<Task>> getTasks() async {
    try {
      final String? tasksJson = _prefs.getString(_tasksKey);
      if (tasksJson == null) {
        return [];
      }
      final List<dynamic> decoded = jsonDecode(tasksJson);
      return decoded.map((item) => Task.fromJSON(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error loading tasks: $e');
      return [];
    }
  }

  // Add a new task
  static Future<bool> addTask(Task task) async {
    try {
      final List<Task> tasks = await getTasks();
      tasks.add(task);
      return await _saveTasks(tasks);
    } catch (e) {
      print('Error adding task: $e');
      return false;
    }
  }

  // Update a task
  static Future<bool> updateTask(Task task) async {
    try {
      final List<Task> tasks = await getTasks();
      final int index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
        return await _saveTasks(tasks);
      }
      return false;
    } catch (e) {
      print('Error updating task: $e');
      return false;
    }
  }

  // Delete a task
  static Future<bool> deleteTask(String id) async {
    try {
      final List<Task> tasks = await getTasks();
      tasks.removeWhere((t) => t.id == id);
      return await _saveTasks(tasks);
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  // Mark task as complete
  static Future<bool> toggleTaskCompletion(String id) async {
    try {
      final List<Task> tasks = await getTasks();
      final int index = tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        tasks[index].isCompleted = !tasks[index].isCompleted;
        return await _saveTasks(tasks);
      }
      return false;
    } catch (e) {
      print('Error toggling task: $e');
      return false;
    }
  }

  // Private helper to save tasks
  static Future<bool> _saveTasks(List<Task> tasks) async {
    try {
      final String tasksJson = jsonEncode(tasks.map((t) => t.toJSON()).toList());
      return await _prefs.setString(_tasksKey, tasksJson);
    } catch (e) {
      print('Error saving tasks: $e');
      return false;
    }
  }

  // Clear all tasks (for testing)
  static Future<bool> clearAllTasks() async {
    try {
      return await _prefs.remove(_tasksKey);
    } catch (e) {
      print('Error clearing tasks: $e');
      return false;
    }
  }
}