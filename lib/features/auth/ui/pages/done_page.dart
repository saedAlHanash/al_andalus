import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/go_router.dart';
import '../widget/custom_stepper_widget.dart';
import 'package:lottie/lottie.dart';

class DonePage extends StatelessWidget {
  const DonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(titleText: S.of(context).signUp),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 37.0).r,
            child: CustomStepperWidget(
              activeStep: 3,

              steps: [
                customStepWidget(
                  title: S.of(context).info,
                  isCompleted: true,
                ),
                customStepWidget(
                  title: S.of(context).drivingLicense,
                  isCompleted: true,
                ),
                customStepWidget(
                  title: S.of(context).phoneNumber,
                  isCompleted: true,
                ),
                customStepWidget(
                  title: S.of(context).verificationCode,
                  isCompleted: true,
                ),
              ],
            ),
          ),
          Lottie.asset(
            Assets.imagesDone,
            frameRate: .composition,
            filterQuality: .medium,
            width: 1.0.sw,
            height: 0.4.sh,
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
