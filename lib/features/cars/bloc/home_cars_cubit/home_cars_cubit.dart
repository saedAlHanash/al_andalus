import 'dart:convert';

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

part 'home_cars_state.dart';

class HomeCarsCubit extends MCubit<HomeCarsInitial> {
  HomeCarsCubit() : super(HomeCarsInitial.initial());

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
      // onSuccess: (data, emitState) {
      //   final list = data as List<CarPolicy>;
      //
      //   list.sort((a, b) {
      //     final aTime = a.created?.millisecondsSinceEpoch ?? 0;
      //     final bTime = b.created?.millisecondsSinceEpoch ?? 0;
      //     return bTime.compareTo(aTime);
      //   });
      //
      //   emit(state.copyWith(result: list, statuses: emitState));
      // },
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

  Future<void> rePay({required CarPolicy car, required PaymentType type}) async {
    final request = InsurancePolicyRequest.fromCarPolicy(car);
    request.paymentType = type;

    emit(
      state.copyWith(
        statuses: CubitStatuses.loading,
        cubitCrud: CubitCrud.update,
        request: request,
      ),
    );

    final response = await APIService().callApi(
      type: ApiType.put,
      url: PutUrl.rePay(car.id.toString()),
      body: {'payment_type': type.nameApi},
    );

    _pay(response);
  }

  Future<void> reject({
    required String id,
  }) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.update));

    final response = await APIService().callApi(
      type: ApiType.put,
      url: PutUrl.approveOrReject(id),
      body: {'status': 'cancelled'},
    );

    await _updateState(response);
  }

  Future<void> approve({
    required String id,
  }) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.update));

    final response = await APIService().callApi(
      type: ApiType.put,
      url: PutUrl.approveOrReject(id),
      body: {'status': 'approved'},
    );

    await _updateState(response);
  }

  Future<void> resubscribe({
    required CarPolicy car,
    required String insurancePackageId,
    required PaymentType paymentType,
  }) async {
    final request = InsurancePolicyRequest.fromCarPolicy(car);
    request.insurancePackageId = insurancePackageId;
    request.paymentType = paymentType;

    emit(
      state.copyWith(
        statuses: CubitStatuses.loading,
        cubitCrud: CubitCrud.update,
        request: request,
      ),
    );

    final response = await APIService().callApi(
      type: ApiType.put,
      url: PutUrl.resubscribe(car.id.toString()),
      body: {
        'payment_type': paymentType.nameApi,
        'insurance_package_id': insurancePackageId,
      },
    );

    _pay(response);
  }

  Future<void> cancelInsurance({required String id}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.update));

    final response = await APIService().callApi(
      type: ApiType.put,
      url: PutUrl.cancelInsurance(id),
    );

    await _updateState(response);
  }

  Future<void> create() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.create, uploadProgress: 0.0));

    final files = state.mRequest.files;
    for (int i = 0; i < files.length; i++) {
      files[i].remoteId = (await APIService().uploadFile(file: files[i])).toString();
      emit(state.copyWith(uploadProgress: (i + 1) / files.length));
    }

    final response = await APIService().uploadMultiPart(
      url: PostUrl.createInsurancePolicy,
      fields: state.mRequest.toJson(),
    );

    _pay(response);
  }

  Future<void> update() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.update, uploadProgress: 0.0));

    final files = state.mRequest.files;
    for (int i = 0; i < files.length; i++) {
      files[i].remoteId = (await APIService().uploadFile(file: files[i])).toString();
      emit(state.copyWith(uploadProgress: (i + 1) / files.length));
    }

    final response = await APIService().uploadMultiPart(
      url: PutUrl.updateInsurancePolicy,
      path: state.mRequest.id.toString(),
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
        state.mRequest.frontImage = UploadFile();
        break;
      case ImageZone.engine:
        state.mRequest.backImage = UploadFile();
        break;
      case ImageZone.right:
        state.mRequest.rightSideImage = UploadFile();
        break;
      case ImageZone.left:
        state.mRequest.leftSideImage = UploadFile();
        break;
      case ImageZone.interior:
        state.mRequest.interiorImage = UploadFile();
        break;
      case ImageZone.rear:
        state.mRequest.engineImage = UploadFile();
        break;
    }

    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }

  void setRequest(CarPolicy car) {
    final request = InsurancePolicyRequest.fromCarPolicy(car);
    emit(state.copyWith(request: request));
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
