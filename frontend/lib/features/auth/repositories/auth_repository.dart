import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/config/api_config.dart';
import '../models/auth_response.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService service;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthRepository(this.service);

  Future<AuthResponse> login(String email, String password) async {
    final resp = await service.login(email, password);
    await _persistAuth(resp);
    return resp;
  }

  Future<AuthResponse> register(String name, String email, String password) async {
    final resp = await service.register(name, email, password);
    await _persistAuth(resp);
    return resp;
  }

  Future<void> logout() async {
    ApiConfig.token = null;
    await storage.delete(key: "token");
  }

  Future<bool> hasToken() async {
    return await storage.read(key: "token") != null;
  }

  Future<void> _persistAuth(AuthResponse resp) async {
    ApiConfig.token = resp.token;
    await storage.write(key: "token", value: resp.token);
  }
}
