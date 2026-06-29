import 'package:m_cubit/m_cubit.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/api_manager/api_url.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/pair_class.dart';
import '../../data/response/transfer_fee.dart';

part 'transfer_fees_state.dart';

class TransferFeesCubit extends MCubit<TransferFeesInitial> {
  TransferFeesCubit() : super(TransferFeesInitial.initial());

  @override
  AbstractState get mState => state;

  Future<void> getData({bool newData = false}) async {
    await getDataAbstract(
      fromJson: TransferFee.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<TransferFee?, String?>> _getData() async {
    final response = await APIService().callApi(
      url: GetUrl.transferFees,
      type: ApiType.get,
    );
    if (response.statusCode.success) {
      return Pair(TransferFee.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }
}
