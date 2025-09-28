class User {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt:
          json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
    );
  }
}
