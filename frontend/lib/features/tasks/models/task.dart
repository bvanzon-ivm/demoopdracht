import '../../auth/models/user.dart';

enum TaskStatus { TODO, IN_PROGRESS, DONE }
enum TaskPriority { LOW, MEDIUM, HIGH }

class Task {
  final int id;
  final int workspaceId;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final List<String> labels; // simplificatie (later model uitbreiden)
  final List<User> assignees;
  final User createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Task({
    required this.id,
    required this.workspaceId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.labels,
    required this.assignees,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    TaskStatus parseStatus(String s) =>
        TaskStatus.values.firstWhere((e) => e.name == s);
    TaskPriority parsePriority(String p) =>
        TaskPriority.values.firstWhere((e) => e.name == p);

    return Task(
      id: json['id'],
      workspaceId: json['workspaceId'],
      title: json['title'],
      description: json['description'],
      status: parseStatus(json['status']),
      priority: parsePriority(json['priority']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      labels: (json['labels'] as List<dynamic>?)
              ?.map((l) => l['name'] as String)
              .toList() ??
          [],
      assignees: (json['assignees'] as List<dynamic>?)
              ?.map((a) => User.fromJson(a))
              .toList() ??
          [],
      createdBy: User.fromJson(json['createdBy']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
