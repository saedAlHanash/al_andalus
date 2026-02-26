import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/bottom_sheets.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../generated/assets.dart';
import '../../data/response/insurance_package.dart';

class ItemInsurance extends StatelessWidget {
  const ItemInsurance({super.key, required this.insurance});

  final InsurancePackage insurance;

  @override
  Widget build(BuildContext context) {
    final tagText = insurance.tag;
    final special = insurance.tag.isNotEmpty;

    return Container(
      decoration: !special
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  insurance.level!.color,
                  insurance.level!.color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(24.0.r),
            ),
      padding: EdgeInsets.only(top: 4.0, right: 4, left: 4, bottom: 4).r,

      child: Column(
        children: [
          DrawableText(
            text: tagText,
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 5.0),
            fontWeight: FontWeight.bold,
            size: 14.sp,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9FB),
                borderRadius: BorderRadius.circular(20.0.r),
                border: Border.all(color: AppColorManager.cd),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0.r),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        DrawableText(
                          text: insurance.title,
                          size: 20.sp,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                        10.verticalSpace,
                        DrawableText(
                          text: insurance.brief,
                          color: Colors.grey.shade600,
                          size: 14.sp,
                          textAlign: TextAlign.center,
                        ),
                        20.verticalSpace,
                        MyButton(
                          onTap: () {
                            showCalculationPrice(context, insurance);
                          },
                          height: 35.0.h,
                          text: 'معرفة المزيد',
                          color: special ? insurance.level!.color : AppColorManager.mainColor.withValues(alpha: 0.2),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: insurance.features.map((feature) {
                          return ListTile(
                            leading: ImageMultiType(
                              url: Assets.iconsDoneStep,
                              height: 20.0.r,
                              width: 20.0.r,
                            ),
                            title: DrawableText(text: feature.title),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
