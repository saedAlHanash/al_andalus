import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

// تأكد من استيراد الـ logger الخاص بك
// import '../../core/api_manager/api_service.dart';

class CompressService {
  // استخدام أحدث الإعدادات لعام 2026
  final int defaultQuality = 40;
  final CompressFormat defaultFormat = CompressFormat.webp;

  Future<Uint8List> compressImage(Uint8List list) async {
    // التحقق من صحة البيانات قبل البدء لتجنب SIGABRT على iOS
    if (list.isEmpty) {
      debugPrint("CompressService: Received empty list, skipping compression.");
      return list;
    }
    return await _compressImagePlatforms(list);
  }

  Future<Uint8List> _compressImagePlatforms(Uint8List bytes) async {
    if (bytes.isEmpty) return bytes;

    try {
      // إضافة فحص إضافي للتأكد من أن البيانات هي صورة صالحة قبل إرسالها للـ Native
      final result = await FlutterImageCompress.compressWithList(
        bytes,
        quality: 40,
        keepExif: true,
        format: Platform.isIOS ? .jpeg : .webp, // جرب تغييرها لـ .jpeg للتأكد من المحاكي
      );

      return result;
    } catch (e) {
      debugPrint("Compression failed: $e");
      return bytes;
    }
  }

  Future<Uint8List> cropImage(Uint8List imageBytes, double targetAspectRatio) async {
    // فك التشفير باستخدام مكتبة image
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      return Uint8List.fromList([]);
    }

    final currentAspectRatio = image.width / image.height;

    int newWidth, newHeight;
    if (currentAspectRatio > targetAspectRatio) {
      newHeight = image.height;
      newWidth = (newHeight * targetAspectRatio).toInt();
    } else {
      newWidth = image.width;
      newHeight = (newWidth / targetAspectRatio).toInt();
    }

    final startX = (image.width - newWidth) ~/ 2;
    final startY = (image.height - newHeight) ~/ 2;

    final croppedImage = img.copyCrop(image, x: startX, y: startY, width: newWidth, height: newHeight);

    // تحسين: استخدم encodeJpg أو encodePng بناءً على الحاجة
    // لكن تذكر أن الضغط النهائي سيحولها لـ WebP في دالتك الأخرى
    return Uint8List.fromList(img.encodeJpg(croppedImage));
  }
}
