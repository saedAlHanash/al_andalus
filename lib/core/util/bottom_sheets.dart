import 'package:al_andalus/core/helper/launcher_helper.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_checkbox_widget.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/features/insurances/data/response/insurance_package.dart';
import 'package:collection/collection.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/app/app_widget.dart';
import '../../../../core/util/shared_preferences.dart';
import '../../../../generated/assets.dart';
import '../../features/policies/bloc/support_info_cubit/support_info_cubit.dart';
import '../../router/go_router.dart';

void showLanguageDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            _Title(title: 'اختر اللغة'),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20.0).r,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      MyApp.setLocale(context, 'ar');
                    },
                    title: DrawableText(text: 'العربية'),
                    leading: ImageMultiType(
                      url: AppSharedPreference.getLocal == 'ar' ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: AppColorManager.mainColor,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      MyApp.setLocale(context, 'kr');
                    },
                    title: DrawableText(text: 'كوردى'),
                    leading: ImageMultiType(
                      url: AppSharedPreference.getLocal == 'kr' ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: AppColorManager.mainColor,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      MyApp.setLocale(context, 'en');
                    },
                    title: DrawableText(text: 'English'),
                    leading: ImageMultiType(
                      url: AppSharedPreference.getLocal == 'en' ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: AppColorManager.mainColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showSupportCall(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: BlocBuilder<SupportInfoCubit, SupportInfoInitial>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _Title(title: 'الدعم الفني'),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: AppColorManager.mainColor),
                        ),
                        onTap: () {
                          LauncherHelper.sendEmail(email: state.result.email);
                        },
                        title: DrawableText(text: state.result.email),
                        trailing: ImageMultiType(
                          url: Assets.iconsEmail,
                        ),
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: AppColorManager.mainColor),
                        ),
                        onTap: () {
                          LauncherHelper.sendWhatsApp(phone: state.result.whatsApp);
                        },
                        title: DrawableText(text: state.result.whatsApp),
                        trailing: ImageMultiType(
                          url: Assets.iconsWhatsapp,
                        ),
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: AppColorManager.mainColor),
                        ),
                        onTap: () {
                          LauncherHelper.callPhone(phone: state.result.phone);
                        },
                        title: DrawableText(text: state.result.phone),
                        trailing: ImageMultiType(
                          url: Assets.iconsPhone,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

void showCalculationPrice(BuildContext context, InsurancePackage insurancePackage) {
  final items = insurancePackage.getCylinders;
  var c = items.firstWhereOrNull((e) => e.isSelected)?.id ?? 0;
  var p = 0.0;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0).r,
                child: Column(
                  children: [
                    _Title(title: 'إحسب تكلفة التأمين لسيارتك'),
                    10.0.verticalSpace,
                    DrawableText(
                      text: 'إختر حجم المحرك',
                      matchParent: true,
                    ),
                    MyCheckboxWidget(
                      items: insurancePackage.getCylinders,
                      onSelected: (value, i, isSelected) {
                        c = value.id;
                      },
                      isRadio: true,
                      buttonBuilder: (selected, value, context) {
                        return Container(
                          width: 0.25.sw,
                          margin: EdgeInsets.symmetric(horizontal: 5.0).w,
                          child: ListTile(
                            tileColor: AppColorManager.cd,
                            title: DrawableText(text: value.name),
                            leading: ImageMultiType(
                              url: selected ? Assets.iconsRadio : Icons.radio_button_off,
                              height: 24.0.r,
                              width: 24.0.r,
                            ),
                          ),
                        );
                      },
                    ),
                    10.0.verticalSpace,
                    MyTextFormOutLineWidget(
                      onChanged: (p0) {
                        p = double.parse(p0);
                      },
                      keyBordType: TextInputType.number,
                      labelText: 'أدخل قيمة السيارة',
                      hint: '0.0',
                    ),
                    10.0.verticalSpace,
                    MyButton(
                      onTap: () {
                        context.pushNamed(
                          RouteName.insurancePage,
                          queryParameters: {
                            'id': insurancePackage.id.toString(),
                            'price': p.toString(),
                            'cylinders': c.toString(),
                          },
                        );
                      },
                      text: 'ابدأ الآن',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showAddNote(
  BuildContext context, {
  required String title,
  String? initial,
  required Function(String note) onDone,
}) {
  final controller = TextEditingController(text: initial);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.0).r,
                child: Column(
                  children: [
                    _Title(title: title),
                    DrawableText(
                      text: 'إدخل التفاصيل المطلوبه',
                      size: 12.0.sp,
                      matchParent: true,
                    ),
                    10.0.verticalSpace,
                    MyTextFormOutLineWidget(
                      controller: controller,
                      hint: 'إدخل التفاصيل المطلوبه',
                      maxLines: 7,
                    ),
                    10.0.verticalSpace,
                    MyButton(
                      text: 'إدخال',
                      onTap: () {
                        onDone.call(controller.text);
                        context.pop();
                      },
                    ),
                    10.0.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, 2),
      child: ImageMultiType(
        url: Assets.iconsBottomSheetHeader,
        width: 1.0.sw,
        color: Colors.white,
        height: 30.0.h,
        fit: BoxFit.fill,
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      text: title,
      size: 20.0.sp,
      matchParent: true,
      drawableAlin: .between,
      textAlign: .center,
      padding: EdgeInsets.symmetric(horizontal: 20.0).r,
      drawableStart: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: ImageMultiType(url: Icons.close),
      ),
      drawableEnd: IconButton(
        onPressed: null,
        icon: ImageMultiType(
          url: Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}
