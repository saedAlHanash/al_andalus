import 'dart:ui';

import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/strings/app_color_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/pick_image_helper.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/images/compress_service.dart';


Future<UploadFile?> pickAndUpload({String? nameFiled,List<String>? allowedExtensions}) async {
  final helper = PickImageHelper();
  final xFile = (await helper.pickFileBytes(allowedExtensions));
  if (xFile == null) return null;
  var bytes = await xFile.readAsBytes();
  bytes = await CompressService().compressImage(bytes);
  return UploadFile(
    fileBytes: bytes,
    fileType: xFile.name.fileType,
    localId: xFile.name,
    nameField: nameFiled ?? 'File',
    path: xFile.path,
    extension: xFile.name.fileExtension,
  );
}

Future<UploadFile?> takePhoto({String? nameFiled}) async {
  final helper = PickImageHelper();

  final xFile = await helper.pickImageBytes(source: ImageSource.camera);
  if (xFile == null) return null;
  var bytes = await xFile.readAsBytes();

  try {
    if (xFile.name.fileType == FileType.image) {
      bytes = await CompressService().compressImage(bytes);
    }
  } catch (e) {
    loggerObject.e(e);
  }

  return UploadFile(
    fileBytes: bytes,
    fileType: xFile.name.fileType,
    localId: xFile.name,
    path: xFile.path,
    nameField: nameFiled ?? 'File',
    extension: xFile.name.fileExtension,
  );
}
