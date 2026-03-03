import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:http/http.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/error/error_manager.dart';
import '../../data/request/accident_request.dart';
import '../../data/response/accident_response.dart';

part 'accidents_state.dart';

class AccidentsCubit extends MCubit<AccidentsInitial> {
  AccidentsCubit() : super(AccidentsInitial.initial());

  @override
  String get nameCache => 'my_accidents';

  @override
  AbstractState get mState => state;

  Future<void> create() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, cubitCrud: CubitCrud.create));

    final response = await APIService().uploadMultiPart(
      url: PostUrl.claim,
      files: state.mRequest.files,
      fields: state.mRequest.toJson(),
    );

    _createResult(response);
  }

  Future<void> _createResult(Response response) async {
    if (response.statusCode.success) {
      emit(state.copyWith(statuses: CubitStatuses.done));
    } else {
      emit(state.copyWith(statuses: CubitStatuses.error, error: response.getPairError.second));
      showErrorFromApi(state);
    }
  }

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
      case ImageZone.rear: // We map rear to backImage
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
      case ImageZone.engine:
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
      case ImageZone.rear:
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
      case ImageZone.engine:
        state.mRequest.engineImage = UploadFile();
        break;
    }

    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }

  void forceUpdateState() {
    emit(state.copyWith(idNotifier: state.idNotifier + 1));
  }
}

enum ImageZone {
  front,
  rear,
  right,
  left,
  interior,
  engine,
}
