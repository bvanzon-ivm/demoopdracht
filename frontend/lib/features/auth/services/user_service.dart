import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../models/user.dart';

class UserService {
  Future<List<User>> searchUsers(String token, String query) async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users/search?email=$query'),
      headers: ApiConfig.authHeaders(token),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search users: ${res.body}');
    }
  }
}
