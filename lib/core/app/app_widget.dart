import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/features/auth/bloc/delete_account_cubit/delete_account_cubit.dart';
import 'package:al_andalus/features/profile/bloc/update_profile_cubit/update_profile_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:m_cubit/caching_service/caching_service.dart';

import '../../features/ads/bloc/adss_cubit/adss_cubit.dart';
import '../../features/category/bloc/categories_cubit/categories_cubit.dart';
import '../../features/governorate/bloc/governorate_cubit/governorate_cubit.dart';
import '../../features/governorate/bloc/governorates_cubit/governorates_cubit.dart';
import '../../features/insurances/bloc/insurances_cubit/insurances_cubit.dart';
import '../../features/notification/bloc/all_notification_cubit/all_notification_cubit.dart';
import '../../features/policies/bloc/support_info_cubit/support_info_cubit.dart';
import '../../features/profile/bloc/get_me_cubit/get_me_cubit.dart';
import '../../features/transfer_ownership/bloc/transfer_fees_cubit/transfer_fees_cubit.dart';
import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../../router/go_router.dart';
import '../app_theme.dart';
import '../injection/injection_container.dart';
import '../util/shared_preferences.dart';
import 'app_provider.dart';
import 'bloc/loading_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static Future<void> setLocale(BuildContext context, String langCode) async {
    await AppSharedPreference.cashLocal(langCode);
    CachingService.setSupperFilter(AppProvider.supperFilter);
    if (context.mounted) {
      final state = context.findAncestorStateOfType<_MyAppState>();
      await state?.setLocale(Locale.fromSubtags(languageCode: AppSharedPreference.getLocal));
    }
  }

  static Future<void> setTheme(BuildContext context, ThemeMode themeMode) async {
    await AppSharedPreference.cashThemeMode(themeMode);
    if (context.mounted) {
      final state = context.findAncestorStateOfType<_MyAppState>();
      state?.setTheme(themeMode);
    }
  }

  static Future<void> setFont(BuildContext context, String fontName) async {
    await AppSharedPreference.cashFontName(fontName);
    if (context.mounted) {
      final state = context.findAncestorStateOfType<_MyAppState>();
      state?.setFont(fontName);
    }
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    S.load(Locale(AppSharedPreference.getLocal));

    setImageMultiTypeErrorImage(
      const Opacity(
        opacity: 0.3,
        child: ImageMultiType(
          url: Assets.imagesLogo,
          height: 30.0,
          width: 30.0,
        ),
      ),
    );
    super.initState();
  }

  Future<void> setLocale(Locale locale) async {
    AppSharedPreference.cashLocal(locale.languageCode);
    await S.load(locale);
    setState(() {});
  }

  void setTheme(ThemeMode themeMode) {
    setState(() => this.themeMode = themeMode);
  }

  void setFont(String fontName) {
    setState(() {});
  }

  ThemeMode themeMode = AppSharedPreference.getThemeMode;

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: MediaQuery.of(context).size,
      // designSize: const Size(375, 812),
      // designSize: const Size(14440, 972),
      minTextAdapt: true,
      // splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: goRouter,
          locale: Locale.fromSubtags(languageCode: AppSharedPreference.getLocal),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          builder: (_, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => sl<LoadingCubit>()),
                BlocProvider(create: (_) => sl<GovernorateCubit>()),
                BlocProvider(create: (_) => sl<DeleteAccountCubit>()),
                BlocProvider(create: (_) => sl<UpdateProfileCubit>()),
                BlocProvider(create: (_) => sl<GetMeCubit>()..getData()),
                BlocProvider(create: (_) => sl<GovernoratesCubit>()..getData()),
                BlocProvider(create: (_) => sl<AdssCubit>()..getData()),
                BlocProvider(create: (_) => sl<InsurancesCubit>()..getData()),
                BlocProvider(create: (_) => sl<NotificationCubit>()..getData()),
                BlocProvider(create: (_) => sl<TransferFeesCubit>()..getData(), lazy: false),
                BlocProvider(create: (_) => sl<SupportInfoCubit>()..getData(), lazy: false),
              ],
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(.85)),
                child: SafeArea(
                  bottom: true,
                  top: false,
                  left: false,
                  right: false,
                  child: GestureDetector(
                    onTap: () {
                      final currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
                    child: child!,
                  ),
                ),
              ),
            );
          },
          scrollBehavior: MyCustomScrollBehavior(),
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

BuildContext? get ctx => sl<GlobalKey<NavigatorState>>().currentContext;
