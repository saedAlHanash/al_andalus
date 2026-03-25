import 'dart:convert';
import 'dart:ui';

import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/helper/launcher_helper.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_checkbox_widget.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/core/widgets/spinner_widget.dart';
import 'package:al_andalus/features/cars/data/response/cars_response.dart';
import 'package:al_andalus/features/insurances/data/response/insurance_package.dart';
import 'package:collection/collection.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/app/app_widget.dart';
import '../../../../core/util/shared_preferences.dart';
import '../../../../generated/assets.dart';
import '../../features/auth/ui/widget/uploade_utl.dart';
import '../../features/policies/bloc/support_info_cubit/support_info_cubit.dart';
import '../../generated/l10n.dart';
import '../api_manager/api_service.dart';
import '../strings/enum_manager.dart';
import 'my_style.dart';

void showLanguageDialog(BuildContext context) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColorManager.cardColor,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            _Title(title: S.of(context).chooseLanguage),
            Container(
              color: AppColorManager.cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 20.0).r,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      MyApp.setLocale(context, 'ar');
                      Navigator.pop(context);
                    },
                    title: DrawableText(text: 'العربية'),
                    leading: ImageMultiType(
                      url: AppSharedPreference.getLocal == 'ar' ? Icons.radio_button_checked : Icons.radio_button_off,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      MyApp.setLocale(context, 'ur');
                      Navigator.pop(context);
                    },
                    title: DrawableText(text: 'كوردی'),
                    leading: ImageMultiType(
                      url: AppSharedPreference.getLocal == 'ur' ? Icons.radio_button_checked : Icons.radio_button_off,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      MyApp.setLocale(context, 'en');
                      Navigator.pop(context);
                    },
                    title: DrawableText(text: 'English'),
                    leading: ImageMultiType(
                      url: AppSharedPreference.getLocal == 'en' ? Icons.radio_button_checked : Icons.radio_button_off,
                    ),
                  ),
                  30.0.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showThemeDialog(BuildContext context) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColorManager.cardColor,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            _Title(title: S.of(context).theme),
            Container(
              color: AppColorManager.cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 20.0).r,
              child: Column(
                children: [
                  _ThemeItem(
                    title: S.of(context).light,
                    themeMode: ThemeMode.light,
                  ),
                  _ThemeItem(
                    title: S.of(context).dark,
                    themeMode: ThemeMode.dark,
                  ),
                  _ThemeItem(
                    title: S.of(context).system,
                    themeMode: ThemeMode.system,
                  ),
                  30.0.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _ThemeItem extends StatelessWidget {
  const _ThemeItem({required this.title, required this.themeMode});

  final String title;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        MyApp.setTheme(context, themeMode);
        Navigator.pop(context);
      },
      title: DrawableText(text: title),
      leading: ImageMultiType(
        url: AppSharedPreference.getThemeMode == themeMode ? Icons.radio_button_checked : Icons.radio_button_off,
      ),
    );
  }
}

void showSupportCall(BuildContext context, {bool isDismissible = true}) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      var iconSize = 25.0.dg;
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: BlocBuilder<SupportInfoCubit, SupportInfoInitial>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(),
                Container(
                  color: AppColorManager.cardColor,
                  child: Column(
                    children: [
                      _Title(title: S.of(context).technicalSupport),
                      Container(
                        decoration: MyStyle.outlineBorder,
                        margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0).r,
                        child: ListTile(
                          onTap: () {
                            LauncherHelper.sendEmail(email: state.result.email);
                          },
                          title: DrawableText(text: state.result.email),
                          trailing: ImageMultiType(
                            url: Assets.iconsEmail,
                            height: iconSize,
                            width: iconSize,
                          ),
                        ),
                      ),
                      Container(
                        decoration: MyStyle.outlineBorder,
                        margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0).r,
                        child: ListTile(
                          onTap: () {
                            LauncherHelper.sendWhatsApp(phone: state.result.whatsApp);
                          },
                          title: DrawableText(text: state.result.whatsApp),
                          trailing: ImageMultiType(
                            url: Assets.iconsWhatsapp,
                            height: iconSize,
                            width: iconSize,
                          ),
                        ),
                      ),
                      Container(
                        decoration: MyStyle.outlineBorder,
                        margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0).r,
                        child: ListTile(
                          onTap: () {
                            LauncherHelper.callPhone(phone: state.result.phone);
                          },
                          title: DrawableText(text: state.result.phone),
                          trailing: ImageMultiType(
                            url: Assets.iconsPhone,
                            height: iconSize,
                            width: iconSize,
                          ),
                        ),
                      ),
                      30.0.verticalSpace,
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

