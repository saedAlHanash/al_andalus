import 'package:al_andalus/core/helper/launcher_helper.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../generated/assets.dart';
import '../../bloc/support_info_cubit/support_info_cubit.dart';

void showSupportCall(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return BlocBuilder<SupportInfoCubit, SupportInfoInitial>(
        builder: (context, state) {
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
                // padding: const EdgeInsets.symmetric(horizontal: 20.0).r,
                child: Column(
                  children: [
                    DrawableText(
                      text: 'الدعم الفني',
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
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: AppColorManager.mainColor),
                      ),
                      onTap: () {
                        LauncherHelper.sendEmail(email: state.result.email);
                      },
                      title: DrawableText(text: state.result.email),
                      trailing: ImageMultiType(
                        url: Assets.iconsEmail,
                      ),
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: AppColorManager.mainColor),
                      ),
                      onTap: () {
                        LauncherHelper.sendWhatsApp(phone: state.result.whatsApp);
                      },
                      title: DrawableText(text: state.result.whatsApp),
                      trailing: ImageMultiType(
                        url: Assets.iconsWhatsapp,
                      ),
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: AppColorManager.mainColor),
                      ),
                      onTap: () {
                        LauncherHelper.callPhone(phone: state.result.phone);
                      },
                      title: DrawableText(text: state.result.phone),
                      trailing: ImageMultiType(
                        url: Assets.iconsPhone,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
