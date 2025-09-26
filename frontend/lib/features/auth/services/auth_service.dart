import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../models/auth_response.dart';

class AuthService {
  String get baseUrl => ApiConfig.baseUrl;
  String? get token => ApiConfig.token;

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    if (token != null) "Authorization": "Bearer $token",
  };

  Future<AuthResponse> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode != 200) {
      throw Exception("Login failed: ${res.body}");
    }

    final data = jsonDecode(res.body);
    return AuthResponse.fromJson(data);
  }

  Future<AuthResponse> register(
    String name,
    String email,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Register failed: ${res.body}");
    }

    final data = jsonDecode(res.body);
    return AuthResponse.fromJson(data);
  }
  
  /// Logout: verwijdert lokaal token en (optioneel) call naar backend
  Future<void> logout() async {
    try {
      // Optioneel: backend endpoint aanroepen
      final res = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _headers,
      );

      if (res.statusCode != 200 && res.statusCode != 204) {
        // Niet fatale fout: token wordt lokaal sowieso verwijderd
        print("Logout backend responded: ${res.statusCode} ${res.body}");
      }
    } catch (e) {
      print("Logout request failed: $e");
    }

    // Token lokaal verwijderen
    ApiConfig.token = null;
  }

}
