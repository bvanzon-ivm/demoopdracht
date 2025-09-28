import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../models/auth_response.dart';
import '../models/user.dart';

class AuthService {
  Future<AuthResponse> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/login'),
      headers: ApiConfig.baseHeaders,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Login failed: ${res.body}');
    }
  }

  Future<AuthResponse> register(String name, String email, String password) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/register'),
      headers: ApiConfig.baseHeaders,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Register failed: ${res.body}');
    }
  }

  Future<User> getCurrentUser(String token) async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/auth/me'),
      headers: ApiConfig.authHeaders(token),
    );

    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to fetch current user: ${res.body}');
    }
  }
}
