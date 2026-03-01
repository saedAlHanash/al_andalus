import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:m_cubit/m_cubit.dart';

import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/features/accident/data/response/accident_response.dart';

part 'accident_state.dart';

class AccidentCubit extends MCubit<AccidentInitial> {
  AccidentCubit() : super(AccidentInitial.initial());

  @override
  String get nameCache => 'accident_item';

  @override
  AbstractState get mState => state;

  void getDataFromCache() => getFromCache(
    fromJson: AccidentResponse.fromJson,
    state: state,
    onSuccess: (data) {
      emit(state.copyWith(result: data));
    },
  );

  Future<void> getData({bool newData = false, String? id}) async {
    emit(state.copyWith(id: id));
    await getDataAbstract(
      fromJson: AccidentResponse.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<AccidentResponse?, String?>> _getData() async {
    final response = await APIService().callApi(
      url: GetUrl.claim,
      path: state.id.toString(),
      type: ApiType.get,
    );
    if (response.statusCode.success) {
      final res = AccidentResponse.fromJson(response.jsonBodyData);
      return Pair(res, null);
    } else {
      return response.getPairError;
    }
  }
}
