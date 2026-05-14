import 'dart:ui';
import 'package:go_router/go_router.dart';

import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../api_manager/api_service.dart';
import '../app/app_widget.dart';
import '../strings/app_color_manager.dart';
import '../widgets/my_button.dart';
import '../widgets/snake_bar_widget.dart';

class NoteMessage {
  static void showTopMessage({
    required BuildContext? context,
    String? message,
  }) {
    if (context == null) return;
    _showTopSnack(
      context: context,
      widget: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0).r,
        decoration: BoxDecoration(
          color: Color(0xff005B19),
          borderRadius: BorderRadius.circular(12.0).r,
        ),
        child: ListTile(
          leading: ImageMultiType(url: Assets.iconsAddToCart),
          title: DrawableText(
            text: message ?? S.of(context).addedToCartSuccessfully,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static void showTopMessageError({
    required BuildContext? context,
    String? message,
  }) {
    if (context == null) return;
    _showTopSnack(
      context: context,
      widget: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0).r,
        decoration: BoxDecoration(
          color: AppColorManager.ampere,
          borderRadius: BorderRadius.circular(12.0).r,
        ),
        child: ListTile(
          leading: ImageMultiType(url: Icons.warning_amber),
          title: DrawableText(
            text: message ?? S.of(context).quantityNotAvailable,
          ),
        ),
      ),
    );
  }

  static void _showTopSnack({
    required BuildContext context,
    required Widget widget,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(ctx!).padding.top + 10,
          left: 10,
          right: 10,
          child: Material(
            color: Colors.transparent,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: const Offset(0, 0),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Opacity(opacity: value, child: child);
                },
                child: widget,
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 3)).then((_) {
      entry.remove();
    });
  }

  static void showSuccessSnackBar({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  static void showErrorSnackBar({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  static void showSnakeBar({
    required String? message,
    required BuildContext context,
  }) {
    final snack = SnackBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: SnakeBarWidget(text: message ?? ''),
    );

    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  static Future<void> showBottomSheet({required Widget child}) async {
    showModalBottomSheet(
      context: ctx!,
      constraints: BoxConstraints(maxHeight: 0.7.sh),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      isScrollControlled: true,
      builder: (cx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(cx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: child,
          ),
        );
      },
    );
  }

  static Future<bool> showConfirm(
    BuildContext context, {
    required String text,
    VoidCallback? onConfirm,
  }) async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Confirm",
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (context, animation, _, __) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.0).animate(curved),
          child: FadeTransition(
            opacity: curved,
            child: Center(
              child: Dialog(
                elevation: 0,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 28.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Icon
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColorManager.mainColor.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.help_outline_rounded,
                          size: 32.sp,
                          color: AppColorManager.mainColor,
                        ),
                      ),

                      20.verticalSpace,

                      /// Text
                      DrawableText(
                        text: text,
                        size: 18.spMin,
                        color: AppColorManager.mainColorDark,
                        textAlign: TextAlign.center,
                      ),

                      28.verticalSpace,

                      /// Buttons Row
                      Row(
                        children: [
                          Expanded(
                            child: MyButton(
                              text: S.of(context).back,
                              onTap: () => context.pop(false),
                              color: AppColorManager.black.withOpacity(0.7),
                            ),
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: MyButton(
                              text: S.of(context).confirm,
                              onTap: () {
                                context.pop(true);
                                onConfirm?.call();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return result ?? false;
  }

  static Future<bool> showErrorDialog(BuildContext context, {required String text, bool tryAgne = true}) async {
    // show the dialog
    final result = await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0.r)),
          ),
          elevation: 10.0,
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DrawableText(
                text: S.of(context).oops,
                size: 20.0.spMin,
                padding: const EdgeInsets.symmetric(vertical: 15.0).h,
                fontWeight: .bold,
                color: AppColorManager.textColor,
              ),
              Divider(height: 25.0.h, color: Colors.black),
              DrawableText(
                text: text,
                textAlign: TextAlign.center,
                size: 16.0.spMin,
                padding: const EdgeInsets.symmetric(vertical: 20.0).h,
                fontWeight: .bold,
                color: AppColorManager.textColor,
              ),
              Divider(height: 25.0.h, color: Colors.black),
              TextButton(
                onPressed: () => context.pop(true),
                child: DrawableText(text: tryAgne ? S.of(context).tryAgain : S.of(context).ok),
              ),
            ],
          ),
        );
      },
    );

