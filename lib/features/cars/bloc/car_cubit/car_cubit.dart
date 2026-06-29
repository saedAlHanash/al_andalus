import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:al_andalus/features/cars/data/response/cars_response.dart';
import 'package:m_cubit/m_cubit.dart';

part 'car_state.dart';

class CarCubit extends MCubit<CarInitial> {
  CarCubit() : super(CarInitial.initial());

  @override
  String get nameCache => 'car_item';

  @override
  AbstractState get mState => state;

  @override
  String get filter => state.filter;

  void getDataFromCache() => getFromCache(
    fromJson: CarPolicy.fromJson,
    state: state,
    onSuccess: (data) {
      emit(state.copyWith(result: data));
    },
  );

  Future<void> getData({bool newData = false, String? id}) async {
    emit(state.copyWith(id: id, qr: ''));
    await getDataAbstract(
      fromJson: CarPolicy.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<void> getDataByQr({bool newData = false, required String qr}) async {
    emit(state.copyWith(qr: qr, id: ''));
    await getDataAbstract(
      fromJson: CarPolicy.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<CarPolicy?, String?>> _getData() async {
    final response = await APIService().callApi(
      url: state.qr.isNotEmpty ? GetUrl.vehicleByQr : GetUrl.myCars,
      path: state.qr.isNotEmpty ? state.qr : state.id.toString(),
      type: ApiType.get,
    );
    if (response.statusCode.success) {
      final res = CarPolicy.fromJson(response.jsonBodyData);
      return Pair(res, null);
    } else {
      return response.getPairError;
    }
  }
}
