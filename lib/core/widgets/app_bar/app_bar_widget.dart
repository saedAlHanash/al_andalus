import 'dart:math' as math;

import 'package:al_andalus/core/util/shared_preferences.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../generated/assets.dart';
import '../../strings/app_color_manager.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.titleText,
    this.elevation,
    this.zeroHeight,
    this.leading,
    this.actions,
    this.title,
    this.color,
    this.canPop = true,
    this.imageAppBar = false,
    this.imageFromPage,
    this.onPopInvoked,
  });

  final String? titleText;
  final Widget? title;
  final Widget? leading;
  final Color? color;
  final bool? zeroHeight;
  final double? elevation;
  final List<Widget>? actions;
  final bool canPop;
  final bool imageAppBar;
  final Widget? imageFromPage;

  final Function(bool b, dynamic result)? onPopInvoked;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onPopInvoked,
      child: AppBar(
        backgroundColor: color,
        surfaceTintColor: color,
        toolbarHeight: (zeroHeight ?? false) ? 0 : 70.0.h,
        // scrolledUnderElevation: 0,
        title:
            title ??
            DrawableText(
              text: titleText ?? '',
              size: 18.0.spMin,
            ),
        leading:
            leading ??
            (context.canPop()
                ? BackBtnWidget(
                    canPop: canPop,
                    onPopInvoked: onPopInvoked,
                    appBarColor: imageAppBar ? AppColorManager.black : color ?? AppColorManager.textColor,
                  )
                : null),
        flexibleSpace:
            imageFromPage ??
            (imageAppBar
                ? Column(
                    children: [
                      MediaQuery.of(context).padding.top.verticalSpace,
                      ImageMultiType(
                        height: 70.h,
                        width: 1.sw,
                        fit: BoxFit.fill,
                        url: Assets.icons.appBarBack.path,
                      ),
                      // MediaQuery.of(context).padding.top.verticalSpace,
                    ],
                  )
                : null),
        centerTitle: true,
        actions: actions,
        elevation: elevation ?? 0.0,
        shadowColor: elevation == 0 ? null : AppColorManager.black.withValues(alpha: 0.28),
        iconTheme: IconThemeData(color: AppColorManager.textColor),
      ),
    );
  }

  @override
  Size get preferredSize => Size(1.0.sw, (zeroHeight ?? false) ? 0 : 70.0.h);
}

class BackBtnWidget extends StatelessWidget {
  const BackBtnWidget({
    super.key,
    required this.appBarColor,
    this.canPop = true,
    this.onPopInvoked,
  });

  final Color appBarColor;
  final bool canPop;

  final Function(bool, dynamic)? onPopInvoked;

  @override
  Widget build(BuildContext context) {
    if (!context.canPop()) return 0.0.verticalSpace;
    return IconButton(
      onPressed: () {
        if (!canPop) {
          onPopInvoked?.call(false, null);
          return;
        }
        if (!context.canPop()) return;
        context.pop();
      },
      icon: Transform.rotate(
        angle: AppSharedPreference.getLocal == 'en' ? math.pi : 0,
        child: ImageMultiType(
          url: Assets.icons.back.path,
          color: AppColorManager.textColor,
        ),
      ),
    );
  }
}
