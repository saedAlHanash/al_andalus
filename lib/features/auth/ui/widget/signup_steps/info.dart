import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/core/widgets/spinner_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/upload_container_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/uploade_utl.dart';
import 'package:al_andalus/features/auth/ui/widget/uploade_utl.dart';
import 'package:al_andalus/generated/l10n.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_multi_type/image_multi_type_pakage.dart';
import 'package:image_multi_type/image_multi_type_pakage.dart';

import '../../../../../generated/assets.dart';
import '../../../bloc/signup_cubit/signup_cubit.dart';

class SignupInfo extends StatefulWidget {
  const SignupInfo({super.key});

  @override
  State<SignupInfo> createState() => _SignupInfoState();
}

class _SignupInfoState extends State<SignupInfo> {
  final c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupInitial>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0).r,
          children: [
            MyTextFormOutLineWidget(
              onChanged: (p0) => state.mRequest.identityId = p0,
              labelText: S.of(context).idCardNumber,
              hint: S.of(context).idCardNumber,
            ),
            MyTextFormOutLineWidget(
              onChanged: (p0) => state.mRequest.name = p0,
              labelText: S.of(context).fourName,
              hint: S.of(context).fourName,
            ),
            MyTextFormOutLineWidget(
              onChanged: (p0) => state.mRequest.address = p0,
              labelText: S.of(context).placeOfResidence,
              hint: S.of(context).placeOfResidence,
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
                        initialDate: state.mRequest.birthday,
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
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: SpinnerWidget(
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
                    text: ' إرفق صوره البطاقه  الأماميه و الخلفيه:',
                    matchParent: true,
                  ),
                  UploadContainerWidget(
                    title: ' إرفق صورة البطاقة  الأمامية هنا',
                    child: state.mRequest.identityFrontImage.fileBytes == null
                        ? null
                        : RoundImageWidget(
                            height: 200.0.h,
                            width: 1.0.sw,
                            url: state.mRequest.identityFrontImage.fileBytes,
                            fit: .fill,
                          ),
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
                    title: ' إرفق صورة البطاقه  الخلفية هنا',
                    child: state.mRequest.identityBackImage.fileBytes == null
                        ? null
                        : RoundImageWidget(
                            height: 200.0.h,
                            width: 1.0.sw,
                            url: state.mRequest.identityBackImage.fileBytes,
                            fit: .fill,
                          ),
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
            CheckboxListTile(
              value: true,
              onChanged: (value) {},
              controlAffinity: ListTileControlAffinity.leading,
              title: DrawableText(
                size: 12.0.sp,
                text:
                    'أقرّ بصحة جميع المعلومات و الملفات المرفوعة من قبلي و أتحمل المسؤولية القانونية الكاملة عن أي بيانات غير صحيحة.',
              ),
            ),
            20.0.verticalSpace,
          ],
        );
      },
    );
  }
}
