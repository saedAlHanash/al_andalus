import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../data/response/insurance_package.dart';

part 'insurances_state.dart';

class InsurancesCubit extends MCubit<InsurancesInitial> {
  InsurancesCubit() : super(InsurancesInitial.initial());

  @override
  String get nameCache => 'insurances';

  @override
  AbstractState get mState => state;

  void getDataFromCache() => getFromCache(
    fromJson: InsurancePackage.fromJson,
    state: state,
    onSuccess: (data) {
      emit(state.copyWith(result: data));
    },
  );

  Future<void> getData({bool newData = false}) async {
    await getDataAbstract(
      fromJson: InsurancePackage.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<List<InsurancePackage>?, String?>> _getData() async {
    final response = await APIService().callApi(
      url: GetUrl.insurances,
      type: ApiType.get,
    );
    if (response.statusCode.success) {
      final res = InsurancesResponse.fromJson(response.jsonBody);
      return Pair(res.data, null);
    } else {
      return response.getPairError;
    }
  }
}
