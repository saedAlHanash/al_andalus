import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../data/request/transfer_ownership_request.dart';
import '../../data/response/transfer_ownership_response.dart';

part 'transfer_ownership_state.dart';

class TransferOwnershipCubit extends MCubit<TransferOwnershipState> {
  TransferOwnershipCubit() : super(TransferOwnershipState.initial());

  @override
  AbstractState get mState => state;

  Future<void> transferOwnership() async {
    emit(
      state.copyWith(
        statuses: CubitStatuses.loading,
        cubitCrud: CubitCrud.create,
      ),
    );

    final response = await APIService().uploadMultiPart(
      url: PostUrl.transferOwnership,
      files: state.mRequest.files,
      fields: state.mRequest.toJson(),
    );

    if (response.statusCode.success) {
      emit(
        state.copyWith(
          statuses: CubitStatuses.done,
          result: TransferOwnershipResponse.fromJson(response.jsonBody),
        ),
      );
    } else {
      emit(
        state.copyWith(
          statuses: CubitStatuses.error,
          error: response.getPairError.second,
        ),
      );
    }
  }

  void updateName(String name) {
    state.mRequest.newOwnerName = name;
    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }

  void updatePhone(String phone) {
    state.mRequest.newOwnerPhone = phone;
    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }

  void updateIdentityNumber(String number) {
    state.mRequest.newOwnerIdentityNumber = number;
    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }

  void setPolicyId(int id) {
    state.mRequest.policyId = id;
    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }

  void setImage(UploadFile file, bool isFront) {
    if (isFront) {
      state.mRequest.identityFrontImage = file;
    } else {
      state.mRequest.identityBackImage = file;
    }
    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }
}
