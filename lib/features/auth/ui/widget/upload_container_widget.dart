import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/widgets/dotted_decoration.dart';

class UploadContainerWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Widget? child;

  const UploadContainerWidget({
    super.key,
    required this.title,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 1.0.sw,
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0).r,
        decoration: DottedDecoration(
          shape: .box,
          borderRadius: BorderRadius.circular(6.r),
          color: AppColorManager.mainColorDynamic,
        ),
        child:
            child ??
            Column(
              spacing: 8.h,
              children: [
                Icon(Icons.cloud_upload_outlined, color: AppColorManager.mainColorDynamic, size: 22.sp),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColorManager.mainColorDynamic),
                  ),
                  child: DrawableText(
                    text: S.of(context).browseFiles,
                  ),
                ),
                DrawableText(
                  text: title,
                  matchParent: true,
                  textAlign: .center,
                ),
              ],
            ),
      ),
    );
  }
}
