import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/core/widgets/spinner_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/upload_container_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/uploade_utl.dart';

import 'package:al_andalus/generated/l10n.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_multi_type/image_multi_type_pakage.dart';

import '../../../../../core/util/bottom_sheets.dart';
import '../../../../../generated/assets.dart';
import '../../../bloc/signup_cubit/signup_cubit.dart';

class DrivingLicense extends StatefulWidget {
  const DrivingLicense({super.key});

  @override
  State<DrivingLicense> createState() => _DrivingLicenseState();
}

class _DrivingLicenseState extends State<DrivingLicense> {
  final c = TextEditingController();
  final c1 = TextEditingController();

  @override
  void initState() {
    c.text = context.read<SignupCubit>().state.mRequest.licenseStartDate?.formatDate ?? '';
    c1.text = context.read<SignupCubit>().state.mRequest.licenseEndDate?.formatDate ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupInitial>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0).r,
          children: [
            DrawableText(
              text: S.of(context).fourName,
              fontWeight: .bold,
              color: Colors.grey,
              drawablePadding: 5.0,
              drawableEnd: DrawableText(
                text: state.mRequest.name ?? '-',
              ),
            ),
            10.0.verticalSpace,
            MyTextFormOutLineWidget(
              onChanged: (p0) => state.mRequest.licenseNumber = p0,
              initialValue: state.mRequest.licenseNumber,
              labelText: S.of(context).idCardNumber,
              hint: S.of(context).idCardNumber,
              keyBordType: .number,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: SpinnerWidget(
                onChanged: (spinnerItem) {
                  state.mRequest.licenseType = spinnerItem.item;
                },
                icon: Assets.iconsUserSearch,
                hintLabel: S.of(context).licenseType,
                hintText: S.of(context).licenseType,
                height: 46.0.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0.r),
                  border: Border.all(color: AppColorManager.cd, width: 1.0.r),
                ),
                items: LicenseType.values.getSpinnerItems(selectedId: state.mRequest.licenseType?.index),
              ),
            ),
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
                        initialDate: state.mRequest.licenseStartDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2052),
                        initialDatePickerMode: DatePickerMode.year,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                      );
                      if (datePicked == null) return;
                      state.mRequest.licenseStartDate = datePicked;
                      c.text = (state.mRequest.licenseStartDate?.formatDate) ?? '';
                    },
                    controller: c,
                    labelText: S.of(context).issueDate,
                    hint: S.of(context).issueDate,
                  ),
                ),
                Expanded(
                  child: MyTextFormOutLineWidget(
                    enable: false,
                    icon: Assets.iconsCalendar,
                    onTap: () async {
                      final datePicked = await showDatePicker(
                        context: context,
                        initialDate: state.mRequest.licenseEndDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2052),
                        initialDatePickerMode: DatePickerMode.year,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                      );
                      if (datePicked == null) return;
                      state.mRequest.licenseEndDate = datePicked;
                      c1.text = (state.mRequest.licenseEndDate?.formatDate) ?? '';
                    },
                    controller: c1,
                    labelText: S.of(context).expiryDate,
                    hint: S.of(context).expiryDate,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(14.62),
              decoration: ShapeDecoration(
                color: Colors.white,
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
                    text: S.of(context).attachLicenseFrontAndBack,
                    matchParent: true,
                  ),
                  UploadContainerWidget(
                    title: S.of(context).attachLicenseFrontHere,
                    child: state.mRequest.licenseFrontImage.notHaveValue
                        ? null
                        : RoundImageWidget(
                            height: 200.0.h,
                            width: 1.0.sw,
                            url: state.mRequest.licenseFrontImage.fileValue,
                            fit: .fill,
                          ),
                    onTap: () {
                      showOptionBottomSheet(
                        context,
                        (value) {
                          setState(() {
                            final nameField = state.mRequest.licenseFrontImage.nameField;
                            state.mRequest
                              ..licenseFrontImage = value
                              ..licenseFrontImage.nameField = nameField;
                          });
                        },
                      );
                    },
                  ),
                  UploadContainerWidget(
                    title: S.of(context).attachLicenseBackHere,
                    child: state.mRequest.licenseBackImage.notHaveValue
                        ? null
                        : RoundImageWidget(
                            height: 200.0.h,
                            width: 1.0.sw,
                            url: state.mRequest.licenseBackImage.fileValue,
                            fit: .fill,
                          ),
                    onTap: () {
                      showOptionBottomSheet(
                        context,
                        (value) {
                          setState(() {
                            final nameField = state.mRequest.licenseBackImage.nameField;
                            state.mRequest
                              ..licenseBackImage = value
                              ..licenseBackImage.nameField = nameField;
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
                  value: state.mRequest.licenseChecked,
                  onChanged: (value) {
                    setStateChecked(() => state.mRequest.licenseChecked = value ?? false);
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
