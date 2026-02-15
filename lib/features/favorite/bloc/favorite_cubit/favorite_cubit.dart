import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:al_andalus/features/favorite/data/response/favorite_response.dart';
import 'package:m_cubit/abstraction.dart';

part 'favorite_state.dart';

class FavoriteCubit extends MCubit<FavoriteInitial> {
  FavoriteCubit() : super(FavoriteInitial.initial());

  @override
  AbstractState get mState => state;

  @override
  String get nameCache => 'favorite';

  @override
  String get filter => state.filter;

  Future<void> getData({bool newData = false, String? favoriteId}) async {
    emit(state.copyWith(request: favoriteId));

    await getDataAbstract(
      fromJson: Favorite.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<Favorite?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.favorite,
      query: {'Id': state.request},
    );

    if (response.statusCode.success) {
      return Pair(Favorite.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }

  void setFavorite(dynamic favorite) {
    if (favorite is! Favorite) return;

    emit(state.copyWith(result: favorite));
  }
}
