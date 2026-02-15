import 'dart:async';

import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/error/error_manager.dart';
import '../../../../core/util/pair_class.dart';
import '../../data/Request/update_profile_Request.dart';
import '../../data/response/profile_response.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends MCubit<UpdateProfileInitial> {
  UpdateProfileCubit() : super(UpdateProfileInitial.initial());

  @override
  AbstractState get mState => state;

  @override
  String get nameCache => 'updateProfile';

  Future<void> updateProfile() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));

    final pair = await _updateProfileApi();

    if (pair.first == null) {
      emit(state.copyWith(error: pair.second, statuses: CubitStatuses.error));
      showErrorFromApi(state);
    } else {
      emit(state.copyWith(statuses: CubitStatuses.done, result: pair.first));
    }
  }

  Future<Pair<Profile?, String?>> _updateProfileApi() async {
    final response = await APIService().uploadMultiPart(url: PostUrl.updateProfile, fields: state.mRequest.toJson());

    if (response.statusCode.success) {
      return Pair(Profile.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }

  set setName(String? name) => state.mRequest.name = name;

  set setPhone(String? phone) => state.mRequest.phone = phone;

  set setEmail(String? phone) => state.mRequest.phone = phone;
}
