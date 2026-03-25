import 'package:al_andalus/core/util/bottom_sheets.dart';
import 'package:go_router/go_router.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/features/auth/data/request/login_request.dart';
import 'package:al_andalus/services/firebase_service.dart';
import 'package:al_andalus/services/biometric_auth_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/app/app_provider.dart';
import '../../../../core/app/app_widget.dart';
import '../../../../core/error/error_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/pair_class.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../data/response/login_response.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginInitial> {
  final BiometricAuthService biometricService;

  LoginCubit({BiometricAuthService? authService}) 
      : biometricService = authService ?? BiometricAuthService(),
        super(LoginInitial.initial());

  Future<void> loginWithBiometric() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    final result = await biometricService.authenticateAndRetrieveCredentials();
    if (result.success && result.phone != null && result.password != null) {
      // Credentials fetched successfully via biometrics
      state.mRequest.phone = result.phone;
      state.mRequest.password = result.password;
      await login(); // Execute standard login API call with unlocked credentials
    } else {
      emit(state.copyWith(statuses: CubitStatuses.error, error: result.failure?.message));
      showErrorFromApi(state);
    }
  }

  Future<void> login() async {
    await FirebaseService.getFireTokenAsync();
    emit(state.copyWith(statuses: CubitStatuses.loading));
    final pair = await _loginApi();

    if (pair.first == null) {
      emit(state.copyWith(statuses: CubitStatuses.error, error: pair.second));
      showErrorFromApi(state);
    } else {
      await AppProvider.login(response: pair.first!);
      if (!state.mRequest.phone.isBlank && !state.mRequest.password.isBlank) {
        await biometricService.saveCredentialsSecurely(
            phone: state.mRequest.phone!, password: state.mRequest.password!);
      }
      CachingService.setSupperFilter(AppProvider.supperFilter);
      emit(state.copyWith(statuses: CubitStatuses.done, result: pair.first));
    }
  }

  Future<Pair<LoginResponse?, String?>> _loginApi() async {
    final response = await APIService().callApi(
      type: ApiType.post,
      url: PostUrl.loginUrl,
      body: await state.mRequest.toJson(),
    );

    if (response.statusCode.success) {
      final pair = Pair(LoginResponse.fromJson(response.jsonBody), null);
      return pair;
    } else {
      if (response.statusCode == 311 || response.statusCode == 420) {
        await AppProvider.cachePhone(phone: state.mRequest.phone!, type: StartPage.signupOtp);
        ctx!.goNamed(RouteName.confirmCode);
      }

      if (response.statusCode == 312 || response.statusCode == 430) {
        await AppProvider.cachePhone(phone: state.mRequest.phone!, type: StartPage.signupOtp);
        ctx!.goNamed(RouteName.pin);
      }

      if (response.statusCode == 403) {
        showSupportCall(ctx!, isDismissible: false);
      }
      return response.getPairError as Pair<LoginResponse?, String?>;
    }
  }

  set setPhone(String? phone) => state.mRequest.phone = phone;

  set setPassword(String? password) => state.mRequest.password = password;

  String? get validatePhone {
    if (state.mRequest.phone.isBlank) {
      return '${S().phoneNumber}'
          ' ${S().is_required}';
    }
    return null;
  }

  String? get validatePassword {
    if (state.mRequest.password.isBlank) {
      return '${S().password} ${S().is_required}';
    }
    return null;
  }
}
