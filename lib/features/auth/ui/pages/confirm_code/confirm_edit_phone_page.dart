import 'package:al_andalus/core/util/snack_bar_message.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/auth/ui/widget/auth_card_image.dart';
import 'package:al_andalus/features/auth/ui/widget/remember_account.dart';
import 'package:al_andalus/features/auth/ui/widget/resend_btn.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../../core/strings/app_color_manager.dart';
import '../../../../../core/util/my_style.dart';
import '../../../../../core/util/shared_preferences.dart';
import '../../../../../core/widgets/verification_code_widget.dart';
import '../../../../../generated/l10n.dart';
import 'package:go_router/go_router.dart';
import '../../../../../router/go_router.dart';
import '../../../bloc/confirm_code_cubit/confirm_code_cubit.dart';
import '../../../bloc/resend_code_cubit/resend_code_cubit.dart';
import '../../widget/custom_stepper_widget.dart';

class ConfirmEditPhonePage extends StatefulWidget {
  const ConfirmEditPhonePage({super.key});

  @override
  State<ConfirmEditPhonePage> createState() => _ConfirmEditPhonePageState();
}

class _ConfirmEditPhonePageState extends State<ConfirmEditPhonePage> {
  late final ConfirmCodeCubit confirmCodeCubit;
  late final ResendCodeCubit resendCodeCubit;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    confirmCodeCubit = context.read<ConfirmCodeCubit>();
    resendCodeCubit = context.read<ResendCodeCubit>();
    confirmCodeCubit.setPhone = AppSharedPreference.getUnconfirmedPhone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConfirmCodeCubit, ConfirmCodeInitial>(
          listenWhen: (p, current) => current.statuses == CubitStatuses.done,
          listener: (context, state) {
            AppSharedPreference.removeUnconfirmedPhone();
            //
          },
        ),
        BlocListener<ResendCodeCubit, ResendCodeInitial>(
          listenWhen: (p, c) => c.done,
          listener: (context, state) {
            if (state.error.isEmpty) {
              NoteMessage.showAwesomeDoneDialog(context, message: '${S.of(context).done_resend_code} ${state.result}');
            } else {
              NoteMessage.showAwesomeError(context: context, message: state.error);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBarWidget(titleText: S.of(context).signUp),
        bottomNavigationBar: RememberAccount(),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0).r,
              margin: const EdgeInsets.all(20.0).r,
              child: Column(
                children: [
                  DrawableText(
                    text:
                        '${S.of(context).weSentTheResetVerificationCodeTo} '
                        '${AppSharedPreference.getUnconfirmedPhone} '
                        '${S.of(context).enterThe6digitCode},',
                    matchParent: true,
                    textAlign: .center,
                  ),
                  40.0.verticalSpace,
                  Form(
                    key: _formKey,
                    child: PinCodeWidget(
                      onChange: (p0) => setState(() => confirmCodeCubit.setCode = p0),
                      validator: (p0) => confirmCodeCubit.validateCode,
                    ),
                  ),

                  40.0.verticalSpace,
                  BlocBuilder<ConfirmCodeCubit, ConfirmCodeInitial>(
                    builder: (context, state) {
                      if (state.loading) {
                        return MyStyle.loadingWidget();
                      }
                      return MyButton(
                        enable: state.canSend,
                        text: S.of(context).sendCode,
                        onTap: () {
                          if (AppSharedPreference.getUnconfirmedPhone.isEmpty) {
                            context.pop();
                            return;
                          }
                          if (!_formKey.currentState!.validate()) return;
                          confirmCodeCubit.confirmCode();
                        },
                      );
                    },
                  ),
                  20.0.verticalSpace,
                  ResendBtn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
