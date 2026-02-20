
import 'package:flutter/foundation.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';

import '../../core/api_manager/api_service.dart';
import '../../core/strings/enum_manager.dart';

CompressQuality? compressQuality = CompressQuality.q40;
CompressFormat? compressFormat = CompressFormat.webp;

//croppedImage
class CompressService {
  Future<Uint8List> compressImage(Uint8List list) async {
    return await _compressImagePlatforms(list);
  }

  Future<Uint8List> _compressImagePlatforms(Uint8List bytes) async {
    try {
      return await FlutterImageCompress.compressWithList(
        bytes,
        quality: compressQuality?.getQuality ?? CompressQuality.q20.getQuality,
        keepExif: true,
        autoCorrectionAngle: true,
        format: compressFormat ?? CompressFormat.webp,
      );
    } catch (e) {
      loggerObject.e(e);
      return bytes;
    }
  }

  Future<Uint8List> cropImage(Uint8List imageBytes, double targetAspectRatio) async {
    final image = decodeImage(imageBytes);

    if (image == null) {
      return Uint8List.fromList([]);
    }

    // حساب نسبة العرض إلى الارتفاع الحالية
    final currentAspectRatio = image.width / image.height;

    int newWidth, newHeight;
    if (currentAspectRatio > targetAspectRatio) {
      // اقتصاص العرض
      newHeight = image.height;
      newWidth = (newHeight * targetAspectRatio).toInt();
    } else {
      // اقتصاص الارتفاع
      newWidth = image.width;
      newHeight = (newWidth / targetAspectRatio).toInt();
    }

    // حساب نقطة البداية للاقتصاص
    final startX = (image.width - newWidth) ~/ 2;
    final startY = (image.height - newHeight) ~/ 2;

    // اقتصاص الصورة
    final croppedImage = img.copyCrop(image, x: startX, y: startY, width: newWidth, height: newHeight);

    return encodeJpg(croppedImage);
  }
}
