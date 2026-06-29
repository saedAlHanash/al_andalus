import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/my_style.dart';

class TapBarInsurances extends StatelessWidget {
  const TapBarInsurances({
    super.key,
    required this.type,
    required this.onTap,
    this.showNote = true,
  });

  final InsuranceType type;
  final Function(InsuranceType) onTap;
  final bool showNote;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            spacing: 20.0.w,
            children: [
              Expanded(
                child: InkWell(
                  // onTap: () {
                  //   context.pushNamed(
                  //     RouteName.paymentSuccess,
                  //     extra: InsurancePolicyRequest.fromCarPolicy(CarPolicy.fromJson({})),
                  //   );
                  // },
                  onTap: () => onTap(InsuranceType.private),
                  child: Container(
                    height: 40.0.h,
                    alignment: Alignment.center,
                    decoration: type == InsuranceType.private ? MyStyle.outlineBorder : MyStyle.roundBox12(),
                    child: DrawableText(
                      text: InsuranceType.private.name,
                      drawableStart: InsuranceType.private.icon,
                      drawablePadding: 5.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => onTap(InsuranceType.public),
                  child: Container(
                    height: 40.0.h,
                    alignment: Alignment.center,
                    decoration: type == InsuranceType.public ? MyStyle.outlineBorder : MyStyle.roundBox12(),
                    child: DrawableText(
                      text: InsuranceType.public.name,
                      drawableStart: InsuranceType.public.icon,
                      drawablePadding: 5.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showNote) ...[
          5.0.verticalSpace,
          DrawableText(
            text: type.note,
            color: Colors.grey,
            size: 12.0.sp,
            matchParent: true,
            drawableStart: Icon(Icons.info_outline, size: 15.0.sp, color: Colors.grey),
            drawablePadding: 5.0.w,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
          ),
        ],
      ],
    );
  }
}