void showCalculationPrice(
  BuildContext context,
  InsurancePackage? insurancePackage,
  Function(Map<String, dynamic> queryParameters) onTap,
) {
  var cylindersCount = insurancePackage?.getCylinders.firstWhereOrNull((e) => e.isSelected)?.id ?? 4;
  var p = 0.0;
  showModalBottomSheet(
    useSafeArea: true,
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
                color: AppColorManager.cardColor,
                padding: EdgeInsets.all(20.0).r,
                child: Column(
                  children: [
                    _Title(title: S.of(context).calculateInsuranceCost),
                    10.0.verticalSpace,
                    DrawableText(
                      text: S.of(context).chooseEngineCapacity,
                      matchParent: true,
                    ),
                    MyCheckboxWidget(
                      items:
                          insurancePackage?.getCylinders ??
                          [
                            SpinnerItem(name: '4', id: 4),
                            SpinnerItem(name: '6', id: 6),
                            SpinnerItem(name: '8', id: 8),
                          ],
                      onSelected: (value, i, isSelected) {
                        cylindersCount = value.id;
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
                      labelText: S.of(context).enterCarValue,
                      hint: '0.0',
                    ),
                    10.0.verticalSpace,
                    MyButton(
                      onTap: () {
                        onTap.call(
                          {
                            'id': insurancePackage?.id.toString(),
                            'price': p.toString(),
                            'cylindersCount': cylindersCount.toString(),
                            'json': jsonEncode(insurancePackage?.toJson()),
                          },
                        );
                      },
                      text: S.of(context).startNow,
                    ),
                    30.0.verticalSpace,
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
    useSafeArea: true,
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
                color: AppColorManager.cardColor,
                padding: EdgeInsets.symmetric(horizontal: 24.0).r,
                child: Column(
                  children: [
                    _Title(title: title),
                    DrawableText(
                      text: S.of(context).enterRequiredDetails,
                      size: 12.0.sp,
                      matchParent: true,
                    ),
                    10.0.verticalSpace,
                    MyTextFormOutLineWidget(
                      controller: controller,
                      hint: S.of(context).enterRequiredDetails,
                      maxLines: 7,
                    ),
                    10.0.verticalSpace,
                    MyButton(
                      text: S.of(context).submit,
                      onTap: () {
                        onDone.call(controller.text);
                        context.pop();
                      },
                    ),
                    30.0.verticalSpace,
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

void showOptionBottomSheet(BuildContext context, Function(UploadFile value) onConfirm) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    constraints: BoxConstraints(maxHeight: 0.7.sh),
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(),
          Container(
            color: AppColorManager.cardColor,
            padding: const EdgeInsets.all(20.0).r,
            child: Column(
              children: [
                ImageMultiType(
                  url: Assets.imagesIdScan,
                  height: 170.0.h,
                ),
                DrawableText(
                  text: S.of(context).ensureTextIsClear,
                  matchParent: true,
                  textAlign: .center,
                  fontWeight: FontWeight.bold,
                ),

                10.0.verticalSpace,
                Row(
                  spacing: 20.0.w,
                  children: [
                    Expanded(
                      child: MyButton(
                        text: S.of(context).uploadFromFiles,
                        icon: ImageMultiType(url: Icons.file_upload_outlined),
                        onTap: () {
                          Navigator.pop(ctx);
                          pickAndUpload().then(
                            (value) async {
                              if (value == null || !context.mounted) return;
                              final result = await showConfirmDialog(context, value);
                              if (result == false) return;
                              onConfirm.call(value);
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: MyButton(
                        text: S.of(context).takePicture,
                        icon: ImageMultiType(url: Icons.camera_alt_outlined),
                        onTap: () {
                          Navigator.pop(ctx);
                          takePhoto().then(
                            (value) async {
                              if (value == null || !context.mounted) return;
                              final result = await showConfirmDialog(context, value);
                              if (result == false) return;
                              onConfirm.call(value);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                10.0.verticalSpace,
              ],
            ),
          ),
        ],
      );
    },
  );
}

void showFileUploadBottomSheet(BuildContext context, Function(UploadFile value) onConfirm) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(maxHeight: 0.7.sh),
    builder: (ctx) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(),
          Container(
            color: AppColorManager.cardColor,
            padding: const EdgeInsets.all(20.0).r,
            child: Column(
              children: [
                ImageMultiType(
                  url: Assets.iconsPdf,
                  height: 100.0.h,
                ),
                DrawableText(
                  text: S.of(context).pleaseUploadFile,
                  fontWeight: FontWeight.bold,
                ),

                10.0.verticalSpace,
                MyButton(
                  text: S.of(context).uploadFromFiles,
                  icon: ImageMultiType(url: Icons.file_upload_outlined),
                  onTap: () {
                    Navigator.pop(ctx);
                    pickAndUpload(allowedExtensions: ['pdf', 'doc', 'PDF', 'DOC']).then(
                      (value) async {
                        if (value == null || !context.mounted) return;
                        onConfirm.call(value);
                      },
                    );
                  },
                ),
                30.0.verticalSpace,
              ],
            ),
          ),
        ],
      );
    },
  );
}

void showRePay(BuildContext context, num value, Function(PaymentType value) onConfirm) {
  PaymentType? type;
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(),
          StatefulBuilder(
            builder: (context, setState) {
              return Container(
                color: AppColorManager.cardColor,
                padding: const EdgeInsets.all(20.0).r,
                child: Column(
                  children: [
                    DrawableText(text: S.of(context).selectPaymentMethod),
                    20.0.verticalSpace,
                    Container(
                      decoration: MyStyle.roundBox12(
                        color: type == .qiCard ? AppColorManager.mainColorLight : null,
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            type = .qiCard;
                          });
                        },
                        title: DrawableText(text: S.of(context).electronicCard),
                        subtitle: DrawableText(text: S.of(context).paymentViaElectronicCard),
                        trailing: ImageMultiType(
                          url: Assets.imagesVisa,
                          width: 71.0.w,
                        ),
                      ),
                    ),
                    25.0.verticalSpace,
                    Container(
                      decoration: MyStyle.roundBox12(
                        color: type == .zainCash ? AppColorManager.mainColorLight : null,
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            type = .zainCash;
                          });
                        },
                        title: DrawableText(text: S.of(context).zainCashWallet),
                        subtitle: DrawableText(text: S.of(context).paymentViaWallet),
                        trailing: ImageMultiType(
                          url: Assets.imagesZainCash,
                          width: 71.0.w,
                        ),
                      ),
                    ),
                    30.0.verticalSpace,
                    DrawableText(
                      text: S.of(context).totalAmount,
                      padding: EdgeInsets.symmetric(vertical: 10.0).r,
                      matchParent: true,
                      drawableAlin: .between,
                      drawableEnd: DrawableText(text: value.formatPrice),
                    ),
                    MyButton(
                      enable: type != null,
                      text: S.of(context).pay,
                      icon: ImageMultiType(url: Icons.payment, color: AppColorManager.white),
                      onTap: () {
                        onConfirm.call(type!);
                        Navigator.pop(context);
                      },
                    ),
                    30.0.verticalSpace,
                  ],
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

void selectCar(
  BuildContext context,
  List<CarPolicy> cars,
  Function(CarPolicy value) onConfirm,
  Function() onAddCar,
) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(),
          StatefulBuilder(
            builder: (context, setState) {
              return Container(
                color: AppColorManager.cardColor,
                padding: const EdgeInsets.all(20.0).r,
                child: Column(
                  children: [
                    _Title(
                      title: S.of(context).selectDesiredCar,
                    ),
                    30.0.verticalSpace,
                    DrawableText(
                      text: S.of(context).pleaseSelectCarToViewDetails,
                      matchParent: true,
                    ),
                    10.0.verticalSpace,
                    if (cars.isEmpty)
                      MyButton(
                        text: S.of(context).addYourFirstCar,
                        onTap: onAddCar,
                      ),
                    ...cars.map(
                      (e) => Container(
                        decoration: MyStyle.roundBox12(),
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            onConfirm.call(e);
                          },
                          title: DrawableText(text: e.vehicle.name),
                          leading: ImageMultiType(url: Assets.iconsTaxi),
                        ),
                      ),
                    ),
                    30.0.verticalSpace,
                  ],
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

void showQr(BuildContext context, String qr) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(),
          Container(
            color: AppColorManager.cardColor,
            padding: const EdgeInsets.all(24.0).r,
            child: Column(
              children: [
                _Title(title: S.of(context).qrCode),
                20.0.verticalSpace,
                Container(
                  padding: EdgeInsets.all(12.0).r,
                  decoration: BoxDecoration(
                    color: AppColorManager.cardColor,
                    borderRadius: BorderRadius.circular(16.0).r,
                    border: Border.all(color: AppColorManager.mainColorLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: qr,
                    version: QrVersions.auto,
                    size: 250.0.r,
                  ),
                ),
                30.0.verticalSpace,
                DrawableText(
                  text: S.of(context).pleaseScanQrToPay,
                  textAlign: .center,
                  matchParent: true,
                  size: 16.0.sp,
                ),
                30.0.verticalSpace,
                MyButton(
                  text: S.of(context).done,
                  onTap: () => Navigator.pop(context),
                ),
                30.0.verticalSpace,
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<dynamic> showConfirmDialog(BuildContext context, UploadFile file) async {
  return await showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0).r),
        title: Center(
          child: DrawableText(
            text: S.of(context).previewFile,
            size: 18.0,
            textAlign: TextAlign.center,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (file.haveValue)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0).r,
                child: ImageMultiType(
                  url: file.fileValue,
                  height: 200.h,
                  fit: BoxFit.cover,
                ),
              )
            else
              Column(
                children: [
                  Icon(Icons.insert_drive_file, size: 60.r, color: AppColorManager.mainColor),
                  10.verticalSpace,
                  DrawableText(
                    text: (file.localId ?? '').split('/').last,
                    size: 14.0,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(ctx, false),
                    child: DrawableText(text: S.of(context).cancel, color: Colors.white),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColorManager.mainColor),
                    onPressed: () {
                      Navigator.pop(ctx, true);
                    },
                    child: DrawableText(text: S.of(context).confirm, color: Colors.white),
                  ),
                ),
              ],
            ),
            30.0.verticalSpace,
          ],
        ),
      );
    },
  );
}

Future<bool?> showImageReviewDialog(BuildContext context, UploadFile file, Function(bool reTake) onReTake) async {
  return await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.0).r,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: InkWell(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    padding: EdgeInsets.all(5.0).r,
                    decoration: BoxDecoration(color: AppColorManager.cardColor, shape: BoxShape.circle),
                    child: Icon(Icons.close, color: Colors.black, size: 24.r),
                  ),
                ),
              ),
              15.verticalSpace,
              if (file.haveValue)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0).r,
                  child: ImageMultiType(url: file.fileValue, width: 1.sw, fit: BoxFit.contain),
                ),
              25.verticalSpace,
              MyButton(
                text: S.of(context).retakeImage,
                onTap: () {
                  Navigator.pop(ctx, true);
                  onReTake.call(true);
                },
                color: AppColorManager.cardColor,
                textColor: Colors.black,
                radios: 15.0.r,
              ),
              30.0.verticalSpace,
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
        color: AppColorManager.cardColor,
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
          color: AppColorManager.cardColor,
        ),
      ),
    );
  }
}
