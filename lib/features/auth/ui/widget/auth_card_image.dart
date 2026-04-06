import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/util/bottom_sheets.dart';
import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../generated/assets.dart';

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
    return Directionality(
      textDirection: .rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: .start,
        children: [
          Container(
            width: 50.0.w,
            child: BackBtnWidget(
              appBarColor: AppColorManager.mainColorLight,
            ),
          ),
          ImageMultiType(
            url: Assets.imagesLogo,
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
    );
  }
}
