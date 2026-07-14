import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    try {
      final tasks = await TaskService.getTasks();
      print('DEBUG: Loaded ${tasks.length} tasks');
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('DEBUG: Error loading tasks: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading tasks: $e')),
        );
      }
    }
  }

  void _showAddOrEditTaskDialog({Task? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController = TextEditingController(text: task?.description ?? '');
    final isEditing = task != null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Task' : 'Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'Enter task title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Task Description',
                    hintText: 'Enter task description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')),
                    );
                  }
                  return;
                }

                if (isEditing) {
                  // Edit existing task
                  final updatedTask = task!.copyWith(
                    title: titleController.text,
                    description: descriptionController.text,
                  );
                  final success = await TaskService.updateTask(updatedTask);
                  if (mounted) {
                    Navigator.of(context).pop();
                    if (success) {
                      await _loadTasks();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Task updated successfully')),
                      );
                    }
                  }
                } else {
                  // Add new task
                  final newTask = Task(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    description: descriptionController.text,
                  );

                  final success = await TaskService.addTask(newTask);
                  if (mounted) {
                    Navigator.of(context).pop();
                    if (success) {
                      print('DEBUG: Task added, reloading...');
                      await _loadTasks();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Task added successfully')),
                      );
                    }
                  }
                }
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(String id) async {
    final success = await TaskService.deleteTask(id);
    if (success) {
      print('DEBUG: Task deleted, reloading...');
      await _loadTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      }
    }
  }

  Future<void> _toggleTaskCompletion(String id) async {
    final success = await TaskService.toggleTaskCompletion(id);
    if (success) {
      print('DEBUG: Task completion toggled, reloading...');
      await _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              await AuthService.signOut();
              // AuthGate listens for the auth state change and swaps
              // back to LoginScreen automatically.
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _tasks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add a task to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  _toggleTaskCompletion(task.id);
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                task.description.isEmpty
                    ? 'No description'
                    : task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              trailing: PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: const Text('Edit'),
                    onTap: () {
                      Future.delayed(
                        const Duration(milliseconds: 100),
                            () => _showAddOrEditTaskDialog(task: task),
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Task?'),
                            content: const Text(
                                'Are you sure you want to delete this task?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _deleteTask(task.id);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditTaskDialog(),
        backgroundColor: Colors.blue.shade600,
        tooltip: 'Add new task',
        child: const Icon(Icons.add),
      ),
    );
  }
}