import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:al_andalus/features/product/data/response/product_response.dart';
import 'package:m_cubit/abstraction.dart';

part 'product_state.dart';

class ProductCubit extends MCubit<ProductInitial> {
  ProductCubit() : super(ProductInitial.initial());

  @override
  AbstractState get mState => state;

  @override
  String get nameCache => 'product';

  @override
  String get filter => state.filter;

  Future<void> getData({bool newData = false, String? productId}) async {
    emit(state.copyWith(request: productId));

    await getDataAbstract(
      fromJson: Product.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<Pair<Product?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.product,
      path: state.request.toString(),
    );

    if (response.statusCode.success) {
      final product = response.jsonBody['product'];
      final suggested = response.jsonBody['suggested_products'];
      final map = product..addAll({'suggested_products': suggested});
      final model = Product.fromJson(map);
      return Pair(model, null);
    } else {
      return response.getPairError;
    }
  }

  void setProduct(dynamic product) {
    if (product is! Product) return;

    emit(state.copyWith(result: product));
  }
}
