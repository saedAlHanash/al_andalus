import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

class IntroCardWidget extends StatelessWidget {
  const IntroCardWidget({super.key, required this.image, required this.title, required this.description});

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),

          // Image
          Container(
            height: 0.45.sh,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0.r)),
            child: ImageMultiType(url: image, fit: BoxFit.contain),
          ),

          48.0.verticalSpace,

          // Title
          DrawableText(
            text: title,
            matchParent: true,
            textAlign: TextAlign.center,
            size: 24.0.sp,
            fontWeight: FontWeight.bold,
          ),

          16.0.verticalSpace,

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: DrawableText(
              text: description,
              matchParent: true,
              textAlign: TextAlign.center,
              size: 16.0.sp,
              color: AppColorManager.grey,
            ),
          ),

          Spacer(flex: 2),
        ],
      ),
    );
  }
}
