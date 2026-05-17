import 'package:al_andalus/router/go_router.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:go_router/go_router.dart';
import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/util/shared_preferences.dart';
import '../../bloc/update_profile_cubit/update_profile_cubit.dart';

class EditPhonePage extends StatefulWidget {
  const EditPhonePage({super.key});

  @override
  State<EditPhonePage> createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage> {
  final user = AppProvider.getMe;

  UpdateProfileCubit get updateCubit => context.read<UpdateProfileCubit>();

  UpdateProfileInitial get updateState => context.read<UpdateProfileCubit>().state;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileCubit, UpdateProfileInitial>(
      listenWhen: (p, c) => c.done,
      listener: (context, state) async {
        if (context.mounted) {
          context.pushReplacementNamed(
            RouteName.confirmCode,
            queryParameters: {
              'isEditPhone': true.toString(),
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBarWidget(titleText: S.of(context).editPhone),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0).r,
          child: BlocBuilder<UpdateProfileCubit, UpdateProfileInitial>(
            builder: (context, state) {
              return MyButton(
                loading: state.loading,
                text: S.of(context).sendCode,
                onTap: () {
                  if (!_formKey.currentState!.validate()) return;
                  updateCubit.updatePhone();
                },
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0).r,
          child: Form(
            key: _formKey,
            child: BlocBuilder<UpdateProfileCubit, UpdateProfileInitial>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.0.verticalSpace,
                    if (AppSharedPreference.getUnconfirmedPhone.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16.0).r,
                        margin: const EdgeInsets.only(bottom: 20.0).r,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
                          borderRadius: BorderRadius.circular(12.0).r,
                          border: Border.all(color: Theme.of(context).colorScheme.primary),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DrawableText(
                                    text: S.of(context).pendingPhoneConfirmation,
                                    size: 14.0.sp,
                                    matchParent: true,
                                  ),
                                  5.0.verticalSpace,
                                  DrawableText(
                                    text: '${S.of(context).phoneNumber}: ${AppSharedPreference.getUnconfirmedPhone}',
                                    size: 14.0.sp,
                                    matchParent: true,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                            MyButton(
                              width: 100.0.w,
                              text: S.of(context).continueTo,
                              onTap: () {
                                context.pushReplacementNamed(
                                  RouteName.confirmCode,
                                  queryParameters: {
                                    'isEditPhone': true.toString(),
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    MyTextFormOutLineWidget(
                      validator: (p0) => p0.validateEmpty,
                      label: S.of(context).phoneNumber,
                      hint: S.of(context).phoneNumber,
                      initialValue: AppProvider.getMe.phone.fixPhoneForShow,
                      textAlign: .end,
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
                      onChanged: (val) => updateCubit.setPhone = val,
                    ),
                    DrawableText(
                      text: S.of(context).pleaseCheckPhoneNumber,
                      matchParent: true,
                      textAlign: .center,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
