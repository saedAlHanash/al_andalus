import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/auth/ui/widget/custom_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../bloc/signup_cubit/signup_cubit.dart';
import '../widget/signup_steps/driving_license.dart';
import '../widget/signup_steps/identity_info.dart';
import '../widget/signup_steps/phone_number.dart';

import 'package:al_andalus/features/auth/ui/widget/signup_steps/signup_validator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupCubit get signupCubit => context.read<SignupCubit>();

  SignupInitial get signupState => context.read<SignupCubit>().state;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupInitial>(
      listenWhen: (p, c) => c.done,
      listener: (context, state) {
        context.goNamed(RouteName.confirmCode);
      },
      child: BlocBuilder<SignupCubit, SignupInitial>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBarWidget(titleText: S.of(context).signUp),
            bottomNavigationBar: Padding(
              padding: EdgeInsetsGeometry.all(20.0),
              child: MyButton(
                onTap: () {
                  final request = state.mRequest;
                  if (!SignupValidator.validateStep(context, state.step, request)) return;

                  if (state.step >= 2) {
                    context.read<SignupCubit>().signup();
                    return;
                  }
                  context.read<SignupCubit>().next();
                },
                loading: state.loading,
                text: S.of(context).continueTo,
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 37.0).r,
                  child: CustomStepperWidget(
                    activeStep: state.step,
                    onStepReached: (p0) {
                      final request = state.mRequest;
                      if (p0 > state.step) {
                        for (int i = state.step; i < p0; i++) {
                          if (!SignupValidator.validateStep(context, i, request)) return;
                        }
                      }
                      context.read<SignupCubit>().next(step: p0);
                    },
                    steps: [
                      customStepWidget(
                        title: S.of(context).info,
                        isCompleted: state.step > 0,
                        isSelected: state.step == 0,
                      ),
                      customStepWidget(
                        title: S.of(context).drivingLicense,
                        isCompleted: state.step > 1,
                        isSelected: state.step == 1,
                      ),
                      customStepWidget(
                        title: S.of(context).phoneNumber,
                        isCompleted: state.step > 2,
                        isSelected: state.step == 2,
                      ),
                      customStepWidget(
                        title: S.of(context).verificationCode,
                        isCompleted: state.step > 3,
                        isSelected: state.step == 3,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: switch (state.step) {
                    0 => IdentityInfo(),
                    1 => DrivingLicense(),
                    2 => PhoneNumber(),
                    3 => Container(),

                    int() => SizedBox(),
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
