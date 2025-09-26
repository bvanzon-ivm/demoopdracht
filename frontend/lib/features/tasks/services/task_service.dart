import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../../../core/config/api_config.dart';

class TaskService {
  String get baseUrl => ApiConfig.baseUrl;
  String? get token => ApiConfig.token;

  TaskService();
  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

  Future<List<Task>> fetchTasks(int workspaceId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/workspaces/$workspaceId/tasks'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('Failed to load tasks');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Task.fromJson(e)).toList();
  }

  Future<Task> createTask(int workspaceId, Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/workspaces/$workspaceId/tasks'),
      headers: _headers,
      body: jsonEncode(data),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Failed to create task');
    }
    return Task.fromJson(jsonDecode(res.body));
  }

  Future<Task> updateTask(
    int workspaceId,
    int taskId,
    Map<String, dynamic> data,
  ) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/workspaces/$workspaceId/tasks/$taskId'),
      headers: _headers,
      body: jsonEncode(data),
    );
    if (res.statusCode != 200) throw Exception('Failed to update task ${res.body}');
    return Task.fromJson(jsonDecode(res.body));
  }

  Future<void> deleteTask(int workspaceId, int taskId) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/workspaces/$workspaceId/tasks/$taskId'),
      headers: _headers,
    );
    if (res.statusCode != 204) throw Exception('Failed to delete task');
  }

  Future<Task> getTask(int workspaceId, int taskId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/workspaces/$workspaceId/tasks/$taskId'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('Failed to get task');
    return Task.fromJson(jsonDecode(res.body));
  }

  Future<List<Map<String, dynamic>>> fetchAudit(
    int workspaceId,
    int taskId,
  ) async {
    final res = await http.get(
      Uri.parse('$baseUrl/workspaces/$workspaceId/tasks/$taskId/audit'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('Failed to fetch audit');
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }

  Future<void> rollbackField(
    int workspaceId,
    int taskId,
    String field,
    int versionId,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/workspaces/$workspaceId/tasks/$taskId/rollback'),
      headers: _headers,
      body: jsonEncode({'field': field, 'versionId': versionId}),
    );
    if (res.statusCode != 204) throw Exception('Failed to rollback');
  }
}
