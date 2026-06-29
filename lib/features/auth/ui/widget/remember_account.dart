import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/shared_preferences.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';

class RememberPassword extends StatelessWidget {
  const RememberPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      text: S.of(context).iRememberedMyPassword,
      color: AppColorManager.grey,
      drawablePadding: 7.0.w,
      drawableEnd: InkWell(
        onTap: () {
          AppSharedPreference.removePhone().then((value) {
            context.goNamed(RouteName.login);
          });
        },
        child: DrawableText(
          color: AppColorManager.mainColor,
          fontWeight: .bold,
          text: '${S.of(context).login}.',
        ),
      ),
    );
  }
}

class RememberAccount extends StatelessWidget {
  const RememberAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        DrawableText(
          text: S.of(context).iWantToChangeAccount,
          color: AppColorManager.grey,
          drawablePadding: 7.0.w,
          padding: EdgeInsets.only(bottom: 20.0),
          drawableEnd: InkWell(
            onTap: () async {
              await AppSharedPreference.removePhone();
              await AppSharedPreference.cashStartPage(StartPage.login);
              if (context.mounted) {
                context.goNamed(RouteName.login);
              }
            },
            child: DrawableText(
              color: AppColorManager.mainColor,
              fontWeight: .bold,
              text: '${S.of(context).changeAccount}.',
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
