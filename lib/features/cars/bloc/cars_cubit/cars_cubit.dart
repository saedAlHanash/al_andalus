import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/features/cars/data/request/insurance_policy_request.dart';
import 'package:http/http.dart';
import 'package:m_cubit/m_cubit.dart';

import 'package:al_andalus/features/cars/data/response/cars_response.dart';

import '../../../../core/error/error_manager.dart';

part 'cars_state.dart';

class CarsCubit extends MCubit<CarsInitial> {
  CarsCubit() : super(CarsInitial.initial());

  @override
  String get nameCache => 'my_cars';

  @override
  AbstractState get mState => state;

  //region getData

  void getDataFromCache() => getFromCache(
    fromJson: CarPolicy.fromJson,
    state: state,
    onSuccess: (data) {
      emit(state.copyWith(result: data));
    },
  );

  Future<void> getData({bool newData = false}) async {
    await getDataAbstract(
      fromJson: CarPolicy.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<List<CarPolicy>?, String?>> _getData() async {
    final response = await APIService().callApi(
      url: GetUrl.myCars,
      type: ApiType.get,
    );

    if (response.statusCode.success) {
      return Pair(CarPolicies.fromJson(response.jsonBody).data, null);
    } else {
      return response.getPairError;
    }
  }

  //endregion

  //region CRUD

  Future<void> rePay({required String id, required PaymentType type}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.create));

    final response = await APIService().callApi(
      type: .put,
      url: PutUrl.rePay(id),
      body: {'payment_type': type.nameApi},
    );

    _pay(response);
  }

  Future<void> create() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.create));

    final response = await APIService().uploadMultiPart(
      url: PostUrl.createInsurancePolicy,
      files: state.mRequest.files,
      fields: state.mRequest.toJson(),
    );
    _pay(response);
  }

  Future<void> update() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.update));

    final response = await APIService().uploadMultiPart(
      url: PutUrl.updateInsurancePolicy,
      type: 'POST',
      // Usually multipart update is POST with method override or just POST
      path: state.id.toString(),
      files: state.mRequest.files,
      fields: state.mRequest.toJson(),
    );
    await _updateState(response);
  }

  Future<void> delete({required String id}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.delete, id: id));

    final response = await APIService().callApi(
      type: ApiType.delete,
      url: DeleteUrl.deleteInsurancePolicy,
      path: state.id.toString(),
    );

    await _updateState(response, isDelete: true);
  }

  Future<void> _updateState(Response response, {bool isDelete = false}) async {
    if (response.statusCode.success) {
      if (isDelete) {
        await deleteCarFromCache(state.id.toString());
      } else {
        final item = CarPolicy.fromJson(response.jsonBodyData);
        await addOrUpdateCarToCache(item);
      }
      emit(state.copyWith(statuses: CubitStatuses.done));
    } else {
      emit(state.copyWith(statuses: CubitStatuses.error, error: response.getPairError.second));
      showErrorFromApi(state);
    }
  }

  Future<void> _pay(Response response) async {
    if (response.statusCode.success) {
      final url = response.jsonBody['url'] ?? '';
      emit(state.copyWith(idNotifier: state.idNotifier + 1, statuses: CubitStatuses.done, url: url));
    } else {
      emit(state.copyWith(statuses: CubitStatuses.error, error: response.getPairError.second));
      showErrorFromApi(state);
    }
  }

  Future<void> doneOpenUrl() async {
    emit(state.copyWith(idNotifier: state.idNotifier + 1, url: ''));
  }

  //endregion

  void setCylindersAndValue() {}

  void next({int? step}) {
    if (step != null) {
      if (state.step < step) return;
      emit(state.copyWith(step: step));
      return;
    }
    emit(state.copyWith(step: state.step + 1));
  }

  void setImage(UploadFile value, ImageZone zone) {
    switch (zone) {
      case ImageZone.front:
        state.mRequest.frontImage = value;
        break;
      case ImageZone.engine:
        state.mRequest.backImage = value;
        break;
      case ImageZone.right:
        state.mRequest.rightSideImage = value;
        break;
      case ImageZone.left:
        state.mRequest.leftSideImage = value;
        break;
      case ImageZone.interior:
        state.mRequest.interiorImage = value;
        break;
      case ImageZone.rear:
        state.mRequest.engineImage = value;
        break;
    }

    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }

  void removeImage(ImageZone zone) {
    switch (zone) {
      case ImageZone.front:
        state.mRequest.frontImage
          ..fileBytes = null
          ..path = null
          ..extension = null
          ..fileType;
        break;
      case ImageZone.engine:
        state.mRequest.backImage
          ..fileBytes = null
          ..path = null
          ..extension = null
          ..fileType;
        break;
      case ImageZone.right:
        state.mRequest.rightSideImage
          ..fileBytes = null
          ..path = null
          ..extension = null
          ..fileType;
        break;
      case ImageZone.left:
        state.mRequest.leftSideImage
          ..fileBytes = null
          ..path = null
          ..extension = null
          ..fileType;
        break;
      case ImageZone.interior:
        state.mRequest.interiorImage
          ..fileBytes = null
          ..path = null
          ..extension = null
          ..fileType;
        break;
      case ImageZone.rear:
        state.mRequest.engineImage
          ..fileBytes = null
          ..path = null
          ..extension = null
          ..fileType;
        break;
    }

    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }

  Future<void> addOrUpdateCarToCache(CarPolicy item) async {
    final listJson = await addOrUpdateDate([item]);
    if (listJson == null) return;
    final list = listJson.map((e) => CarPolicy.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }

  Future<void> deleteCarFromCache(String id) async {
    final listJson = await deleteDate([id]);
    if (listJson == null) return;
    final list = listJson.map((e) => CarPolicy.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }
}
