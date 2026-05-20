import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/core/widgets/spinner_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/upload_container_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/uploade_utl.dart';
import 'package:al_andalus/features/auth/ui/widget/uploade_utl.dart';
import 'package:al_andalus/generated/l10n.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../../core/util/shared_preferences.dart';
import '../../../../../generated/assets.dart';
import '../../../bloc/signup_cubit/signup_cubit.dart';

class PhoneNumber extends StatelessWidget {
  const PhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupInitial>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0).r,
          children: [
            20.0.verticalSpace,
            MyTextFormOutLineWidget(
              onChanged: (p0) => state.mRequest.phone = p0,
              initialValue: state.mRequest.phone,
              labelText: S.of(context).phoneNumber,
              hint: S.of(context).phoneNumber,
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
            ),
            DrawableText(
              text: S.of(context).pleaseCheckPhoneNumber,
              matchParent: true,
              textAlign: .center,
            ),
          ],
        );
      },
    );
  }
}
