import '../models/user.dart';
import '../services/user_service.dart';

class UserRepository {
  final UserService _service;
  UserRepository(this._service);

  Future<List<User>> searchUsers(String token, String query) {
    return _service.searchUsers(token, query);
  }
}
