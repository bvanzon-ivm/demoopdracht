import '../models/workspace.dart';
import '../services/workspace_service.dart';

class WorkspaceRepository {
  final WorkspaceService _service;

  WorkspaceRepository(this._service);

  Future<List<Workspace>> getWorkspaces(String token) {
    return _service.getWorkspaces(token);
  }

  Future<Workspace> getWorkspaceById(String token, int id) {
    return _service.getWorkspaceById(token, id);
  }

  Future<Workspace> createWorkspace(String token, Map<String, dynamic> body) {
    return _service.createWorkspace(token, body);
  }

  Future<List<Map<String, dynamic>>> getMembers(String token, int workspaceId) {
    return _service.getMembers(token, workspaceId);
  }

  Future<Map<String, dynamic>> addMember(
      String token, int workspaceId, int userId) {
    return _service.addMember(token, workspaceId, userId);
  }
}
