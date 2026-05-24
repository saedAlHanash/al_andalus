import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/core/widgets/spinner_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/upload_container_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/uploade_utl.dart';

import 'package:al_andalus/core/widgets/shimmer_widget.dart';
import 'package:al_andalus/generated/l10n.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_multi_type/round_image_widget.dart';

import '../../../../../generated/assets.dart';
import '../../../../core/util/bottom_sheets.dart';
import '../../bloc/update_profile_cubit/update_profile_cubit.dart';

class EditDrivingLicense extends StatefulWidget {
  const EditDrivingLicense({super.key});

  @override
  State<EditDrivingLicense> createState() => _EditDrivingLicenseState();
}

class _EditDrivingLicenseState extends State<EditDrivingLicense> {
  final c = TextEditingController();
  final c1 = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = AppProvider.getMe;
    final cubit = context.read<UpdateProfileCubit>();
    var request = cubit.state.mRequest;

    request.licenseNumber ??= profile.licenseNumber;
    request.licenseStartDate ??= profile.licenseStartDate;
    request.licenseEndDate ??= profile.licenseEndDate;

    if (request.licenseType == null) {
      // Trying to map string to enum if present
      final mappedType =
          LicenseType.values.where((element) => element.nameApi == profile.licenseType).firstOrNull ??
          LicenseType.private;
      request.licenseType = mappedType;
    }

    c.text = request.licenseStartDate?.formatDate ?? '';
    c1.text = request.licenseEndDate?.formatDate ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateProfileCubit, UpdateProfileInitial>(
      listener: (context, state) {
        if (state.done) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).savedSuccessfully)));
        }
      },
      builder: (context, state) {
        final profile = AppProvider.getMe;
        return Scaffold(
          appBar: AppBarWidget(titleText: S.of(context).drivingLicenseInfo),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 24.0.h),
            children: [
              DrawableText(
                text: S.of(context).fourName,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                drawablePadding: 5.0,
                drawableEnd: DrawableText(
                  text: profile.name.isNotEmpty ? profile.name : (state.mRequest.name ?? '-'),
                ),
              ),
              10.0.verticalSpace,
              MyTextFormOutLineWidget(
                onChanged: (p0) => state.mRequest.licenseNumber = p0,
                initialValue: state.mRequest.licenseNumber,
                labelText: S.of(context).idCardNumber,
                hint: S.of(context).idCardNumber,

              ),
              Container(
                padding: EdgeInsets.only(bottom: 20.0.h),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: MyTextFormOutLineWidget(
                      enable: false,
                      icon: Assets.iconsCalendar,
                      onTap: () async {
                        final datePicked = await showDatePicker(
                          context: context,
                          initialDate: state.mRequest.licenseStartDate ?? DateTime.now(),
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
                          initialDate: state.mRequest.licenseEndDate ?? DateTime.now(),
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
                  color: AppColorManager.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.75),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x0A212121),
                      blurRadius: 3.65,
                      offset: Offset(0, 2.44),
                    ),
                    BoxShadow(
                      color: Color(0x14212121),
                      blurRadius: 30.45,
                      offset: Offset(0, 2.44),
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
                      child: state.mRequest.licenseFrontImage.haveValue
                          ? RoundImageWidget(
                              height: 200.0.h,
                              width: 1.0.sw,
                              url: state.mRequest.licenseFrontImage.fileValue,
                              fit: BoxFit.cover,
                            )
                          : profile.licenseFrontImage.isNotEmpty
                          ? RoundImageWidget(
                              height: 200.0.h,
                              width: 1.0.sw,
                              url: profile.licenseFrontImage,
                              fit: BoxFit.cover,
                            )
                          : null,
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
                      child: state.mRequest.licenseBackImage.haveValue
                          ? RoundImageWidget(
                              height: 200.0.h,
                              width: 1.0.sw,
                              url: state.mRequest.licenseBackImage.fileValue,
                              fit: BoxFit.cover,
                            )
                          : profile.licenseBackImage.isNotEmpty
                          ? RoundImageWidget(
                              height: 200.0.h,
                              width: 1.0.sw,
                              url: profile.licenseBackImage,
                              fit: BoxFit.cover,
                            )
                          : null,
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
              MyButton(
                text: S.of(context).save,
                loading: state.loading,
                onTap: () {
                  context.read<UpdateProfileCubit>().updateDrivingLicense();
                },
              ),
              if (state.loading)
                ShimmerWidget(
                  child: DrawableText(
                    textAlign: TextAlign.center,
                    text: 'يتم الآن تحميل الملفات: ${(state.uploadProgress * 100).toInt()}%',
                  ),
                ),
              20.0.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
