import 'subtask.dart';

class Task {
  String id;
  String title;
  String? description;
  DateTime createdAt;
  bool isCompleted;
  List<SubTask> subTasks;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.isCompleted = false,
    this.subTasks = const [],
  });

  int get completedSubTasksCount {
    return subTasks.where((subTask) => subTask.isCompleted).length;
  }

  double get progress {
    if (subTasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    return completedSubTasksCount / subTasks.length;
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isCompleted,
    List<SubTask>? subTasks,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      subTasks: subTasks ?? this.subTasks,
    );
  }
}