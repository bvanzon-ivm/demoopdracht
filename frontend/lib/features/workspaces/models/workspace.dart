import '../../auth/models/user.dart';

/// Workspace entity
class Workspace {
  final int id;
  final String name;
  final User owner;
  final List<User> members;
  final bool isOwner;
  final String description;
  final int memberCount;
  Workspace({
    required this.id,
    required this.name,
    required this.owner,
    required this.members,
    required this.description,
    required this.memberCount,
    this.isOwner = false,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      owner: User.fromJson(json['owner']),
      memberCount: json['memberCount'] ?? (json['members'] as List<dynamic>?)?.length ?? 0,
      members: (json['members'] as List<dynamic>? ?? [])
          .map((m) => User.fromJson(m))
          .toList(),
      isOwner: json['isOwner'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'owner': owner.toJson(),
    'memberCount': memberCount,
    'members': members.map((m) => m.toJson()).toList(),
    'isOwner': isOwner,
  };
}
