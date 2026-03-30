import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../generated/assets.dart';

class NotFoundNotificationsWidget extends StatelessWidget {
  const NotFoundNotificationsWidget({
    super.key,
    this.text,
    this.icon,
    this.child,
  });

  final String? text;
  final Widget? child;
  final dynamic icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          ImageMultiType(
            url: icon ?? Assets.iconsEmpty,
            height: 200.0.dg,
            width: 200.0.dg,
          ),
          10.0.verticalSpace,
          DrawableText(
            size: 16.0.sp,
            text: text ?? '',
            fontWeight: FontWeight.bold,
            matchParent: true,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
