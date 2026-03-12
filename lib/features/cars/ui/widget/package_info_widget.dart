import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/bottom_sheets.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/cars/bloc/cars_cubit/cars_cubit.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/widgets/dotted_decoration.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/car_cubit/car_cubit.dart';

class PackageInfoWidget extends StatelessWidget {
  const PackageInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarCubit, CarInitial>(
      builder: (context, state) {
        final insurance = state.result;
        final insurancePackage = insurance.insurancePackage;
        return Container(
          padding: EdgeInsets.all(6.0).r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0).r,
            gradient: LinearGradient(
              colors: insurancePackage.level.gradient,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(15.0).r,
            decoration: BoxDecoration(
              color: AppColorManager.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColorManager.dividerColor, width: 1.sp),
            ),
            child: Column(
              spacing: 10.0.h,
              children: [
                DrawableText(
                  text: insurancePackage.title,
                  fontWeight: .bold,
                  drawableAlin: .between,
                  matchParent: true,
                  drawableEnd: DrawableText(
                    text: '${S.of(context).joined}:${insurance.startDate}',
                    size: 12.0.sp,
                    color: Colors.grey,
                  ),
                ),

                Container(height: 2.h, decoration: DottedDecoration()),
                ListTile(
                  contentPadding: .zero,
                  minTileHeight: 0,
                  title: DrawableText(
                    text: '${S.of(context).validityUntil}: ${insurance.endDate}',
                  ),
                  leading: ImageMultiType(url: Assets.iconsCalendar, height: 24.0.r),
                ),
                ListTile(
                  contentPadding: .zero,
                  minTileHeight: 0,
                  title: DrawableText(
                    text: '${S.of(context).annualCost}: ${insurance.annualSubscriptionPrice.formatPrice}',
                  ),
                  leading: ImageMultiType(url: Assets.iconsCoins, height: 24.0.r),
                ),
                if (state.result.status.canRenew)
                  MyButton(
                    onTap: () {
                      showRePay(
                        context,
                        state.result.annualSubscriptionPrice,
                        (value) {
                          context.read<CarsCubit>().resubscribe(
                            id: state.result.id.toString(),
                            insurancePackageId: state.result.insurancePackage.id.toString(),
                            paymentType: value,
                          );
                        },
                      );
                    },
                    text: S.of(context).renewalSubscription,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
