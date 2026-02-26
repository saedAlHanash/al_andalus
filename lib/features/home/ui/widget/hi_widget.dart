import 'package:al_andalus/core/app/app_provider.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../generated/assets.dart';
import '../../../auth/ui/widget/auth_card_image.dart';
import '../../../policies/ui/widget/support_call.dart';

class HiWidget extends StatelessWidget {
  const HiWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0).w,
      child: ListTile(
        contentPadding: .zero,
        leading: ImageMultiType(url: Assets.imagesLogo),
        title: AppProvider.isGuest
            ? DrawableText(
                text: 'مرحبا بك',
                fontWeight: .bold,
              )
            : DrawableText(text: AppProvider.getMe.name),
        subtitle: AppProvider.isGuest
            ? DrawableText(
                text: 'ابدأ رحلتك التأمينية بكل سهولة',
                color: Colors.grey,
              )
            : null,
        trailing: InkWell(
          onTap: () => showSupportCall(context),
          child: ImageMultiType(
            url: Assets.iconsSupportBorder,
            height: 40.0.r,
            width: 40.0.r,
          ),
        ),
      ),
    );
  }
}
