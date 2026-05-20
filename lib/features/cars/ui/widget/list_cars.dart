import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/my_style.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/app/app_provider.dart';
import '../../../../core/widgets/need_login_widget.dart';
import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/cars_cubit/cars_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home_cars_cubit/home_cars_cubit.dart';
import 'item_car.dart';

class ListCars extends StatelessWidget {
  const ListCars({super.key, this.take});

  final int? take;

  @override
  Widget build(BuildContext context) {
    if (AppProvider.isNotLogin) {
      return NeedLoginWidget();
    }
    return BlocBuilder<HomeCarsCubit, HomeCarsInitial>(
      builder: (context, state) {
        if (state.loading) {
          return MyStyle.loadingWidget();
        }
        if (state.isDataEmpty) {
          return Center(
            child: Container(
              width: 1.0.sw,
              decoration: take != null
                  ? BoxDecoration(
                      border: Border.all(color: AppColorManager.cd),
                      borderRadius: BorderRadius.circular(24.0.r),
                    )
                  : null,
              padding: EdgeInsets.all(30.0).r,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                mainAxisSize: .min,
                children: [
                  ImageMultiType(url: Assets.iconsCircleArow, color: AppColorManager.textColor),
                  30.0.verticalSpace,
                  DrawableText(text: S.of(context).pleaseAddYourVehicleToShowTheInsuranceDocument),
                ],
              ),
            ),
          );
        }
        final list = take != null ? [?state.result.firstOrNull] : state.result;
        return ListView.builder(
          physics: take == null ? null : NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ItemCar(car: list[index]);
          },
        );
      },
    );
  }
}
