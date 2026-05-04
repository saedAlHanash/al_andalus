import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/auth/ui/widget/remember_account.dart';
import 'package:al_andalus/features/auth/ui/widget/slider.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/strings/app_color_manager.dart';
import '../../../../../core/util/my_style.dart';
import '../../../../../core/util/shared_preferences.dart';
import '../../../../../core/widgets/verification_code_widget.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../router/go_router.dart';
import '../../../bloc/confirm_code_cubit/confirm_code_cubit.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  late final ConfirmCodeCubit confirmCodeCubit;
  final TextEditingController _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    confirmCodeCubit = context.read<ConfirmCodeCubit>();
    _pinController.addListener(() {
      confirmCodeCubit.setCode = _pinController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onDigitPress(String digit) {
    if (_pinController.text.length < 6) {
      setState(() {
        _pinController.text += digit;
      });
    }
  }

  void _onDeletePress() {
    if (_pinController.text.isNotEmpty) {
      setState(() {
        _pinController.text =
            _pinController.text.substring(0, _pinController.text.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConfirmCodeCubit, ConfirmCodeInitial>(
          listenWhen: (p, current) => current.done,
          listener: (context, state) {
            context.goNamed(RouteName.donePage);
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBarWidget(titleText: S.of(context).signUp),
        bottomNavigationBar: const RememberAccount(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SliderSignup(step: 4),
                  Container(
                    padding: const EdgeInsets.all(20.0).r,
                    margin: const EdgeInsets.all(20.0).r,
                    child: Column(
                      children: [
                        DrawableText(
                          text: S.of(context).pleaseEnterASecretCode,
                          matchParent: true,
                          textAlign: TextAlign.center,
                        ),
                        40.0.verticalSpace,
                        Form(
                          key: _formKey,
                          child: PinCodeWidget(
                            controller: _pinController,
                            useNativeKeyboard: false,
                            readOnly: true,
                            validator: (p0) => confirmCodeCubit.validateCode,
                          ),
                        ),
                        10.0.verticalSpace,
                        DrawableText(
                          text: 'Enter a 6-digit code',
                          matchParent: true,
                          textAlign: TextAlign.center,
                        ),
                        40.0.verticalSpace,
                        BlocBuilder<ConfirmCodeCubit, ConfirmCodeInitial>(
                          builder: (context, state) {
                            if (state.loading) {
                              return MyStyle.loadingWidget();
                            }
                            return MyButton(
                              enable: state.canSend,
                              text: S.of(context).confirmPin,
                              onTap: () {
                                if (AppSharedPreference.getToken.isEmpty) {
                                  context.goNamed(RouteName.login);
                                  return;
                                }
                                if (!_formKey.currentState!.validate()) return;
                                confirmCodeCubit.confirmPine();
                              },
                            );
                          },
                        ),
                        20.0.verticalSpace,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _NumericKeypad(
              onDigitPress: _onDigitPress,
              onDeletePress: _onDeletePress,
            ),
          ],
        ),
      ),
    );
  }
}

class _NumericKeypad extends StatelessWidget {
  final Function(String) onDigitPress;
  final VoidCallback onDeletePress;

  const _NumericKeypad({
    required this.onDigitPress,
    required this.onDeletePress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
      color: Colors.white,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 12,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
        ),
        itemBuilder: (context, index) {
          if (index == 9) return const SizedBox.shrink();
          if (index == 10) {
            return _KeypadButton(text: '0', onTap: () => onDigitPress('0'));
          }
          if (index == 11) {
            return InkWell(
              onTap: onDeletePress,
              borderRadius: BorderRadius.circular(10.r),
              child: Center(
                child: Icon(
                  Icons.backspace_outlined,
                  size: 28.sp,
                  color: AppColorManager.mainColor,
                ),
              ),
            );
          }
          final digit = '${index + 1}';
          return _KeypadButton(text: digit, onTap: () => onDigitPress(digit));
        },
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _KeypadButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColorManager.lightGray.withValues(alpha: 0.5),
        ),
        child: Center(
          child: DrawableText(
            text: text,
            size: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColorManager.mainColorDark,
          ),
        ),
      ),
    );
  }
}
