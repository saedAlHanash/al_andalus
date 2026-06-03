import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/app/app_provider.dart';
import '../../../../core/app/app_widget.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/checker_helper.dart';
import '../../../../core/util/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../../../generated/assets.dart';
import '../../../../router/go_router.dart';
import '../../../../services/deep_link_service.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        if (await checkForceUpdate()) {
          showUpdateDialog(
            ctx!,
            child: const UpdateDialog(),
          );
          return;
        }

        // التحقق من مشاهدة الـ intro
        final hasSeenIntro = AppSharedPreference.hasSeenIntro;

        // إذا لم يشاهد المستخدم الـ intro، نوجهه إليه
        if (!hasSeenIntro) {
          if (ctx!.mounted) ctx!.goNamed(RouteName.intro);
          return;
        }

        if (!ctx!.mounted) return;

        // التحقق من وجود deep link معلق والتنقل إليه
        if (DeepLinkService.hasPendingDeepLink) {
          DeepLinkService.handlePendingNavigation();
          return;
        }

        switch (getStartPage) {
          case StartPage.login:
          // ctx!.goNamed(RouteName.login);
          // break;
          case StartPage.home:
            ctx!.goNamed(RouteName.home);
            break;
          case StartPage.signupOtp:
            ctx!.goNamed(RouteName.confirmCode);
          case StartPage.pinCode:
            ctx!.goNamed(RouteName.pin);
          case StartPage.passwordOtp:
            ctx!.goNamed(RouteName.resetPasswordPage);
            break;
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0).r,
        width: 1.0.sw,
        height: 1.0.sh,
        child: const Center(
          child: ImageMultiType(url: Assets.imagesLogo),
        ),
      ),
    );
  }
}
