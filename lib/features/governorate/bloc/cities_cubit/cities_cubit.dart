import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:al_andalus/features/governorate/data/response/governorate_response.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/widgets/spinner_widget.dart';

part 'cities_state.dart';

class CitiesCubit extends MCubit<CitiesInitial> {
  CitiesCubit() : super(CitiesInitial.initial());

  @override
  AbstractState get mState => state;

  @override
  String get nameCache => 'cities';

  @override
  String get filter => state.request?.toString() ?? '';

  Future<void> getData({bool newData = false, required String governorateId}) async {
    emit(state.copyWith(request: governorateId));
    await getDataAbstract(
      fromJson: City.fromJson,
      state: state,
      getDataApi:  _getData,
      newData: newData,
    );
  }

  Future<Pair<List<City>?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.address, // Assuming this is the endpoint for cities, adjust if needed
      query: {'governorate_id': state.request.toString()},
    );

    if (response.statusCode.success) {
      final List data = response.jsonBody['data'] ?? [];
      return Pair(data.map((e) => City.fromJson(e)).toList(), null);
    } else {
      return response.getPairError;
    }
  }

  void selectCity(String id) {
    emit(state.copyWith(id: id));
  }
}
