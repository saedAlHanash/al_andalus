import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/upload_container_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/uploade_utl.dart';
import 'package:al_andalus/generated/l10n.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type_pakage.dart';

import '../../../../../core/strings/app_color_manager.dart';
import '../../../../../core/strings/enum_manager.dart';
import '../../../../../core/util/bottom_sheets.dart';
import '../../../../../core/widgets/spinner_widget.dart';
import '../../../../../generated/assets.dart';
import '../../../bloc/cars_cubit/cars_cubit.dart';

class AnnualInfo extends StatefulWidget {
  const AnnualInfo({super.key});

  @override
  State<AnnualInfo> createState() => _AnnualInfoState();
}

class _AnnualInfoState extends State<AnnualInfo> {
  final expiryStartDate = TextEditingController();
  final expiryEndDate = TextEditingController();
  final manufactureYear = TextEditingController();

  @override
  void initState() {
    expiryStartDate.text = context.read<CarsCubit>().state.mRequest.expiryStartDate?.formatDate ?? '';
    expiryEndDate.text = context.read<CarsCubit>().state.mRequest.expiryEndDate?.formatDate ?? '';
    manufactureYear.text = context.read<CarsCubit>().state.mRequest.manufactureYear?.year.toString() ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsCubit, CarsInitial>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0).r,
          children: [
            MyTextFormOutLineWidget(
              onChanged: (p0) => state.mRequest.name = p0,
              initialValue: state.mRequest.name,
              labelText: S.of(context).carName,
              hint: S.of(context).carName,
            ),
            MyTextFormOutLineWidget(
              enable: false,
              icon: Assets.iconsCalendar,
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: DrawableText(text: S.of(context).manufactureYear),
                      content: SizedBox(
                        width: 300.w,
                        height: 300.h,
                        child: YearPicker(
                          firstDate: DateTime(1900),
                          lastDate: APIService().serverTime,
                          selectedDate: state.mRequest.manufactureYear ?? APIService().serverTime,
                          onChanged: (DateTime dateTime) {
                            state.mRequest.manufactureYear = dateTime;
                            manufactureYear.text = dateTime.year.toString();
                            Navigator.pop(context);
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              controller: manufactureYear,
              labelText: S.of(context).manufactureYear,
              hint: S.of(context).manufactureYear,
            ),

            Row(
              spacing: 15.0.w,
              mainAxisAlignment: .start,
              children: [
                Expanded(
                  child: MyTextFormOutLineWidget(
                    onChanged: (p0) => state.mRequest.color = p0,
                    initialValue: state.mRequest.color,
                    labelText: S.of(context).carColor,
                    hint: S.of(context).carColor,
                  ),
                ),
                Expanded(
                  child: MyTextFormOutLineWidget(
                    onChanged: (p0) => state.mRequest.brand = p0,
                    initialValue: state.mRequest.brand,
                    labelText: S.of(context).carModel,
                    hint: S.of(context).carModel,
                  ),
                ),
              ],
            ),
            Row(
              spacing: 15.0.w,
              mainAxisAlignment: .start,
              children: [
                Expanded(
                  child: MyTextFormOutLineWidget(
                    onChanged: (p0) => state.mRequest.chassisNumber = p0,
                    initialValue: state.mRequest.chassisNumber,
                    labelText: S.of(context).chassisNumber,
                    hint: S.of(context).chassisNumber,

                  ),
                ),
                Expanded(
                  child: MyTextFormOutLineWidget(
                    onChanged: (p0) => state.mRequest.plateNumber = p0,
                    initialValue: state.mRequest.plateNumber,
                    labelText: S.of(context).plateNumber,
                    hint: S.of(context).plateNumber,
                    keyBordType: .number,
                  ),
                ),
              ],
            ),

            Row(
              spacing: 15.0.w,
              mainAxisAlignment: .start,
              children: [
                Expanded(
                  child: MyTextFormOutLineWidget(
                    onChanged: (p0) => state.mRequest.engineCapacity = p0,
                    initialValue: state.mRequest.engineCapacity,
                    labelText: S.of(context).engineCapacity,
                    hint: S.of(context).engineCapacity,
                    keyBordType: .number,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: SpinnerWidget(
                      onChanged: (spinnerItem) {
                        state.mRequest.fuelType = spinnerItem.item;
                      },
                      hintLabel: S.of(context).fuelType,
                      hintText: S.of(context).fuelType,
                      height: 46.0.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0.r),
                        border: Border.all(color: AppColorManager.cd, width: 1.0.r),
                      ),
                      items: FuelType.values.getSpinnerItems(selectedId: state.mRequest.fuelType?.index),
                    ),
                  ),
                ),
              ],
            ),

            10.0.verticalSpace,
            Row(
              spacing: 15.0.w,
              mainAxisAlignment: .start,
              children: [
                Expanded(
                  child: MyTextFormOutLineWidget(
                    enable: false,
                    icon: Assets.iconsCalendar,
                    onTap: () async {
                      final datePicked = await showDatePicker(
                        context: context,
                        initialDate: state.mRequest.expiryStartDate,
                        firstDate: DateTime(1900),
                        lastDate: APIService().serverTime,
                        initialDatePickerMode: DatePickerMode.year,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                      );
                      if (datePicked == null) return;
                      state.mRequest.expiryStartDate = datePicked;
                      expiryStartDate.text = (state.mRequest.expiryStartDate?.formatDate) ?? '';
                    },
                    controller: expiryStartDate,
                    labelText: S.of(context).releaseDate,
                    hint: S.of(context).enterExpiryDate,
                  ),
                ),
                Expanded(
                  child: MyTextFormOutLineWidget(
                    enable: false,
                    icon: Assets.iconsCalendar,
                    onTap: () async {
                      final datePicked = await showDatePicker(
                        context: context,
                        initialDate: state.mRequest.expiryEndDate,
                        firstDate: state.mRequest.expiryStartDate ?? DateTime(2000),
                        lastDate: APIService().serverTime.addFromNow(year: 30),
                        initialDatePickerMode: DatePickerMode.year,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                      );
                      if (datePicked == null) return;
                      state.mRequest.expiryEndDate = datePicked;
                      expiryEndDate.text = (state.mRequest.expiryEndDate?.formatDate) ?? '';
                    },
                    controller: expiryEndDate,
                    labelText: S.of(context).expiryDate,
                    hint: S.of(context).enterExpiryDate,
                  ),
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.all(14.62),
              decoration: ShapeDecoration(
                color: AppColorManager.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.75),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0A212121),
                    blurRadius: 3.65,
                    offset: Offset(0, 2.44),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Color(0x14212121),
                    blurRadius: 30.45,
                    offset: Offset(0, 2.44),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                spacing: 10.0.h,
                children: [
                  DrawableText(
                    text: S.of(context).attachIdFrontAndBack,
                    matchParent: true,
                  ),
                  UploadContainerWidget(
                    title: S.of(context).attachIdFrontHere,
                    child: state.mRequest.ownershipFrontImage.notHaveValue
                        ? null
                        : RoundImageWidget(
                            height: 200.0.h,
                            width: 1.0.sw,
                            url: state.mRequest.ownershipFrontImage.fileValue,
                            fit: .cover,
                          ),
                    onTap: () {
                      showOptionBottomSheet(
                        context,
                        (value) {
                          setState(() {
                            state.mRequest.ownershipFrontImage = value;
                          });
                          state.mRequest.setTempImages(value);
                        },
                      );
                    },
                  ),
                  UploadContainerWidget(
                    title: S.of(context).attachIdBackHere,
                    child: state.mRequest.ownershipBackImage.notHaveValue
                        ? null
                        : RoundImageWidget(
                            height: 200.0.h,
                            width: 1.0.sw,
                            url: state.mRequest.ownershipBackImage.fileValue,
                            fit: .cover,
                          ),
                    onTap: () {
                      showOptionBottomSheet(
                        context,
                        (value) {
                          setState(() {
                            state.mRequest.ownershipBackImage = value;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            20.0.verticalSpace,
            StatefulBuilder(
              builder: (context, setStateChecked) {
                return CheckboxListTile(
                  value: state.mRequest.annualInfoCheck,
                  onChanged: (value) {
                    setStateChecked(() => state.mRequest.annualInfoCheck = value ?? false);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: DrawableText(
                    size: 12.0.sp,
                    text: S.of(context).declarationText,
                  ),
                );
              },
            ),
            20.0.verticalSpace,
          ],
        );
      },
    );
  }
}
