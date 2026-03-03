import 'dart:convert';

import 'package:al_andalus/features/auth/ui/pages/confirm_code/confirm_edit_phone_page.dart';
import 'package:al_andalus/features/policies/ui/pages/data_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/injection/injection_container.dart';
import '../core/strings/enum_manager.dart';
import '../core/widgets/pdf_viewer_page.dart';
import '../core/widgets/qr_scanner_page.dart';
import '../features/ads/bloc/ads_cubit/ads_cubit.dart';
import '../features/auth/bloc/change_password_cubit/change_password_cubit.dart';
import '../features/auth/bloc/confirm_code_cubit/confirm_code_cubit.dart';
import '../features/auth/bloc/forget_password_cubit/forget_password_cubit.dart';
import '../features/auth/bloc/login_cubit/login_cubit.dart';
import '../features/auth/bloc/otp_password_cubit/otp_password_cubit.dart';
import '../features/auth/bloc/resend_code_cubit/resend_code_cubit.dart';
import '../features/auth/bloc/reset_password_cubit/reset_password_cubit.dart';
import '../features/auth/bloc/signup_cubit/signup_cubit.dart';
import '../features/auth/ui/pages/change_password_page.dart';
import '../features/auth/ui/pages/confirm_code/confirm_code_page.dart';
import '../features/auth/ui/pages/done_page.dart';
import '../features/auth/ui/pages/forget_passowrd_page.dart';
import '../features/auth/ui/pages/login_page.dart';
import '../features/auth/ui/pages/otp_password_page.dart';
import '../features/auth/ui/pages/reset_password_page.dart';
import '../features/auth/ui/pages/signup_page.dart';
import '../features/auth/ui/pages/splash_screen_page.dart';
import '../features/cars/bloc/car_cubit/car_cubit.dart';
import '../features/cars/bloc/cars_cubit/cars_cubit.dart';
import '../features/cars/ui/pages/add_car_page.dart';
import '../features/cars/ui/pages/car_page.dart';
import '../features/cars/ui/pages/cars_page.dart';
import '../features/cars/ui/pages/custome_web_page_view.dart';
import '../features/accident/bloc/accidents_cubit/accidents_cubit.dart';
import '../features/accident/ui/pages/add_accident_page.dart';
import '../features/category/ui/pages/categorys_page.dart';
import '../features/transfer_ownership/bloc/transfer_ownership_cubit.dart';
import '../features/transfer_ownership/ui/pages/transfer_ownership_page.dart';
import '../features/home/ui/pages/home_page.dart';
import '../features/insurances/bloc/insurance_cubit/insurance_cubit.dart';
import '../features/insurances/data/response/insurance_package.dart';
import '../features/insurances/ui/pages/insurance_page.dart';
import '../features/intro/ui/pages/intro_page.dart';
import '../features/policies/bloc/policy_cubit/policy_cubit.dart';
import '../features/profile/bloc/update_profile_cubit/update_profile_cubit.dart';
import '../features/profile/ui/pages/edit_driving_license.dart';
import '../features/profile/ui/pages/edit_identity_info.dart';
import '../features/profile/ui/pages/edit_phone_page.dart';
import '../features/profile/ui/pages/profile_page.dart';

final navigatorKey = sl<GlobalKey<NavigatorState>>();

final goRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteName.splash,
  routes: [
    //region auth
    GoRoute(
      path: RouteName.splash,
      name: RouteName.splash,
      builder: (_, state) => const SplashScreenPage(),
    ),
    GoRoute(
      path: RouteName.intro,
      name: RouteName.intro,
      builder: (_, state) => const IntroPage(),
    ),
    GoRoute(
      path: RouteName.signup,
      name: RouteName.signup,
      builder: (_, state) {
        return BlocProvider(
          create: (_) => sl<SignupCubit>(),
          child: const SignupPage(),
        );
      },
    ),
    GoRoute(
      path: RouteName.login,
      name: RouteName.login,
      builder: (_, state) {
        return BlocProvider(
          create: (_) => sl<LoginCubit>(),
          child: const LoginPage(),
        );
      },
    ),
    GoRoute(
      path: RouteName.forgetPassword,
      name: RouteName.forgetPassword,
      builder: (_, state) {
        final phone = state.uri.queryParameters['phone'];
        return BlocProvider(
          create: (_) => sl<ForgetPasswordCubit>(),
          child: ForgetPasswordPage(phone: phone),
        );
      },
    ),
    GoRoute(
      path: RouteName.resetPasswordPage,
      name: RouteName.resetPasswordPage,
      builder: (_, state) {
        return BlocProvider(
          create: (_) => sl<ResetPasswordCubit>(),
          child: const ResetPasswordPage(),
        );
      },
    ),
    GoRoute(
      path: RouteName.confirmCode,
      name: RouteName.confirmCode,
      builder: (_, state) {
        final bool isEditPhone = state.uri.queryParameters['isEditPhone'] == 'true';
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<ConfirmCodeCubit>()),
            BlocProvider(create: (_) => sl<ResendCodeCubit>()),
          ],
          child: isEditPhone ? ConfirmEditPhonePage() : const ConfirmCodePage(),
        );
      },
    ),
    GoRoute(
      path: RouteName.otpPassword,
      name: RouteName.otpPassword,
      builder: (_, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<OtpPasswordCubit>()),
            BlocProvider(create: (_) => sl<ResendCodeCubit>()),
          ],
          child: const OtpPasswordPage(),
        );
      },
    ),
    GoRoute(
      path: RouteName.donePage,
      name: RouteName.donePage,
      builder: (_, state) {
        return const DonePage();
      },
    ),
    GoRoute(
      path: RouteName.changePasswordPage,
      name: RouteName.changePasswordPage,
      builder: (_, state) {
        return BlocProvider(
          create: (_) => sl<ChangePasswordCubit>(),
          child: const ChangePasswordPage(),
        );
      },
    ),
    //endregion

    //region home
    GoRoute(
      path: RouteName.home,
      name: RouteName.home,
      builder: (_, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<AdsCubit>()..getData()),
            BlocProvider(create: (_) => sl<CarsCubit>()..getData()),
          ],
          child: Homepage(),
        );
      },
    ),
    //endregion

    //region settings
    GoRoute(
      path: RouteName.profile,
      name: RouteName.profile,
      builder: (_, state) {
        return BlocProvider(
          create: (_) => sl<UpdateProfileCubit>(),
          child: const ProfilePage(),
        );
      },
    ),
    GoRoute(
      path: RouteName.editPhonePage,
      name: RouteName.editPhonePage,
      builder: (_, state) {
        return BlocProvider(
          create: (_) => sl<UpdateProfileCubit>(),
          child: const EditPhonePage(),
        );
      },
    ),
    GoRoute(
      path: RouteName.editIdentityInfo,
      name: RouteName.editIdentityInfo,
      builder: (_, state) {
        return BlocProvider(
          create: (_) => sl<UpdateProfileCubit>(),
          child: const EditIdentityInfo(),
        );
      },
    ),
    GoRoute(
      path: RouteName.editDrivingLicense,
      name: RouteName.editDrivingLicense,
      builder: (_, state) {
        return BlocProvider(
          create: (_) => sl<UpdateProfileCubit>(),
          child: const EditDrivingLicense(),
        );
      },
    ),
    //endregion

    //region categories
    GoRoute(
      path: RouteName.categories,
      name: RouteName.categories,
      builder: (_, state) {
        return CategoriesPage();
      },
    ),
    //endregion

    //region dataPage
    GoRoute(
      path: RouteName.dataPage,
      name: RouteName.dataPage,
      builder: (_, state) {
        final type = DataPageType.values[int.parse(state.uri.queryParameters['type']!)];
        return BlocProvider(
          create: (context) => sl<PolicyCubit>()..getData(type: type),
          child: DataPage(),
        );
      },
    ),
    //endregion

    //region insurance
    GoRoute(
      path: RouteName.insurancePage,
      name: RouteName.insurancePage,
      builder: (_, state) {
        final id = state.uri.queryParameters['id'] ?? '';
        final json = jsonDecode(state.uri.queryParameters['json'] ?? '{}');
        final estimatedPrice = double.tryParse(state.uri.queryParameters['price'] ?? '0.0') ?? 0;
        final cylinderId = int.tryParse(state.uri.queryParameters['cylinders'] ?? '0') ?? 0;
        final package = InsurancePackage.fromJson(json);

        return BlocProvider(
          create: (context) => sl<InsuranceCubit>()
            ..setEstimatedPrice(estimatedPrice)
            ..setSelectedCylinder(cylinderId)
            ..getData(id: id),
          child: InsurancePage(),
        );
      },
    ),

    //endregion

    //region cars
    GoRoute(
      path: RouteName.addCarPage,
      name: RouteName.addCarPage,
      builder: (_, state) {
        final id = state.uri.queryParameters['id'] ?? '';
        final price = double.tryParse(state.uri.queryParameters['price'] ?? '0.0') ?? 0;
        final cylindersCount = int.tryParse(state.uri.queryParameters['cylinders'] ?? '0') ?? 0;
        return BlocProvider(
          create: (context) => sl<CarsCubit>()
            ..state.mRequest.cylinders = cylindersCount.toString()
            ..state.mRequest.value = price.toString()
            ..state.mRequest.insurancePackageId = id,
          child: AddCarPage(),
        );
      },
    ),

    GoRoute(
      path: RouteName.carsPage,
      name: RouteName.carsPage,
      builder: (_, state) {
        return BlocProvider(
          create: (context) => sl<CarsCubit>(),
          child: const CarsPage(),
        );
      },
    ),

    GoRoute(
      path: RouteName.carPage,
      name: RouteName.carPage,
      builder: (_, state) {
        final id = state.uri.queryParameters['id'] ?? '';
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<CarCubit>()..getData(id: id)),
            BlocProvider(create: (context) => sl<CarsCubit>()),
          ],
          child: CarPage(),
        );
      },
    ),

    //endregion

    //region accident
    GoRoute(
      path: RouteName.addAccidentPage,
      name: RouteName.addAccidentPage,
      builder: (_, state) {
        final vehicleId = state.uri.queryParameters['vehicleId'] ?? '';
        return BlocProvider(
          create: (context) => sl<AccidentsCubit>()..state.mRequest.vehicleId = vehicleId,
          child: AddAccidentPage(),
        );
      },
    ),

    //endregion
    GoRoute(
      path: RouteName.qrScanner,
      name: RouteName.qrScanner,
      builder: (_, state) => const QrScannerPage(),
    ),
    GoRoute(
      path: RouteName.transferOwnershipPage,
      name: RouteName.transferOwnershipPage,
      builder: (_, state) {
        final policyId = int.tryParse(state.uri.queryParameters['policyId'] ?? '');
        return BlocProvider(
          create: (context) => TransferOwnershipCubit()..setPolicyId(policyId ?? 0),
          child: const TransferOwnershipPage(),
        );
      },
    ),

    /// webView
    GoRoute(
      path: RouteName.webView,
      name: RouteName.webView,
      builder: (_, state) {
        final String url = (state.uri.queryParameters['url'] ?? '').toString();
        return MyCustomWebPage(urlWebPage: url);
      },
    ),

    GoRoute(
      path: RouteName.pdf,
      name: RouteName.pdf,
      builder: (_, state) {
        final String url = (state.uri.queryParameters['url'] ?? '').toString();
        return PdfViewerWidget(url: url);
      },
    ),
  ],
);

