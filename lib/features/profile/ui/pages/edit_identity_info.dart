import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/core/widgets/spinner_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/auth/ui/widget/upload_container_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/uploade_utl.dart';
import 'package:al_andalus/features/profile/bloc/update_profile_cubit/update_profile_cubit.dart';
import 'package:al_andalus/generated/l10n.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_multi_type/image_multi_type_pakage.dart';
import 'package:image_multi_type/round_image_widget.dart';

import '../../../../../generated/assets.dart';
import '../../../../core/util/bottom_sheets.dart';
import '../../../../core/widgets/app_bar/app_bar_widget.dart';

class EditIdentityInfo extends StatefulWidget {
  const EditIdentityInfo({super.key});

  @override
  State<EditIdentityInfo> createState() => _EditIdentityInfoState();
}

class _EditIdentityInfoState extends State<EditIdentityInfo> {
  final c = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = AppProvider.getMe;
    final cubit = context.read<UpdateProfileCubit>();
    var request = cubit.state.mRequest;

    request.name ??= profile.name;
    request.address ??= profile.address;
    request.identityId ??= profile.identityId;
    request.birthday ??= profile.birthDate;

    if (request.gender == null) {
      if (profile.gender.toLowerCase() == 'male') {
        request.gender = GenderEnum.male;
      } else if (profile.gender.toLowerCase() == 'female') {
        request.gender = GenderEnum.female;
      }
    }

    c.text = request.birthday?.formatDate ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateProfileCubit, UpdateProfileInitial>(
      listener: (context, state) {
        if (state.done) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(S.of(context).savedSuccessfully)));
        }
      },
      builder: (context, state) {
        final profile = AppProvider.getMe;
        return Scaffold(
          appBar: AppBarWidget(titleText: S.of(context).unifiedCardInfo),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 24.0.h),
            children: [
              MyTextFormOutLineWidget(
                onChanged: (p0) => state.mRequest.identityId = p0,
                initialValue: state.mRequest.identityId,
                labelText: S.of(context).idCardNumber,
                hint: S.of(context).idCardNumber,
                keyBordType: TextInputType.number,
              ),
              MyTextFormOutLineWidget(
                onChanged: (p0) => state.mRequest.name = p0,
                initialValue: state.mRequest.name,
                labelText: S.of(context).fourName,
                hint: S.of(context).fourName,
              ),
              MyTextFormOutLineWidget(
                onChanged: (p0) => state.mRequest.address = p0,
                initialValue: state.mRequest.address,
                labelText: S.of(context).placeOfResidence,
                hint: S.of(context).placeOfResidence,
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
                          initialDate: state.mRequest.birthday ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2052),
                          initialDatePickerMode: DatePickerMode.year,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                        );
                        if (datePicked == null) return;
                        state.mRequest.birthday = datePicked;
                        c.text = (state.mRequest.birthday?.formatDate) ?? '';
                      },
                      controller: c,
                      labelText: S.of(context).birthday,
                      hint: S.of(context).birthday,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 20.0.h),
                      child: SpinnerWidget(
                        onChanged: (spinnerItem) {
                          state.mRequest.gender = spinnerItem.item;
                        },
                        icon: Assets.iconsUserSearch,
                        hintLabel: S.of(context).gender,
                        hintText: S.of(context).gender,
                        height: 46.0.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0.r),
                          border: Border.all(color: AppColorManager.cd, width: 1.0.r),
                        ),
                        items: GenderEnum.values.getSpinnerItems(selectedId: state.mRequest.gender?.index),
                      ),
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
                      text: S.of(context).attachIdFrontAndBack,
                      matchParent: true,
                    ),
                    UploadContainerWidget(
                      title: S.of(context).attachIdFrontHere,
                      child: state.mRequest.identityFrontImage.haveValue
                          ? RoundImageWidget(
                              height: 200.0.h,
                              width: 1.0.sw,
                              url: state.mRequest.identityFrontImage.fileValue,
                              fit: BoxFit.cover,
                            )
                          : profile.identityFrontImage.isNotEmpty
                          ? RoundImageWidget(
                              height: 200.0.h,
                              width: 1.0.sw,
                              url: profile.identityFrontImage,
                              fit: BoxFit.cover,
                            )
                          : null,
                      onTap: () {
                        showOptionBottomSheet(
                          context,
                          (value) {
                            setState(() {
                              final nameField = state.mRequest.identityFrontImage.nameField;
                              state.mRequest
                                ..identityFrontImage = value
                                ..identityFrontImage.nameField = nameField;
                            });
                          },
                        );
                      },
                    ),
                    UploadContainerWidget(
                      title: S.of(context).attachIdBackHere,
                      child: state.mRequest.identityBackImage.haveValue
                          ? RoundImageWidget(
                              height: 200.0.h,
                              width: 1.0.sw,
                              url: state.mRequest.identityBackImage.fileValue,
                              fit: BoxFit.cover,
                            )
                          : profile.identityBackImage.isNotEmpty
                          ? RoundImageWidget(
                              height: 200.0.h,
                              width: 1.0.sw,
                              url: profile.identityBackImage,
                              fit: BoxFit.cover,
                            )
                          : null,
                      onTap: () {
                        showOptionBottomSheet(
                          context,
                          (value) {
                            setState(() {
                              final nameField = state.mRequest.identityBackImage.nameField;
                              state.mRequest
                                ..identityBackImage = value
                                ..identityBackImage.nameField = nameField;
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
                text: S.of(context).save, // Standard localization field
                loading: state.loading,
                onTap: () {
                  context.read<UpdateProfileCubit>().updateIdentity();
                },
              ),
              20.0.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
