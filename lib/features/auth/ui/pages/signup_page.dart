import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/auth_card_image.dart';
import 'package:al_andalus/features/auth/ui/widget/custom_stepper_widget.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/signup_cubit/signup_cubit.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupCubit get signupCubit => context.read<SignupCubit>();

  SignupInitial get signupState => context.read<SignupCubit>().state;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupInitial>(
      listenWhen: (p, c) => c.done,
      listener: (context, state) {
        context.goNamed(RouteName.confirmCode);
      },
      child: Scaffold(
        appBar: AppBarWidget(titleText: S.of(context).signUp),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 37.0).r,
              child: CustomStepperWidget(
                activeStep: 2,
                steps: [
                  customStepWidget(
                    title: 'الموحدة',
                    isCompleted: true,
                  ),
                  customStepWidget(
                    title: 'إجازة السوق',
                    isCompleted: false,
                  ),
                  customStepWidget(
                    title: 'رقم الهاتف',
                    isCompleted: false,
                  ),
                  customStepWidget(
                    title: 'رمز التحقق',
                    isCompleted: false,
                  ),
                  customStepWidget(
                    title: 'رمز التطبيق',
                    isCompleted: false,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0).r,
              margin: const EdgeInsets.all(20.0).r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0).r,
                // boxShadow: [BoxShadow(color: AppColorManager.black.withValues(alpha: 0.06), blurRadius: 24)],
              ),
              child: Form(
                key: _formKey,
                child: BlocBuilder<SignupCubit, SignupInitial>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,

                        //name
                        MyTextFormOutLineWidget(
                          validator: (p0) => signupCubit.validateName,
                          initialValue: signupState.request.name,
                          // labelText: S.of(context).fullName,
                          hint: S.of(context).fullName,
                          onChanged: (val) => signupCubit.setName = val,
                        ),

                        // رقم الهاتف
                        MyTextFormOutLineWidget(
                          validator: (p0) => signupCubit.validatePhone,
                          initialValue: signupState.request.phone,
                          keyBordType: TextInputType.phone,
                          // labelText: S.of(context).phoneNumber,
                          hint: S.of(context).phoneNumberMustStartWith07,
                          onChanged: (val) => signupCubit.setPhone = val,
                        ),
                        // //البريد
                        // MyTextFormOutLineWidget(
                        //   validator: (p0) => p0.validateEmpty,
                        //   initialValue: signupState.request.email,
                        //   keyBordType: TextInputType.emailAddress,
                        //   hint: S.of(context).email,
                        //   onChanged: (val) => signupCubit.setEmail = val,
                        // ),
                        // كلمة السر
                        MyTextFormOutLineWidget(
                          validator: (p0) => signupCubit.validatePassword,
                          // labelText: S.of(context).password,
                          hint: S.of(context).password,
                          initialValue: signupState.request.password,
                          obscureText: true,
                          onChanged: (val) => signupCubit.setPassword = val,
                          textDirection: TextDirection.ltr,
                        ),
                        // كلمة السر
                        MyTextFormOutLineWidget(
                          validator: (p0) => signupCubit.validateRePassword,
                          // labelText: S.of(context).rePassword,
                          hint: S.of(context).rePassword,
                          obscureText: true,
                          initialValue: signupState.request.rePassword,
                          onChanged: (val) => signupCubit.setRePassword = val,
                          textDirection: TextDirection.ltr,
                        ),

                        10.0.verticalSpace,
                        BlocBuilder<SignupCubit, SignupInitial>(
                          builder: (context, state) {
                            return MyButton(
                              loading: state.loading,
                              text: S.of(context).signUp,
                              onTap: () {
                                if (!_formKey.currentState!.validate()) return;
                                signupCubit.signup();
                              },
                              // Navigator.pushNamed(context, RouteName.secSign);                          },
                            );
                          },
                        ),
                        40.0.verticalSpace,
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
