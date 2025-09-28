import '../models/task.dart';
import '../services/task_service.dart';

class TaskRepository {
  final TaskService _service;

  TaskRepository(this._service);

  Future<List<Task>> getTasks(String token, int workspaceId) =>
      _service.getTasks(token, workspaceId);

  Future<Task> getTask(String token, int workspaceId, int taskId) =>
      _service.getTask(token, workspaceId, taskId);

  Future<Task> createTask(String token, int workspaceId, Map<String, dynamic> body) =>
      _service.createTask(token, workspaceId, body);

  Future<Task> updateTask(String token, int workspaceId, int taskId, Map<String, dynamic> body) =>
      _service.updateTask(token, workspaceId, taskId, body);

  Future<void> deleteTask(String token, int workspaceId, int taskId) =>
      _service.deleteTask(token, workspaceId, taskId);
}