class RouteName {
  static const splash = '/';
  static const products = '/products';
  static const product = '/product';
  static const welcomeScreen = '/welcomeScreen';
  static const home = '/home';
  static const forgetPassword = '/forgetPassword';
  static const resetPasswordPage = '/resetPasswordPage';
  static const login = '/login';
  static const signup = '/signup';
  static const confirmCode = '/confirmCode';
  static const otpPassword = '/otpPassword';
  static const donePage = '/donePage';
  static const teacher = '/teacher';
  static const profile = '/profile';
  static const changePasswordPage = '/changePasswordPage';
  static const notifications = '/notifications';
  static const pdf = '/pdf';
  static const lesson = '/lesson';
  static const pay = '/pay';
  static const chapters = '/chapters';
  static const lessons = '/lessons';
  static const player = '/player';
  static const search = '/search';
  static const teacherSubscriptions = '/teacherSubscriptions';
  static const map = '/map';
  static const address = '/address';
  static const groups = '/groups';
  static const rooms = '/rooms';
  static const sections = '/sections';
  static const grades = '/grades';
  static const startExam = '/startExam';
  static const examScore = '/examScore';
  static const orders = '/orders';
  static const order = '/order';
  static const categories = '/categories';
  static const cart = '/cart';
  static const intro = '/intro';
  static const dataPage = '/dataPage';
  static const editPhonePage = '/editPhonePage';
  static const editIdentityInfo = '/editIdentityInfo';
  static const editDrivingLicense = '/editDrivingLicense';
  static const insurancePage = '/insurancePage';
  static const carsPage = '/carsPage';
  static const carPage = '/carPage';
  static const addCarPage = '/addCarPage';
  static const addAccidentPage = '/addAccidentPage';
  static const webView = '/webView';
  static const String qrScanner = '/qrScanner';
  static const String transferOwnershipPage = '/transferOwnershipPage';
}
