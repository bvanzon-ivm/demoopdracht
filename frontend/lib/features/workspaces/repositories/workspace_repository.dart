import '../models/workspace.dart';
import '../services/workspace_service.dart';

class WorkspaceRepository {
  final WorkspaceService api;
  WorkspaceRepository(this.api);

  Future<List<Workspace>> list() => api.fetchWorkspaces();
  Future<Workspace> get(int id) => api.getWorkspace(id);
  Future<Workspace> create(String name, String description) => api.createWorkspace(name, description);
  Future<void> addUser(int workspaceId, String email) =>
      api.addUser(workspaceId, email);
  Future<void> removeUser(int workspaceId, int userId) =>
      api.removeUser(workspaceId, userId);
  Future<List<Map<String, dynamic>>> audit(int workspaceId) =>
      api.fetchAuditLogs(workspaceId);
}
