import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/go_router.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../generated/l10n.dart';

class AskAuthWidget extends StatelessWidget {
  const AskAuthWidget({super.key, this.login});

  final bool? login;

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      text: login == null
          ? S.of(context).iRememberMyPassword
          : login!
          ? S.of(context).createNewAccountQuestion
          : S.of(context).doYouHaveAccount,
      matchParent: true,
      padding: const EdgeInsets.symmetric(horizontal: 24.0).w,
      drawableAlin: DrawableAlin.between,
      drawableEnd: TextButton(
        onPressed: () {
          context.goNamed(
            (login ?? false) ? RouteName.signup : RouteName.login,
          );
        },
        child: DrawableText(
          text: (login ?? false) ? S.of(context).register : S.of(context).login,
          color: AppColorManager.mainColor,
          fontWeight: .bold,
        ),
      ),
    );
  }
}
