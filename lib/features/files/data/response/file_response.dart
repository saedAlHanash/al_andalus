import 'package:al_andalus/core/extensions/extensions.dart';

import '../../../../core/strings/enum_manager.dart';

class FileResponse {
  FileResponse({
    required this.fileName,
    required this.originalFileName,
    required this.savedPath,
    required this.mime,
    required this.mediaType,
    required this.id,
  });

  final String fileName;
  final String originalFileName;
  final String savedPath;
  final String mime;
  final ResourceType mediaType;
  final String id;

  String get fileUrl => fileName.fixUrl;

  factory FileResponse.fromJson(Map<String, dynamic> json) {
    return FileResponse(
      fileName: json["fileName"] ?? "",
      originalFileName: json["originalFileName"] ?? "",
      savedPath: json["savedPath"] ?? "",
      mime: json["mime"] ?? "",
      mediaType: ResourceType.getByNameOrIndex((json["originalFileName"] ?? '').toString().fileExtension),
      id: json["id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "fileName": fileName,
    "originalFileName": originalFileName,
    "savedPath": savedPath,
    "mime": mime,
    "mediaType": mediaType.index,
    "id": id,
  };
}
