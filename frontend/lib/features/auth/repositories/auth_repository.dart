import '../models/auth_response.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);

  Future<AuthResponse> login(String email, String password) {
    return _service.login(email, password);
  }

  Future<AuthResponse> register(String name, String email, String password) {
    return _service.register(name, email, password);
  }

  Future<User> getCurrentUser(String token) {
    return _service.getCurrentUser(token);
  }
}
