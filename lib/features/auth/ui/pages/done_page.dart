import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/auth/ui/widget/slider.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';

class DonePage extends StatelessWidget {
  const DonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(titleText: S.of(context).signUp),
      body: Column(
        children: [
          SliderSignup(step: 5),
          Lottie.asset(
            Assets.images.done.path,
            frameRate: .composition,
            filterQuality: .medium,
            width: 1.0.sw,
            height: 0.4.sh,
            repeat: false,
            alignment: .bottomCenter,
          ),
          10.0.verticalSpace,
          DrawableText(
            text: S.of(context).congrats,
            size: 24.0.sp,
            fontWeight: .bold,
            textAlign: TextAlign.center,
          ),
          10.0.verticalSpace,
          DrawableText(
            text: S.of(context).yourAccountHasBeenSuccessfullyCreatedYouWillNowBe,
            size: 18.0.sp,
            padding: EdgeInsets.symmetric(horizontal: 50.0).r,
            textAlign: TextAlign.center,
          ),
          Spacer(),
          MyButton(
            onTap: () {
              context.goNamed(RouteName.splash);
            },
            text: S.of(context).done,
          ),
          20.0.verticalSpace,
        ],
      ),
    );
  }
}
