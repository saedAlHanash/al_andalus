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

import 'item_car.dart';

class ListCars extends StatelessWidget {
  const ListCars({super.key, this.take});

  final int? take;

  @override
  Widget build(BuildContext context) {
    if (AppProvider.isNotLogin) {
      return NeedLoginWidget();
    }
    return BlocBuilder<CarsCubit, CarsInitial>(
      builder: (context, state) {
        if (state.isDataEmpty) {
          return Container(
            decoration: MyStyle.roundBox12(Colors.white),
            padding: EdgeInsets.all(30.0).r,
            child: Column(
              children: [
                ImageMultiType(url: Assets.iconsCircleArow),
                30.0.verticalSpace,
                DrawableText(text: S.of(context).pleaseAddYourVehicleToShowTheInsuranceDocument),
              ],
            ),
          );
        }
        final list = take != null ? state.result.reversed.take(take!).toList() : state.result;
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
