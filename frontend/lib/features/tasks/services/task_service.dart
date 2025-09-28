import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../models/task.dart';

class TaskService {
  Future<List<Task>> getTasks(String token, int workspaceId) async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/workspaces/$workspaceId/tasks'),
      headers: ApiConfig.authHeaders(token),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks: ${res.body}');
    }
  }

  Future<Task> getTask(String token, int workspaceId, int taskId) async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/workspaces/$workspaceId/tasks/$taskId'),
      headers: ApiConfig.authHeaders(token),
    );

    if (res.statusCode == 200) {
      return Task.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load task: ${res.body}');
    }
  }

  Future<Task> createTask(String token, int workspaceId, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/workspaces/$workspaceId/tasks'),
      headers: ApiConfig.authHeaders(token),
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      return Task.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to create task: ${res.body}');
    }
  }

  Future<Task> updateTask(String token, int workspaceId, int taskId, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/workspaces/$workspaceId/tasks/$taskId'),
      headers: ApiConfig.authHeaders(token),
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      return Task.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to update task: ${res.body}');
    }
  }

  Future<void> deleteTask(String token, int workspaceId, int taskId) async {
    final res = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/workspaces/$workspaceId/tasks/$taskId'),
      headers: ApiConfig.authHeaders(token),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to delete task: ${res.body}');
    }
  }
}
