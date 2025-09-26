import '../models/task.dart';
import '../services/task_service.dart';

class TaskRepository {
  final TaskService api;
  TaskRepository(this.api);

  Future<List<Task>> list(int workspaceId) => api.fetchTasks(workspaceId);
  Future<Task> create(int workspaceId, Map<String, dynamic> payload) =>
      api.createTask(workspaceId, payload);
  Future<Task> get(int workspaceId, int id) => api.getTask(workspaceId, id);
  Future<Task> update(int workspaceId, int id, Map<String, dynamic> payload) =>
      api.updateTask(workspaceId, id, payload);
  Future<void> delete(int workspaceId, int id) => api.deleteTask(workspaceId, id);
  Future<List<Map<String, dynamic>>> audit(int workspaceId, int id) =>
      api.fetchAudit(workspaceId, id);
  Future<void> rollback(int workspaceId, int id, String field, int versionId) =>
      api.rollbackField(workspaceId, id, field, versionId);
}
