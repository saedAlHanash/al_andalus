import 'dart:convert';

import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/util/bottom_sheets.dart';
import 'package:al_andalus/core/util/my_style.dart';
import 'package:al_andalus/core/util/snack_bar_message.dart';
import 'package:al_andalus/core/util/snack_bar_message.dart';
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

import 'package:al_andalus/core/injection/injection_container.dart';
import 'package:al_andalus/features/cars/bloc/cars_cubit/cars_cubit.dart';
import 'package:m_cubit/m_cubit.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/generated/assets.dart';
import 'package:al_andalus/generated/l10n.dart';
import 'package:al_andalus/features/cars/bloc/car_cubit/car_cubit.dart';
import 'package:al_andalus/features/cars/data/response/cars_response.dart';
import 'package:al_andalus/features/cars/data/request/insurance_policy_request.dart';

class CarPage extends StatelessWidget {
  const CarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CarsCubit, CarsInitial>(
          listenWhen: (p, c) => c.done,
          listener: (context, state) {
            if (state.url.isNotEmpty) {
              context.read<CarsCubit>().doneOpenUrl();
              context.pushNamed(RouteName.webView, queryParameters: {'url': state.url}).then(
                (value) {
                  if (context.mounted) {
                    context.read<CarCubit>().getData(newData: true);
                    context.pushNamed(RouteName.paymentSuccess, extra: state.mRequest);
                  }
                },
              );
            } else {
              context.read<CarCubit>().getData(newData: true);
            }
          },
        ),
      ],
      child: BlocBuilder<CarCubit, CarInitial>(
        builder: (context, state) {
          final CarPolicy car = state.result;
          return Scaffold(
            appBar: AppBarWidget(
              titleText: car.vehicle.name,
              actions: [
                IconButton(
                  onPressed: () {
                    if (state.result.status == .cancelled) return;
                    showQr(
                      context,
                      jsonEncode({
                        'qrcode': car.qrcode,
                        'id': car.id.toString(),
                      }),
                    );
                  },
                  icon: ImageMultiType(url: Assets.iconsQr),
                ),
              ],
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              children: [
                _MissingInfoWidget(car: car),
                car.hasTransferRequest.getWidget,
                car.hasClaimRequest.getWidget,
                PackageInfoWidget(),
                20.verticalSpace,
                CarInfo(),
                20.verticalSpace,
                if (car.status == .draft) _PolicyFileWidget(car: car),

                20.verticalSpace,
                if (state.result.status != .cancelled)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.15.sw),
                    child: OutLineButton(
                      textColor: Colors.red,
                      onTap: () {
                        NoteMessage.showConfirm(
                          context,
                          text: S.of(context).confirmTheNextStep,
                          onConfirm: () {
                            context.read<CarsCubit>().cancelInsurance(id: car.id.toString());
                          },
                        );
                      },
                      height: 35.0,
                      text: S.of(context).cancelTheDocument,
                      color: Colors.red,
                    ),
                  ),
                20.0.verticalSpace,
                if (car.status == .missingInfo)
                  MyButton(
                    onTap: () {
                      context
                          .pushNamed(
                            RouteName.addCarPage,
                            queryParameters: {'id': state.result.id.toString()},
                            extra: car,
                          )
                          .then(
                            (value) {
                              if (value == true) {
                                context.read<CarCubit>().getData(newData: true);
                              }
                            },
                          );
                    },
                    icon: ImageMultiType(
                      url: Assets.iconsEdit,
                      color: AppColorManager.white,
                    ),
                    text: S.of(context).edit,
                  ),
                80.0.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MissingInfoWidget extends StatelessWidget {
  const _MissingInfoWidget({required this.car});

  final CarPolicy car;

  @override
  Widget build(BuildContext context) {
    if (car.fieldsToBeRefilled.isEmpty) return const SizedBox();

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.amber.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.report_problem_rounded,
                  color: Colors.amber.shade900,
                  size: 20.r,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: DrawableText(
                  text: S.of(context).missingInfo,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                  size: 16.sp,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          DrawableText(
            text: S.of(context).pleaseUpdateMissingFields,
            size: 14.sp,
            color: Colors.black87,
          ),
          12.verticalSpace,
          ...car.fieldsToBeRefilled.map((field) {
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h, right: 8.w, left: 8.w),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 14.r,
                    color: Colors.amber.shade900,
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: DrawableText(
                      text: _getLocalizedFieldName(context, field),
                      size: 14.sp,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _getLocalizedFieldName(BuildContext context, String field) {
    final s = S.of(context);
    switch (field.trim().toLowerCase()) {
      case 'plate_number':
        return s.plateNumber;
      case 'chassis_number':
        return s.chassisNumber;
      case 'engine_capacity':
        return s.engineCapacity;
      case 'fuel_type':
        return s.fuelType;
      case 'vehicle_name':
      case 'name':
        return s.carName;
      case 'color':
        return s.carColor;
      case 'model':
        return s.carModel;
      case 'manufacture_year':
        return s.manufactureYear;
      case 'ownership_front_image':
        return s.pleaseUploadOwnershipFrontImage;
      case 'ownership_back_image':
        return s.pleaseUploadOwnershipBackImage;
      default:
        // Try to replace underscore with space and capitalize
        return field
            .replaceAll('_', ' ')
            .split(' ')
            .map((e) => e.isNotEmpty ? '${e[0].toUpperCase()}${e.substring(1)}' : '')
            .join(' ');
    }
  }
}

class _PolicyFileWidget extends StatelessWidget {
  const _PolicyFileWidget({required this.car});

  final CarPolicy car;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarsCubit, CarsInitial>(
      listenWhen: (p, c) => c.done && c.update,
      listener: (context, state) {
        context.read<CarCubit>().getData(newData: true);
      },
      child: BlocBuilder<CarsCubit, CarsInitial>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColorManager.mainColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColorManager.mainColor.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawableText(
                  text: S.of(context).insurancePolicyReview,
                  fontWeight: FontWeight.bold,
                  color: AppColorManager.mainColor,
                  size: 16.sp,
                ),
                15.verticalSpace,
                Container(
                  decoration: MyStyle.roundBox,
                  child: ListTile(
                    onTap: () {
                      context.pushNamed(
                        RouteName.pdf,
                        queryParameters: {'url': car.policyFile},
                      );
                    },
                    leading: ImageMultiType(
                      url: Assets.iconsPdfBorder,
                      height: 50.0.r,
                      width: 50.0.r,
                    ),
                    title: DrawableText(
                      text: '${S.of(context).insurancePolicy}: ${car.vehicle.name}',
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      fontWeight: .bold,
                    ),
                    trailing: ImageMultiType(url: Icons.visibility_rounded),
                  ),
                ),
                20.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        text: S.of(context).confirm,
                        onTap: () {
                          NoteMessage.showConfirm(
                            context,
                            text: S.of(context).confirmTheNextStep,
                            onConfirm: () {
                              context.read<CarsCubit>().approve(id: car.id.toString());
                            },
                          );
                        },
                        loading: state.loading,
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: MyButton(
                        text: S.of(context).reject,
                        color: Colors.white,
                        textColor: Colors.red,
                        onTap: () {
                          NoteMessage.showConfirm(
                            context,
                            text: S.of(context).confirmTheNextStep,
                            onConfirm: () {
                              context.read<CarsCubit>().reject(id: car.id.toString());
                            },
                          );
                        },
                        loading: state.loading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
