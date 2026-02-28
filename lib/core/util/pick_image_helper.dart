import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class PickImageHelper {
  static final PickImageHelper _singleton = PickImageHelper._internal();

  factory PickImageHelper() {
    return _singleton;
  }

  PickImageHelper._internal();

  final _picker = ImagePicker();

  final List<String> _latestPath = [];

  Future<XFile?> pickImage({bool? removeLatestImage, ImageSource source = ImageSource.gallery}) async {
    if (removeLatestImage ?? false) removeAll();

    final result = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (result != null) _latestPath.add(result.path);

    return result;
  }

  Future<FilePickerResult?> pickFile(List<String>? allowedExtensions) async {
    return await FilePicker.platform.pickFiles(
      allowedExtensions: allowedExtensions,
      type: allowedExtensions != null ? FileType.custom : FileType.any,
      withData: true,
      allowMultiple: false,
      withReadStream: true,
    );
  }

  void removeImageFiles({required String path}) {
    if (path.isEmpty) return;
    try {
      File(path).delete();
    } on Exception catch (_) {}
  }

  void removeAll() {
    for (var e in _latestPath) {
      removeImageFiles(path: e);
    }
    _latestPath.clear();
  }

  Future<XFile?> pickImageBytes({ImageSource source = ImageSource.gallery}) async {
    final result = await pickImage(source: source);
    return result;
  }

  Future<XFile?> pickFileBytes(List<String>? allowedExtensions) async {
    final result = await pickFile(allowedExtensions);
    final file = result?.files.first;
    return file?.xFile;
  }
}
