import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/l10n.dart';
import '../../bloc/update_profile_cubit/update_profile_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = AppProvider.getMe;

  UpdateProfileCubit get updateCubit => context.read<UpdateProfileCubit>();

  UpdateProfileInitial get updateState => context.read<UpdateProfileCubit>().state;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileCubit, UpdateProfileInitial>(
      listenWhen: (p, c) => c.done,
      listener: (context, state) => Navigator.pop(context, true),
      child: Scaffold(
        appBar: AppBarWidget(titleText: S.of(context).profile, color: Colors.white),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0).r,
          child: BlocBuilder<UpdateProfileCubit, UpdateProfileInitial>(
            builder: (context, state) {
              return MyButton(
                loading: state.loading,
                text: S.of(context).update,
                onTap: () {
                  if (!_formKey.currentState!.validate()) return;
                  updateCubit.updateProfile();
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
                    30.0.verticalSpace,
                    MyTextFormOutLineWidget(
                      validator: (p0) => p0.validateEmpty,
                      controller: TextEditingController(text: updateState.mRequest.name),
                      label: S.of(context).name,
                      onChanged: (val) => updateCubit.setName = val,
                    ),
                    // MyTextFormOutLineWidget(
                    //   validator: (p0) => p0.validateEmpty,
                    //   controller: TextEditingController(text: updateState.mRequest.email),
                    //   label: S.of(context).email,
                    //   onChanged: (val) => updateCubit.setEmail = val,
                    // ),
                    MyTextFormOutLineWidget(
                      validator: (p0) => p0.validateEmpty,
                      controller: TextEditingController(text: updateState.mRequest.phone),
                      label: S.of(context).phoneNumber,
                      onChanged: (val) => updateCubit.setPhone = val,
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
