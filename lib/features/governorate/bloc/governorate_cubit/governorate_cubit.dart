import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:al_andalus/features/governorate/data/response/governorate_response.dart';
import 'package:m_cubit/abstraction.dart';

part 'governorate_state.dart';

class GovernorateCubit extends MCubit<GovernorateInitial> {
  GovernorateCubit() : super(GovernorateInitial.initial());

  @override
  AbstractState get mState => state;

  @override
  String get nameCache => 'governorate';

  @override
  String get filter => state.filter;

  Future<void> getData({bool newData = false, String? governorateId}) async {
    emit(state.copyWith(request: governorateId));

    await getDataAbstract(
      fromJson: Governorate.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<Governorate?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.governorate,
      query: {'Id': state.request},
    );

    if (response.statusCode.success) {
      return Pair(Governorate.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }

  void setGovernorate(dynamic governorate) {
    if (governorate is! Governorate) return;

    emit(state.copyWith(result: governorate));
  }
}
