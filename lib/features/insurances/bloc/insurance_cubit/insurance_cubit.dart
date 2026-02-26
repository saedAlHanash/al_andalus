import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../data/response/insurance_package.dart';

part 'insurance_state.dart';

class InsuranceCubit extends MCubit<InsuranceInitial> {
  InsuranceCubit() : super(InsuranceInitial.initial());

  @override
  String get nameCache => 'insurance_item';

  @override
  AbstractState get mState => state;

  void getDataFromCache() => getFromCache(
    fromJson: InsurancePackage.fromJson,
    state: state,
    onSuccess: (data) {
      emit(state.copyWith(result: data));
    },
  );

  Future<void> getData({bool newData = false, required int id}) async {
    emit(state.copyWith(id: id));
    await getDataAbstract(
      fromJson: InsurancePackage.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<InsurancePackage?, String?>> _getData() async {
    final response = await APIService().callApi(
      url: GetUrl.insurances,
      path: state.id.toString(),
      type: ApiType.get,
    );
    if (response.statusCode.success) {
      final res = InsurancePackage.fromJson(response.jsonBody);
      return Pair(res, null);
    } else {
      return response.getPairError;
    }
  }
}
