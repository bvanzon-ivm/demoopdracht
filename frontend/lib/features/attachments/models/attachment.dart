class Attachment {
  final int id;
  final String fileName;
  final String contentType;
  final int size;
  final DateTime uploadedAt;
  final int uploadedBy;

  Attachment({
    required this.id,
    required this.fileName,
    required this.contentType,
    required this.size,
    required this.uploadedAt,
    required this.uploadedBy,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      fileName: json['fileName'],
      contentType: json['contentType'],
      size: json['size'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      uploadedBy: json['uploadedBy'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileName': fileName,
        'contentType': contentType,
        'size': size,
        'uploadedAt': uploadedAt.toIso8601String(),
        'uploadedBy': uploadedBy,
      };
}
