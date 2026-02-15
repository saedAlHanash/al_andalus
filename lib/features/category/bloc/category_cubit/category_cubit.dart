import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:al_andalus/features/category/data/response/category_response.dart';
import 'package:m_cubit/abstraction.dart';

part 'category_state.dart';

class CategoryCubit extends MCubit<CategoryInitial> {
  CategoryCubit() : super(CategoryInitial.initial());

  @override
  AbstractState get mState => state;

  @override
  String get nameCache => 'category';

  @override
  String get filter => state.filter;

  Future<void> getData({bool newData = false, String? categoryId}) async {
    emit(state.copyWith(request: categoryId));

    await getDataAbstract(
      fromJson: Category.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<Category?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.category,
      query: {'Id': state.request},
    );

    if (response.statusCode.success) {
      return Pair(Category.fromJson(response.jsonBody), null);
    } else {
      return response.getPairError;
    }
  }

  void setCategory(dynamic category) {
    if (category is! Category) return;

    emit(state.copyWith(result: category));
  }
}
