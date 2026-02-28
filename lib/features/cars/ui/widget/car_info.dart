import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/widgets/dotted_decoration.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/car_cubit/car_cubit.dart';

class CarInfo extends StatelessWidget {
  const CarInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarCubit, CarInitial>(
      builder: (context, state) {
        final vehicle = state.result.vehicle;
        return Container(
          padding: EdgeInsets.all(15.0).r,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(16.0).r,
            border: Border.all(color: AppColorManager.dividerColor, width: 1.sp),
          ),
          child: Column(
            spacing: 12.h,
            children: [
              DrawableText(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                text: S.of(context).carInfo,
                fontWeight: .bold,
                matchParent: true,
              ),
              Container(height: 2.h, decoration: DottedDecoration()),
              _ItemInfo(
                label: S.of(context).carName,
                value: vehicle.name,
                icon: Assets.iconsTaxi,
              ),
              Divider(color: AppColorManager.cd, height: 1),
              Row(
                children: [
                  Expanded(
                    child: _ItemInfo(
                      label: S.of(context).carColor,
                      value: vehicle.color,
                      icon: Icons.palette_outlined,
                    ),
                  ),

                  15.horizontalSpace,
                  Expanded(
                    child: _ItemInfo(
                      label: S.of(context).carModel,
                      value: vehicle.manufactureYear,
                      icon: Assets.iconsCalendar,
                    ),
                  ),
                ],
              ),
              Divider(color: AppColorManager.cd, height: 1),
              Row(
                children: [
                  Expanded(
                    child: _ItemInfo(
                      label: S.of(context).chassisNumber,
                      value: vehicle.chassisNumber,
                      icon: Assets.iconsTaxi,
                    ),
                  ),

                  15.horizontalSpace,
                  Expanded(
                    child: _ItemInfo(
                      label: S.of(context).plateNumber,
                      value: vehicle.plateNumber,
                      icon: Assets.iconsPlate,
                    ),
                  ),
                ],
              ),
              Divider(color: AppColorManager.cd, height: 1),
              Row(
                children: [
                  Expanded(
                    child: _ItemInfo(
                      label: S.of(context).cylinders,
                      value: vehicle.engineCapacity.toString(),
                      icon: Assets.imagesPistons,
                    ),
                  ),

                  15.horizontalSpace,
                  Expanded(
                    child: _ItemInfo(
                      label: S.of(context).fuelType,
                      value: vehicle.fuelType.name,
                      icon: Assets.imagesFuel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ItemInfo extends StatelessWidget {
  const _ItemInfo({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final dynamic icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawableText(
          text: label,
          color: Colors.grey,
          size: 13.sp,
          drawableStart: icon != null
              ? ImageMultiType(
                  url: icon,
                  height: 18.0.r,
                  width: 18.0.r,
                  color: AppColorManager.mainColor,
                )
              : null,
          drawablePadding: 8.w,
          matchParent: true,
          fontFamily: FontManager.regular.name,
          drawableAlin: .between,
        ),
        8.verticalSpace,
        Padding(
          padding: EdgeInsetsDirectional.only(start: 26.0.r),
          child: DrawableText(
            text: value,
            matchParent: true,
          ),
        ),
      ],
    );
  }
}
