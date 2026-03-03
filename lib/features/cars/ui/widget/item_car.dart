import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/bottom_sheets.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/cars/bloc/cars_cubit/cars_cubit.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../data/response/cars_response.dart';

class ItemCar extends StatelessWidget {
  const ItemCar({super.key, required this.car});

  final CarPolicy car;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColorManager.cd),
      ),
      child: Column(
        children: [
          DrawableText(
            text: S.of(context).insuranceStatus,
            drawableEnd: car.status.statusWidget,
            matchParent: true,
            drawableAlin: .between,
          ),
          16.0.verticalSpace,
          _RowItems(
            dataRow: {
              S.of(context).expiryDate: car.endDate,
              S.of(context).manufactureYear: car.vehicle.manufactureYear,
              S.of(context).carModel: car.vehicle.brand,
              S.of(context).packageCost: car.annualSubscriptionPrice.formatPrice,
            },
          ),
          16.0.verticalSpace,

          if (car.status == .paymentPending)
            BlocBuilder<CarsCubit, CarsInitial>(
              builder: (context, state) {
                return MyButton(
                  loading: state.loading,
                  onTap: () {
                    showRePay(
                      context,
                      car.annualSubscriptionPrice,
                      (value) {
                        context.read<CarsCubit>().rePay(id: car.id.toString(), type: value);
                      },
                    );
                  },
                  text: S.of(context).pay,
                );
              },
            ),

          5.0.verticalSpace,
          OutLineButton(
            onTap: () => context.pushNamed(
              RouteName.carPage,
              queryParameters: {'id': car.id.toString()},
            ),
            text: S.of(context).viewInsuranceStatement,
          ),
          16.0.verticalSpace,
        ],
      ),
    );
  }
}

class _RowItems extends StatelessWidget {
  const _RowItems({super.key, required this.dataRow});

  final Map<String, String> dataRow;

  @override
  Widget build(BuildContext context) {
    final entries = dataRow.entries.toList();
    return IntrinsicHeight(
      child: Row(
        children: List.generate(entries.length * 2 - 1, (index) {
          if (index.isOdd) {
            return VerticalDivider(
              color: Colors.grey.shade300,
              thickness: 1,
              width: 8.w,
            );
          }
          final entry = entries[index ~/ 2];
          return Expanded(
            child: Column(
              children: [
                DrawableText(
                  text: entry.key,
                  color: Colors.grey,
                  size: 12.0.sp,
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                DrawableText(
                  text: entry.value,
                  fontWeight: FontWeight.bold,
                  size: 12.sp,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
