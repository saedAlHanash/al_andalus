import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/bottom_sheets.dart';
import 'package:al_andalus/core/util/my_style.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../bloc/home_cars_cubit/home_cars_cubit.dart';
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
        color: AppColorManager.cardColor,
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
          10.0.verticalSpace,
          _RowItems(
            dataRow: {
              S.of(context).expiryDate: car.endDate,
              S.of(context).manufactureYear: car.vehicle.manufactureYear,
              S.of(context).carModel: car.vehicle.brand,
              S.of(context).packageCost: car.annualSubscriptionPrice.formatPrice,
            },
          ),
          Divider(),
          // DrawableText(
          //   text: 'Creation at:',
          //   drawableEnd: DrawableText(text: car.created),
          //   matchParent: true,
          //   drawableAlin: .between,
          // ),
          10.0.verticalSpace,

          if (car.status == .paymentPending)
            BlocBuilder<HomeCarsCubit, HomeCarsInitial>(
              builder: (context, state) {
                return MyButton(
                  loading: state.loading && !state.delete,
                  onTap: () {
                    showRePay(
                      context,
                      car.annualSubscriptionPrice,
                      (value) {
                        context.read<HomeCarsCubit>().rePay(car: car, type: value);
                      },
                    );
                  },
                  text: S.of(context).pay,
                );
              },
            ),

          5.0.verticalSpace,
          Row(
            children: [
              Expanded(
                child: OutLineButton(
                  onTap: () {
                    //عملية الخروج من الصفحة بعد إتمام الحذف موجودة في ال cubit نفسها ك  ctx?.pop(true)
                    return context
                        .pushNamed(
                          RouteName.carPage,
                          queryParameters: {'id': car.id.toString()},
                        )
                        .then(
                          (value) {
                            if (!context.mounted || value != true) return;
                            context.read<HomeCarsCubit>().getData(newData: true);
                          },
                        );
                  },
                  text: S.of(context).viewInsuranceStatement,
                ),
              ),
              if (car.status.canCancel) ...[
                10.0.horizontalSpace,
                BlocBuilder<HomeCarsCubit, HomeCarsInitial>(
                  buildWhen: (p, c) => c.id.toString() == car.id.toString(),
                  builder: (context, state) {
                    return InkWell(
                      onTap: () {
                        showConfirmBottomSheet(
                          context,
                          title: S.of(context).confirmTheNextStep,
                          message: S.of(context).areYouSureYouWantToCancelInsurance,
                          isDanger: true,
                          onConfirm: () {
                            context.read<HomeCarsCubit>().delete(id: car.id.toString());
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(9.0).r,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0).r,
                          border: Border.all(color: Colors.red.withOpacity(0.2)),
                        ),
                        child: state.loading && state.delete && state.id.toString() == car.id.toString()
                            ? MyStyle.loadingWidget(size: 24.0.dg)
                            : Icon(Icons.delete_outline, color: Colors.red, size: 24.r),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
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
