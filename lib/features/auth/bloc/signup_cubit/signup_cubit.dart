import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/error/error_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/pair_class.dart';
import '../../../../generated/l10n.dart';
import '../../data/request/signup_request.dart';

part 'signup_state.dart';

class SignupCubit extends MCubit<SignupInitial> {
  SignupCubit() : super(SignupInitial.initial());

  @override
  AbstractState get mState => state;

  @override
  String get nameCache => 'signup';

  Future<void> signup() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));

    final pair = await _signupApi();

    if (pair.first == null) {
      emit(state.copyWith(error: pair.second, statuses: CubitStatuses.error));
      showErrorFromApi(state);
    } else {
      await AppProvider.cachePhone(phone: state.mRequest.phone!, type: StartPage.signupOtp);

      emit(state.copyWith(statuses: CubitStatuses.done, result: pair.first));
    }
  }

  Future<Pair<bool?, String?>> _signupApi() async {
    for (var file in state.mRequest.files) {
      file.remoteId = (await APIService().uploadFile(file: file)).toString();
    }

    final response = await APIService().uploadMultiPart(
      url: PostUrl.signup,

      fields: state.mRequest.toJson(),
    );

    if (response.statusCode.success) {
      return Pair(true, null);
    } else {
      return response.getPairError;
    }
  }

  void next({int? step}) {
    if (step != null) {
      if (state.step < step) return;
      emit(state.copyWith(step: step));
      return;
    }
    emit(state.copyWith(step: state.step + 1));
  }
}
