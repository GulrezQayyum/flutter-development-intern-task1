import 'dart:convert';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    DateTime? createdAt,
    this.isCompleted = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJSON(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
