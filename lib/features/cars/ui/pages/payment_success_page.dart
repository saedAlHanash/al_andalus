import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../data/request/insurance_policy_request.dart';

class PaymentSuccessPage extends StatelessWidget {
  final InsurancePolicyRequest request;

  const PaymentSuccessPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = now.formatDate;
    final time = now.formatTime;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        titleText: S.of(context).paymentConfirmed,
        canPop: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
              padding: EdgeInsets.fromLTRB(14.w, 60.h, 14.w, 24.h),

              decoration: BoxDecoration(
                color: AppColorManager.dividerColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  DrawableText(
                    text: S.of(context).paymentSuccessTitle,
                    size: 20.sp,
                    fontFamily: GoogleFonts.almarai().fontFamily,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                  ),
                  8.verticalSpace,
                  DrawableText(
                    text: S.of(context).followOrderHome,
                    size: 14.sp,
                    fontFamily: GoogleFonts.almarai().fontFamily,
                    textAlign: TextAlign.center,
                  ),
                  32.verticalSpace,
                  _buildRow(S.of(context).date, date),
                  20.verticalSpace,
                  _buildRow(S.of(context).time, time),
                  20.verticalSpace,
                  _buildRow(S.of(context).packageType, request.packageName ?? ''),
                  24.verticalSpace,
                  const Divider(thickness: 1.5),
                  24.verticalSpace,
                  _buildRow(S.of(context).total, '${request.totalPrice ?? ''} ${S.of(context).iqd}', isBold: true),
                  24.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColorManager.cardColor,
                      borderRadius: BorderRadius.circular(12.0).r,
                    ),
                    child: ListTile(
                      leading: ImageMultiType(url: request.paymentType?.icon ?? ''),
                      title: DrawableText(
                        text: request.paymentType?.name ?? '',
                        size: 17.sp,
                      ),
                    ),
                  ),
                  80.verticalSpace,
                  OutLineButton(
                    onTap: () {
                      context.goNamed(RouteName.home);
                    },
                    text: S.of(context).backToHome,
                    color: AppColorManager.mainColorDynamic,
                    textColor: AppColorManager.mainColorDynamic,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: .circle,
                  color: AppColorManager.dividerColor,
                ),
                padding: EdgeInsets.all(5.0).r,
                child: Center(
                  child: ImageMultiType(
                    url: Assets.iconsDonePay,
                    width: 100.r,
                    height: 100.r,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 130,
              right: 0.0,
              child: Container(
                height: 40.0.h,
                width: 40.0.w,
                decoration: BoxDecoration(shape: .circle, color: AppColorManager.white),
              ),
            ),
            Positioned(
              bottom: 130,
              left: 0.0,
              child: Container(
                height: 40.0.h,
                width: 40.0.w,
                decoration: BoxDecoration(shape: .circle, color: AppColorManager.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DrawableText(
          text: label,
          size: 17.sp,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
        DrawableText(
          text: value,
          size: 17.sp,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ],
    );
  }
}
