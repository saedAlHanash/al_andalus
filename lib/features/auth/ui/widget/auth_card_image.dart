import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/util/bottom_sheets.dart';
import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/assets.dart';
import '../../../../core/app/app_widget.dart';
import '../../../../core/util/shared_preferences.dart';
import 'package:image_multi_type/image_multi_type.dart';

class AuthCardImage extends StatefulWidget {
  const AuthCardImage({super.key, required this.titleText, required this.description, this.back = true});

  final String titleText;
  final String description;
  final bool back;

  @override
  State<AuthCardImage> createState() => _AuthCardImageState();
}

class _AuthCardImageState extends State<AuthCardImage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        20.0.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: .start,
          children: [
            Container(
              width: 50.0.w,
              margin: EdgeInsetsDirectional.only(start: 10.0.w),
              child: BackBtnWidget(
                appBarColor: AppColorManager.mainColorLight,
              ),
            ),
            ImageMultiType(
              url: Assets.imagesLogoAuth,
              height: 100.0.r,
              fit: .fill,
              width: 100.0.r,
            ),
            InkWell(
              onTap: () => showLanguageDialog(context),
              child: ImageMultiType(
                url: Assets.iconsLanguage,
                height: 40.0.r,
                width: 40.0.r,
              ),
            ),
          ],
        ),
        // 20.0.verticalSpace,
        // DrawableText(
        //   text: titleText,
        //   matchParent: true,
        //   textAlign: TextAlign.center,
        //   size: 30.0,
        //   padding: const EdgeInsets.symmetric(horizontal: 60.0),
        //   color: AppColorManager.mainColor,
        //   fontWeight: FontWeight.bold,
        // ),
        // 12.0.verticalSpace,
        // DrawableText(
        //   padding: const EdgeInsets.symmetric(horizontal: 60.0),
        //   text: description,
        //   matchParent: true,
        //   color: AppColorManager.mainColor,
        //   textAlign: TextAlign.center,
        // ),
      ],
    );
  }
}

