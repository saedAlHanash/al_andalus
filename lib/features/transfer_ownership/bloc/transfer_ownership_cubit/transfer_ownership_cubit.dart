import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/error/error_manager.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../data/request/transfer_ownership_request.dart';
import '../../data/response/transfer_ownership_response.dart';

part 'transfer_ownership_state.dart';

class TransferOwnershipCubit extends MCubit<TransferOwnershipState> {
  TransferOwnershipCubit() : super(TransferOwnershipState.initial());

  @override
  AbstractState get mState => state;

  Future<void> transferOwnership() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.create));

    final response = await APIService().callApi(
      type: .post,
      url: PostUrl.transferOwnership,
      body: state.mRequest.toJson(),
    );

    if (response.statusCode.success) {
      emit(
        state.copyWith(statuses: CubitStatuses.done, result: TransferOwnershipResponse.fromJson(response.jsonBody)),
      );
    } else {
      emit(
        state.copyWith(statuses: CubitStatuses.error, error: response.getPairError.second),
      );
      showErrorFromApi(state);
    }
  }

  void setQr(String id) {
    state.mRequest.qrcode = id;
    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }

  void setPaymentType(PaymentType paymentType) {
    state.mRequest.paymentType = paymentType;
    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }
}
