import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../models/workspace.dart';

class WorkspaceService {
  Future<List<Workspace>> fetchWorkspaces() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/workspaces'),
      headers: ApiConfig.headers,
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to fetch workspaces: ${res.body}");
    }

    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Workspace.fromJson(e)).toList();
  }

  Future<Workspace> getWorkspace(int id) async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/workspaces/$id'),
      headers: ApiConfig.headers,
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Failed to load workspace: ${res.body}");
    }

    return Workspace.fromJson(jsonDecode(res.body));
  }

  Future<Workspace> createWorkspace(String name, String description) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/workspaces'),
      headers: ApiConfig.headers,
      body: jsonEncode({'name': name, 'description': description}),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Failed to create workspace: ${res.body}");
    }

    return Workspace.fromJson(jsonDecode(res.body));
  }

  Future<void> addUser(int workspaceId, String email) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/workspaces/$workspaceId/users'),
      headers: ApiConfig.headers,
      body: jsonEncode({'email': email}),
    );

    if (res.statusCode != 204) {
      throw Exception("Failed to add user: ${res.body}");
    }
  }

  Future<void> removeUser(int workspaceId, int userId) async {
    final res = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/workspaces/$workspaceId/users/$userId'),
      headers: ApiConfig.headers,
    );

    if (res.statusCode != 204) {
      throw Exception("Failed to remove user: ${res.body}");
    }
  }

  Future<List<Map<String, dynamic>>> fetchAuditLogs(int workspaceId) async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/workspaces/$workspaceId/audit'),
      headers: ApiConfig.headers,
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Failed to load audit logs: ${res.body}");
    }

    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }
}
