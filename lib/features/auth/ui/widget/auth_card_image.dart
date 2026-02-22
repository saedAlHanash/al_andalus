import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';

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
                height: 50.0.r,
                width: 50.0.r,
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

void showLanguageDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
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
          DrawableText(
            text: 'اختر اللغة',
            size: 20.0.sp,
            matchParent: true,
            drawableAlin: .between,
            textAlign: .center,
            padding: EdgeInsets.symmetric(horizontal: 20.0).r,
            drawableEnd: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: ImageMultiType(url: Icons.cancel_outlined),
            ),
            drawableStart: IconButton(
              onPressed: null,
              icon: ImageMultiType(
                url: Icons.cancel_outlined,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20.0).r,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    MyApp.setLocale(context, 'ar');
                  },
                  title: DrawableText(text: 'العربية'),
                  leading: ImageMultiType(
                    url: AppSharedPreference.getLocal == 'ar' ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: AppColorManager.mainColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    MyApp.setLocale(context, 'kr');
                  },
                  title: DrawableText(text: 'كوردى'),
                  leading: ImageMultiType(
                    url: AppSharedPreference.getLocal == 'kr' ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: AppColorManager.mainColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    MyApp.setLocale(context, 'en');
                  },
                  title: DrawableText(text: 'English'),
                  leading: ImageMultiType(
                    url: AppSharedPreference.getLocal == 'en' ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: AppColorManager.mainColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

