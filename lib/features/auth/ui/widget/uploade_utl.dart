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

void showOptionBottomSheet(BuildContext context, Function(UploadFile value) onConfirm) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageMultiType(
            url: Assets.iconsBottomSheetHeader,
            width: 1.0.sw,
            color: Colors.white,
            height: 30.0.h,
            fit: BoxFit.fill,
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20.0).r,
            child: Column(
              children: [
                ImageMultiType(
                  url: Assets.imagesIdScan,
                  height: 192.0.h,
                ),
                DrawableText(
                  text:
                      'تأكد أن النص واضح وقابل للقراءة '
                      '\n\n'
                      'يرجى تجنب الوهج أو الانعكاسات الضوئية على الهوية و أبقِ الخلفية خالية من أي مشتتات',
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),

                10.0.verticalSpace,
                MyButton(
                  text: 'رفع من الملفات',
                  icon: ImageMultiType(url: Icons.file_upload_outlined),
                  onTap: () {
                    Navigator.pop(ctx);
                    pickAndUpload().then(
                      (value) async {
                        if (value == null || !context.mounted) return;
                        final result = await showConfirmDialog(context, value);
                        if (result == false) return;
                        onConfirm.call(value);
                      },
                    );
                  },
                ),
                10.0.verticalSpace,
                MyButton(
                  text: 'التقط صورة',
                  icon: ImageMultiType(url: Icons.camera_alt_outlined),
                  onTap: () {
                    Navigator.pop(ctx);
                    takePhoto().then(
                      (value) async {
                        if (value == null || !context.mounted) return;
                        final result = await showConfirmDialog(context, value);
                        if (result == false) return;
                        onConfirm.call(value);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<dynamic> showConfirmDialog(BuildContext context, UploadFile file) async {
  return await showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0).r),
        title: Center(
          child: DrawableText(
            text: S.of(context).previewFile,
            size: 18.0,
            textAlign: TextAlign.center,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (file.fileType == FileType.image && file.fileBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0).r,
                child: Image.memory(
                  file.fileBytes!,
                  height: 200.h,
                  fit: BoxFit.cover,
                ),
              )
            else
              Column(
                children: [
                  Icon(Icons.insert_drive_file, size: 60.r, color: AppColorManager.mainColor),
                  10.verticalSpace,
                  DrawableText(
                    text: (file.localId ?? '').split('/').last,
                    size: 14.0,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(ctx, false),
                    child: DrawableText(text: S.of(context).cancel, color: Colors.white),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColorManager.mainColor),
                    onPressed: () {
                      Navigator.pop(ctx, true);
                    },
                    child: DrawableText(text: S.of(context).confirm, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<UploadFile?> pickAndUpload({String? nameFiled}) async {
  final helper = PickImageHelper();
  final xFile = (await helper.pickFileBytes());
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
    loggerObject.w(e);
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