    return (result ?? false);
  }

  static void showDialogError(
    BuildContext context, {
    required String text,
  }) {
    // show the dialog
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0.r)),
          ),
          elevation: 10.0,
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DrawableText(
                text: S.of(context).oops,
                size: 20.0.spMin,
                padding: const EdgeInsets.symmetric(vertical: 15.0).h,
                fontWeight: .bold,
                color: AppColorManager.textColor,
              ),
              Divider(height: 25.0.h, color: Colors.black),
              DrawableText(
                text: text,
                textAlign: TextAlign.center,
                size: 16.0.spMin,
                padding: const EdgeInsets.symmetric(vertical: 20.0).h,
                fontWeight: .bold,
                color: AppColorManager.textColor,
              ),
              Divider(height: 25.0.h, color: Colors.black),
              TextButton(
                onPressed: () => context.pop(true),
                child: DrawableText(text: S.of(context).ok),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> showMyDialog(BuildContext context, {required Widget child}) async {
    // show the dialog
    final result = await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0.r),
            ),
          ),
          insetPadding: const EdgeInsets.all(20.0).r,
          elevation: 10.0,
          clipBehavior: Clip.hardEdge,
          child: SingleChildScrollView(
            child: child,
          ),
        );
      },
    );
    return (result ?? false);
  }

  static Future<void> showAwesomeError({required BuildContext context, required String message}) async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: S.of(context).oops,
      headerAnimationLoop: false,
      desc: message,
    ).show();
  }

  static showAwesomeDoneDialog(BuildContext context, {required String message, Function()? onCancel}) async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: S.of(context).done,
      desc: message,
      headerAnimationLoop: false,
      onDismissCallback: (type) => onCancel?.call(),
    ).show();
  }

  static Future<void> showCheckDialog(
    BuildContext context, {
    required String text,
    required String textButton,
    dynamic image,
    Function(bool confirm)? onConfirm,
  }) async {
    // show the dialog
    await showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Dialog(
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0.r))),
            elevation: 10.0,
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 1.0.sw,
                  padding: const EdgeInsets.all(15.0).r,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0.r)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ?image,
                      20.0.verticalSpace,
                      DrawableText(
                        text: text,
                        size: 20.0.sp,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0).r,
                  child: Row(
                    spacing: 15.0,
                    children: [
                      Expanded(
                        child: MyButton(
                          color: AppColorManager.lightGrayAb,
                          onTap: () {
                            context.pop(false);
                            onConfirm?.call(false);
                          },
                          text: S.of(context).back,
                        ),
                      ),
                      Expanded(
                        child: MyButton(
                          color: Colors.red,
                          onTap: () {
                            context.pop(true);
                            onConfirm?.call(true);
                          },
                          text: textButton,
                        ),
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

  static Future<void> showCheckAddDialog(
    BuildContext context, {
    required String text,
    required String textButton,
    required dynamic image,
    Function()? onConfirm,
  }) async {
    // show the dialog
    final result = await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Dialog(
            surfaceTintColor: Colors.white,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0.r),
              ),
            ),
            elevation: 10.0,
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 1.0.sw,
                  padding: const EdgeInsets.all(15.0).r,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: AppColorManager.f8,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0.r)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      50.0.verticalSpace,
                      image is Widget
                          ? image
                          : ImageMultiType(
                              url: image,
                              height: 60.0.r,
                              width: 60.0.r,
                              color: AppColorManager.mainColor,
                            ),
                      20.0.verticalSpace,
                      DrawableText(
                        text: text,
                        size: 20.0.sp,
                        textAlign: TextAlign.center,
                        color: AppColorManager.mainColorLight,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0).r,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => context.pop(true),
                    child: DrawableText(
                      padding: const EdgeInsets.symmetric(vertical: 23.0).r,
                      text: textButton,
                      color: AppColorManager.mainColorLight,
                      matchParent: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == true) {
      onConfirm?.call();
    }
  }

  static showDoneDialog(BuildContext context, {required String text, Function()? onCancel}) {
    // show the dialog
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return Dialog(
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0.r),
            ),
          ),
          elevation: 10.0,
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              10.0.verticalSpace,
              DrawableText(
                text: text,
                size: 16.0.sp,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15).r,
                child: MyButton(
                  text: S.of(context).doneSuccessfully,
                  onTap: () {
                    onCancel?.call();
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
