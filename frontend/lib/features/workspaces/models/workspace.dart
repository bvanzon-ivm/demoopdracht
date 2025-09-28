import '../../auth/models/user.dart';

class Workspace {
  final int id;
  final String name;
  final String description;
  final User owner;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Workspace({
    required this.id,
    required this.name,
    required this.description,
    required this.owner,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      owner: User.fromJson(json['owner']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
