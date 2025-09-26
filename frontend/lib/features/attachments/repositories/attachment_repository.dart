import '../models/attachment.dart';
import '../services/attachment_service.dart';

class AttachmentRepository {
  final AttachmentService api;
  AttachmentRepository(this.api);

  Future<List<Attachment>> list(int workspaceId, int taskId) =>
      api.fetchAttachments(workspaceId, taskId);

  Future<void> upload(int workspaceId, int taskId, String fileName, List<int> bytes) =>
      api.uploadAttachment(workspaceId, taskId, fileName, bytes);

  Future<void> delete(int workspaceId, int taskId, int attachmentId) =>
      api.deleteAttachment(workspaceId, taskId, attachmentId);
}
