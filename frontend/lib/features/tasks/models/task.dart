
/// Lichte representatie van een gebruiker (assignee / createdBy)
class UserRef {
  final int id;
  final String? name;
  final String? email;

  UserRef({
    required this.id,
    this.name,
    this.email,
  });

  factory UserRef.fromJson(Map<String, dynamic> json) => UserRef(
        id: json['id'],
        name: json['name'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (name != null) 'name': name,
        if (email != null) 'email': email,
      };
}

/// Task entity zoals backend (`Task.java`)
class Task {
  final int id;
  final int workspaceId;
  final String title;
  final String? description;
  final String status; 
  final String priority; 
  final DateTime? dueDate;

  final List<String> labels;
  final List<UserRef> assignees;

  final UserRef createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Task({
    required this.id,
    required this.workspaceId,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    this.labels = const [],
    this.assignees = const [],
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        workspaceId: json['workspace']?['id'] ?? json['workspaceId'],
        title: json['title'],
        description: json['description'],
        status: json['status'],
        priority: json['priority'],
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        labels: (json['labels'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
        assignees: (json['assignees'] as List<dynamic>? ?? [])
            .map((a) => UserRef.fromJson(a as Map<String, dynamic>))
            .toList(),
        createdBy: UserRef.fromJson(json['createdBy']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'workspace': {'id': workspaceId},
        'title': title,
        if (description != null) 'description': description,
        'status': status,
        'priority': priority,
        if (dueDate != null) 'dueDate': dueDate!.toUtc().toIso8601String(),
        'labels': labels,
        'assignees': assignees.map((a) => a.toJson()).toList(),
        'createdBy': createdBy.toJson(),
        'createdAt': createdAt.toUtc().toIso8601String(),
        'updatedAt': updatedAt.toUtc().toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toUtc().toIso8601String(),
      };
}
