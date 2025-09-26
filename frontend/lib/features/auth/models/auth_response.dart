import 'user.dart';

class AuthResponse {
  final String token;
  final String type;
  final User user;

  AuthResponse({
    required this.token,
    required this.type,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: json['token'],
        type: json['type'] ?? 'Bearer',
        user: User.fromJson(json['user']),
      );
}
