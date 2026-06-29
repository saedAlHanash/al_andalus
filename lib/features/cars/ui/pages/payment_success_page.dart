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

import '../../../../core/injection/injection_container.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../bloc/home_cars_cubit/home_cars_cubit.dart';
import '../../data/request/insurance_policy_request.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({
    super.key,
    required this.request,
    required this.isRepay,
    this.isSuccessPayment = true,
  });
  final InsurancePolicyRequest request;
  final bool isSuccessPayment;
  final bool isRepay;


  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = now.formatDate;
    final time = now.formatTime;

    return Scaffold(
      appBar: AppBarWidget(
        zeroHeight: true,
        canPop: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
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
                    text: !isSuccessPayment
                        ? S.of(context).paymentFailedTitle
                        : (isRepay ? S.of(context).repaymentSuccessTitle : S.of(context).paymentSuccessTitle),
                    size: 20.sp,
                    fontFamily: GoogleFonts.almarai().fontFamily,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                  ),
                  if (isSuccessPayment) ...[
                    8.verticalSpace,
                    DrawableText(
                      text: isRepay ? S.of(context).followRepaymentHome : S.of(context).followOrderHome,
                      size: 14.sp,
                      fontFamily: GoogleFonts.almarai().fontFamily,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (!isSuccessPayment)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: DrawableText(
                        text:
                            '${S.of(context).sorryThePaymentProcessWasNotCompleted}\n${S.of(context).dontWorryYouCanCompleteThePurchaseAtAnyTime}',
                        size: 14.sp,
                        fontFamily: GoogleFonts.almarai().fontFamily,
                        textAlign: TextAlign.center,
                        color: AppColorManager.ampere,
                      ),
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
                  Spacer(),
                  OutLineButton(
                    onTap: () {
                      context.goNamed(RouteName.home);
                      sl<HomeCarsCubit>().getData(newData: true);
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
                height: 100.0.r,
                width: 100.0.r,
                decoration: BoxDecoration(
                  shape: .circle,
                  color: isSuccessPayment ? AppColorManager.dividerColor : AppColorManager.ampere,
                ),
                padding: EdgeInsets.all(5.0).r,
                child: Center(
                  child: ImageMultiType(
                    url: isSuccessPayment ? Assets.icons.donePay.path : Icons.warning,
                    width: isSuccessPayment ? 100.r : 30.0.r,
                    height: isSuccessPayment ? 100.r : 30.0.r,
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
                decoration: BoxDecoration(shape: .circle, color: AppColorManager.scaffoldColor),
              ),
            ),
            Positioned(
              bottom: 130,
              left: 0.0,
              child: Container(
                height: 40.0.h,
                width: 40.0.w,
                decoration: BoxDecoration(shape: .circle, color: AppColorManager.scaffoldColor),
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
