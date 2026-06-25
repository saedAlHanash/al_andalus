import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/auth_card_image.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/util/bottom_sheets.dart';
import '../../../../core/util/my_style.dart';
import '../../../../core/util/shared_preferences.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../bloc/forget_password_cubit/forget_password_cubit.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key, this.phone});

  final String? phone;

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late final ForgetPasswordCubit forgetPasswordCubit;

  @override
  void initState() {
    forgetPasswordCubit = context.read<ForgetPasswordCubit>();

    if (widget.phone != null) {
      forgetPasswordCubit.setPhone = widget.phone;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordInitial>(
      listenWhen: (p, c) => c.done,
      listener: (context, state) {
        context.goNamed(RouteName.resetPasswordPage);
      },

      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Spacer(),
              DrawableText(
                text: S.of(context).rememberPassword,
                drawableEnd: TextButton(
                  onPressed: () => context.goNamed(RouteName.login),
                  child: DrawableText(
                    fontWeight: .bold,
                    text: S.of(context).login,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        appBar: AppBarWidget(
          title: ImageMultiType(
            url: Assets.imagesLogo,
            height: 110.0.r,
            width: 110.0.r,
            // fit: .fill,
          ),
          actions: [
            InkWell(
              onTap: () => showLanguageDialog(context),
              child: ImageMultiType(
                url: Assets.iconsLanguage,
                height: 40.0.r,
                width: 40.0.r,
              ),
            ),
            20.0.horizontalSpace,
          ],
        ),
        body: SingleChildScrollView(
          padding: MyStyle.pagePadding,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0).r,
                margin: const EdgeInsets.symmetric(vertical: 20.0).r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0).r,
                  // boxShadow: [BoxShadow(color: AppColorManager.black.withValues(alpha: 0.06), blurRadius: 24)],
                ),
                child: Column(
                  children: [
                    MyTextFormOutLineWidget(
                      hint: '07xxxxxxxxxx',
                      textDirection: TextDirection.ltr,
                      iconWidgetLift: Row(
                        mainAxisSize: .min,
                        children: [
                          15.0.horizontalSpace,
                          DrawableText(
                            text: AppSharedPreference.getLocal == 'en' ? '+964' : '964+',
                            fontWeight: .bold,
                          ),
                          15.0.horizontalSpace,
                          ImageMultiType(
                            url: Assets.iconsFlagOfIraq,
                            height: 24.h,
                            width: 24.w,
                          ),
                          15.0.horizontalSpace,
                        ],
                      ),
                      keyBordType: .phone,
                      initialValue: widget.phone,
                      label: S.of(context).phoneNumber,
                      validator: (p0) => forgetPasswordCubit.validatePhone,
                      onChanged: (val) => forgetPasswordCubit.setPhone = val,
                    ),
                    BlocBuilder<ForgetPasswordCubit, ForgetPasswordInitial>(
                      builder: (_, state) {
                        if (state.loading) {
                          return MyStyle.loadingWidget();
                        }
                        return MyButton(
                          text: S.of(context).continueTo,
                          onTap: () {
                            forgetPasswordCubit.forgetPassword();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
