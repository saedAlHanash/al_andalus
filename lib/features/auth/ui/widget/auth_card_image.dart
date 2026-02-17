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
              onTap: () => _showLanguageDialog(context),
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
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0).r),
          child: Padding(
            padding: const EdgeInsets.all(20.0).r,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DrawableText(
                  text: 'اللغة / Language',
                  fontFamily: FontManager.bold.name,
                  size: 18.0.sp,
                ),
                20.0.verticalSpace,
                _buildLanguageItem(context, 'English', 'en'),
                10.0.verticalSpace,
                _buildLanguageItem(context, 'العربية', 'ar'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(BuildContext context, String name, String code) {
    var isSelected = AppSharedPreference.getLocal == code;
    return InkWell(
      onTap: () async {
        await MyApp.setLocale(context, code);
        if (context.mounted) context.pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0).r,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColorManager.mainColor),
          borderRadius: BorderRadius.circular(8.0).r,
          color: isSelected ? AppColorManager.mainColor : Colors.white,
        ),
        child: Center(
          child: DrawableText(
            text: name,
            color: isSelected ? Colors.white : AppColorManager.mainColor,
            fontFamily: FontManager.semeBold.name,
          ),
        ),
      ),
    );
  }
}
