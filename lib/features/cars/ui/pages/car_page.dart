import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/cars/ui/widget/car_info.dart';
import 'package:al_andalus/features/cars/ui/widget/package_info_widget.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/car_cubit/car_cubit.dart';
import '../../data/response/cars_response.dart';

class CarPage extends StatelessWidget {
  const CarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarCubit, CarInitial>(
      builder: (context, state) {
        final CarPolicy car = state.result;
        return Scaffold(
          appBar: AppBarWidget(titleText: car.vehicle.name),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            children: [
              PackageInfoWidget(),
              20.verticalSpace,
              CarInfo(),
              20.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0).r,
                  border: Border.all(color: AppColorManager.dividerColor, width: 1.sp),
                ),
                child: ListTile(
                  onTap: () {},
                  title: DrawableText(
                    text: S.of(context).issuingAnInsuranceApplicationDocument,
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    fontWeight: .bold,
                  ),
                  subtitle: DrawableText(
                    text: S.of(context).youWillBeAbleToChooseTheDesiredLanguageFor,
                    color: Colors.grey,
                  ),
                  trailing: ImageMultiType(url: Assets.iconsFile1, height: 30.0.r),
                ),
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.15.sw),
                child: OutLineButton(
                  text: S.of(context).cancelTheDocument,
                  textColor: Colors.red,
                ),
              ),
              100.0.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
