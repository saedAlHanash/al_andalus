import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/remember_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/util/bottom_sheets.dart';
import '../../../../core/util/my_style.dart';
import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../bloc/reset_password_cubit/reset_password_cubit.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final ResetPasswordCubit resetPassCubit;
  late final ResetPasswordInitial resetPassState;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    resetPassCubit = context.read<ResetPasswordCubit>();
    resetPassState = context.read<ResetPasswordCubit>().state;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordInitial>(
      listenWhen: (p, c) => c.done,
      listener: (context, state) {
        context.goNamed(RouteName.login);
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Spacer(),
              RememberPassword(),
              Spacer(),
            ],
          ),
        ),
        appBar: AppBarWidget(
          title: ImageMultiType(
            url: Assets.images.logo.path,
            height: 110.0.r,
            width: 110.0.r,
            // fit: .fill,
          ),
          actions: [
            InkWell(
              onTap: () => showLanguageDialog(context),
              child: ImageMultiType(
                url: Assets.icons.language.path,
                height: 40.0.r,
                width: 40.0.r,
              ),
            ),
            20.0.horizontalSpace,
          ],
        ),
        body: ListView(
          padding: MyStyle.pagePadding,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0).r,
              margin: const EdgeInsets.symmetric(vertical: 20.0).r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0).r,

              ),
              child:   Column(
                children: [
                  30.0.verticalSpace,
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        MyTextFormOutLineWidget(
                          label: S.of(context).confirmCode,
                          initialValue: resetPassCubit.state.request.code,
                          onChanged: (val) => resetPassCubit.setCode = val,
                          keyBordType: .number,
                        ),
                        MyTextFormOutLineWidget(
                          obscureText: true,
                          validator: (p0) => resetPassCubit.validatePassword,
                          label: S.of(context).pinCode,
                          initialValue: resetPassCubit.state.request.password,
                          onChanged: (val) => resetPassCubit.setPassword = val,
                          keyBordType: .number,
                        ),
                        MyTextFormOutLineWidget(
                          obscureText: true,
                          validator: (p0) => resetPassCubit.validateConfirmPassword,
                          label: S.of(context).confirmPin,
                          initialValue: resetPassCubit.state.request.passwordConfirmation,
                          onChanged: (val) => resetPassCubit.setConfirmPassword = val,
                          keyBordType: .number,
                        ),
                      ],
                    ),
                  ),
                  30.0.verticalSpace,
                  BlocBuilder<ResetPasswordCubit, ResetPasswordInitial>(
                    builder: (_, state) {
                      if (state.loading) {
                        return MyStyle.loadingWidget();
                      }
                      return MyButton(
                        text: S.of(context).changePassword,
                        onTap: () {
                          if (!_formKey.currentState!.validate()) return;
                          resetPassCubit.resetPassword();
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
    );
  }
}
