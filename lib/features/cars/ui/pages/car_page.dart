import 'package:al_andalus/core/util/bottom_sheets.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/cars/ui/widget/car_info.dart';
import 'package:al_andalus/features/cars/ui/widget/package_info_widget.dart';
import 'package:al_andalus/router/go_router.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
          appBar: AppBarWidget(
            titleText: car.vehicle.name,
            actions: [
              IconButton(
                onPressed: () {
                  showQr(context, car.qrcode);
                },
                icon: ImageMultiType(url: Assets.iconsQr),
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            children: [
              PackageInfoWidget(),
              20.verticalSpace,
              CarInfo(),
              20.verticalSpace,
              if (state.result.policyFile.isEmpty) ...[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0).r,
                    border: Border.all(color: AppColorManager.dividerColor, width: 1.sp),
                  ),
                  child: ListTile(
                    onTap: () {
                      context.pushNamed(
                        RouteName.pdf,
                        queryParameters: {'url': state.result.policyFile},
                      );
                    },
                    leading: ImageMultiType(url: Assets.iconsPdfBorder),
                    title: DrawableText(
                      text: '${S.of(context).insurancePolicy}: ${state.result.vehicle.name}',
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      fontWeight: .bold,
                    ),
                    trailing: ImageMultiType(url: Icons.visibility_rounded),
                  ),
                ),

                // make widget with 2 buttons and onTap call approve/reject from CarsCubit
              ],
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
