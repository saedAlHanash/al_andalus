import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/pair_class.dart';
import '../../data/response/policy_response.dart';

part 'policy_state.dart';

class PolicyCubit extends MCubit<PolicyInitial> {
  PolicyCubit() : super(PolicyInitial.initial());

  @override
  AbstractState get mState => state;

  @override
  String get nameCache => state.mRequest.index.toString();

  Future<void> getData({bool newData = false, required DataPageType type}) async {
    emit(state.copyWith(request: type));

    await getDataAbstract(
      fromJson: Policy.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<Policy?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,

      url: switch (state.mRequest) {
        DataPageType.policy => GetUrl.policy,
        DataPageType.terms => GetUrl.termsAndConditions,
        DataPageType.aboutUs => GetUrl.aboutUs,
        DataPageType.ourService => GetUrl.ourService,
      },
    );

    if (response.statusCode.success) {
      final result = Policy.fromJson(response.jsonBody);
      result.id = state.mRequest.index.toString();
      return Pair(result, null);
    } else {
      return response.getPairError;
    }
  }

  void setPolicy(dynamic policy) {
    if (policy is! Policy) return;

    emit(state.copyWith(result: policy));
  }
}
