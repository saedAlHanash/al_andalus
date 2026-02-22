import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/pair_class.dart';
import '../../data/response/support_info_response.dart';

part 'support_info_state.dart';

class SupportInfoCubit extends MCubit<SupportInfoInitial> {
  SupportInfoCubit() : super(SupportInfoInitial.initial());

  @override
  AbstractState get mState => state;

  @override
  String get nameCache => 'support_info';

  Future<void> getData({bool newData = false}) async {
    await getDataAbstract(
      fromJson: SupportInfo.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<SupportInfo?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.supportInfo, // Ensure GetUrl.supportInfo is 'client/v1/support-info'
    );

    if (response.statusCode.success) {
      return Pair(SupportInfo.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }
}
