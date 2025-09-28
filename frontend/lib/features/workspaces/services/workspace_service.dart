import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../../auth/models/user.dart';
import '../models/workspace.dart';

class WorkspaceService {
  Future<List<Workspace>> getWorkspaces(String token) async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/workspaces'),
      headers: ApiConfig.authHeaders(token),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((json) => Workspace.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch workspaces: ${res.body}');
    }
  }

  Future<Workspace> getWorkspaceById(String token, int id) async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/workspaces/$id'),
      headers: ApiConfig.authHeaders(token),
    );

    if (res.statusCode == 200) {
      return Workspace.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to fetch workspace: ${res.body}');
    }
  }
  Future<Workspace> createWorkspace(String token, Map<String, dynamic> body) async {
  final res = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/workspaces'),
    headers: ApiConfig.authHeaders(token),
    body: jsonEncode(body),
  );

  if (res.statusCode == 200) {
    return Workspace.fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Failed to create workspace: ${res.body}');
  }
}
Future<List<Map<String, dynamic>>> getMembers(
    String token, int workspaceId) async {
  final res = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/workspaces/$workspaceId/members'),
    headers: ApiConfig.authHeaders(token),
  );
  if (res.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  } else {
    throw Exception('Failed to load members: ${res.body}');
  }
}

Future<Map<String, dynamic>> addMember(
    String token, int workspaceId, int userId) async {
  final res = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/workspaces/$workspaceId/members'),
    headers: ApiConfig.authHeaders(token),
    body: jsonEncode({
      "user": {"id": userId},
      "role": "MEMBER",
    }),
  );
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else {
    throw Exception('Failed to add member: ${res.body}');
  }
}
}
