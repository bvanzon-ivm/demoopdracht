import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/attachment.dart';
import '../../../core/config/api_config.dart';

class AttachmentService {
  String get baseUrl => ApiConfig.baseUrl;
  String? get token => ApiConfig.token;

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    if (token != null) "Authorization": "Bearer $token",
  };

  Future<List<Attachment>> fetchAttachments(int workspaceId, int taskId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/workspaces/$workspaceId/tasks/$taskId/attachments'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to load attachments: ${res.body}');
    }
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Attachment.fromJson(e)).toList();
  }

  Future<void> uploadAttachment(
    int workspaceId,
    int taskId,
    String fileName,
    List<int> bytes, {
    String contentType = 'application/octet-stream',
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/workspaces/$workspaceId/tasks/$taskId/attachments'),
    )
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
        contentType: MediaType.parse(contentType),
      ));

    final res = await request.send();
    if (res.statusCode != 201) {
      throw Exception('Failed to upload attachment (status ${res.statusCode})');
    }
  }

  Future<void> deleteAttachment(
      int workspaceId, int taskId, int attachmentId) async {
    final res = await http.delete(
      Uri.parse(
          '$baseUrl/workspaces/$workspaceId/tasks/$taskId/attachments/$attachmentId'),
      headers: _headers,
    );
    if (res.statusCode != 204) {
      throw Exception('Failed to delete attachment: ${res.body}');
    }
  }
}
