class User {
  final int id;
  final String email;
  final String? passwordHash;
  final String name;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? lastLoginAt;

  User({
    required this.id,
    required this.email,
    this.passwordHash,
    required this.name,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    passwordHash: json['passwordHash'],
    name: json['name'],
    isActive: json['isActive'] ?? true,
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
    lastLoginAt: json['lastLoginAt'],
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'passwordHash': passwordHash,
    'name': name,
    'isActive': isActive,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'lastLoginAt': lastLoginAt,
  };
}
