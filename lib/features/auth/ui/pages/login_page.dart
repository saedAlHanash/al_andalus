import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/services/biometric_auth_service.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/auth_card_image.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../../notification/bloc/all_notification_cubit/all_notification_cubit.dart';
import '../../../profile/bloc/get_me_cubit/get_me_cubit.dart';
import '../../bloc/login_cubit/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginCubit get loginCubit => context.read<LoginCubit>();

  final _formKey = GlobalKey<FormState>();

  void updateData() {
    context.read<GetMeCubit>().getData(newData: true);
    context.read<NotificationCubit>().getData(newData: true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginInitial>(
          listenWhen: (p, c) => c.done,
          listener: (context, state) async {
            updateData();
            final enabled = await BiometricAuthService().isBiometricEnabled();
            if (context.mounted) {
              if (!enabled) {
                context.goNamed(RouteName.biometricEnroll, queryParameters: {'fromLogin': 'true'});
              } else {
                context.goNamed(RouteName.home);
                if (AppProvider.insurancePage.isNotEmpty) {
                  context.pushNamed(
                    RouteName.insurancePage,
                    queryParameters: AppProvider.insurancePage,
                  );
                }
              }
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBarWidget(zeroHeight: true),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Spacer(),
              DrawableText(
                text: S.of(context).doNotHaveAnAccount,
                drawableEnd: TextButton(
                  onPressed: () => context.pushNamed(RouteName.signup),
                  child: DrawableText(
                    fontWeight: .bold,
                    color: AppColorManager.mainColor,
                    text: S.of(context).createNewAccount,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0).r,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AuthCardImage(
                  titleText: S.of(context).logInToYourAccount,
                  description: S.of(context).enterYourPhoneAndPasswordToLogIn,
                  back: false,
                ),
                30.0.verticalSpace,
                AutofillGroup(
                  child: Column(
                    children: [
                      MyTextFormOutLineWidget(
                        autofillHints: const [AutofillHints.username, AutofillHints.telephoneNumber],
                        validator: (p0) => p0.validateEmpty,
                        hint: S.of(context).phoneNumber,
                        initialValue: loginCubit.state.mRequest.phone,
                        keyBordType: TextInputType.phone,
                        onChanged: (val) => loginCubit.setPhone = val,
                      ),
                      MyTextFormOutLineWidget(
                        autofillHints: const [AutofillHints.password],
                        validator: (p0) => loginCubit.validatePassword,
                        // labelText: S.of(context).password,
                        keyBordType: .number,
                        hint: S.of(context).pinCode,
                        obscureText: true,
                        initialValue: loginCubit.state.mRequest.password,
                        onChanged: (val) => loginCubit.setPassword = val,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.pushNamed(
                      RouteName.forgetPassword,
                      queryParameters: {'phone': loginCubit.state.mRequest.phone},
                    );
                  },
                  child: DrawableText(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    matchParent: true,
                    text: S.of(context).forgetPassword,
                    color: AppColorManager.mainColor,
                    textDecoration: .underline,
                    fontWeight: .bold,
                  ),
                ),

                10.0.verticalSpace,
                BlocBuilder<LoginCubit, LoginInitial>(
                  builder: (_, state) {
                    return Column(
                      children: [
                        MyButton(
                          text: S.of(context).login,
                          loading: state.loading,
                          onTap: () async {
                            if (!_formKey.currentState!.validate()) return;
                            TextInput.finishAutofillContext();
                            loginCubit.login();
                          },
                        ),
                        10.0.verticalSpace,
                        IconButton(
                          icon: const Icon(Icons.fingerprint, size: 40, color: AppColorManager.mainColor),
                          onPressed: () {
                            loginCubit.loginWithBiometric();
                          },
                        ),
                      ],
                    );
                  },
                ),
                10.0.verticalSpace,
                OutLineButton(
                  text: S.of(context).guestLogin,
                  color: Colors.white,
                  onTap: () async {
                    context.pushNamed(RouteName.home);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
