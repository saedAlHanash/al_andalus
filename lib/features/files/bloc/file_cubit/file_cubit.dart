import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:m_cubit/abstraction.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../data/response/file_response.dart';

part 'file_state.dart';

class FileCubit extends MCubit<FileInitial> {
  FileCubit() : super(FileInitial.initial());

  @override
  get mState => state;

  @override
  String get nameCache => 'file';

  @override
  String get filter => state.filter;

  @override
  int get timeInterval => 1.max;

  void getDataFromCache() => getFromCache(
    fromJson: FileResponse.fromJson,
    state: state,
    onSuccess: (data) {
      emit(state.copyWith(result: data));
    },
  );

  Future<void> getData({bool newData = false, String? fileId}) async {
    if (fileId.isBlank) return;
    emit(state.copyWith(id: fileId));

    await getDataAbstract(
      fromJson: FileResponse.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<FileResponse?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: 'GetUrl.fileMedia',
      query: {'MediaId': state.id},
    );

    if (response.statusCode.success) {
      return Pair(FileResponse.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }

  void setFile(FileResponse file) {
    emit(state.copyWith(result: file));
  }
}
