import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/api_manager/api_url.dart';
import 'package:al_andalus/core/error/error_manager.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/pair_class.dart';
import 'package:al_andalus/features/order/data/response/order_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_cubit/abstraction.dart';

import '../../../../core/app/app_widget.dart';
import '../../../../core/helper/launcher_helper.dart';
import '../orders_cubit/orders_cubit.dart';

part 'order_state.dart';

class OrderCubit extends MCubit<OrderInitial> {
  OrderCubit() : super(OrderInitial.initial());

  @override
  AbstractState get mState => state;

  @override
  String get nameCache => 'order';

  @override
  String get filter => state.id.toString();

  Future<void> getData({bool newData = false, String? orderId}) async {
    emit(state.copyWith(id: orderId));

    await getDataAbstract(
      fromJson: Order.fromJson,
      state: state,
      getDataApi: _getData,
      newData: newData,
    );
  }

  Future<void> payOrder() async {
    emit(state.copyWith(statuses: CubitStatuses.loading));

    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.getPaymentUrl,
      path: state.id.toString(),
    );

    if (response.statusCode.success) {
      final m = PayOrderResponse.fromJson(response.jsonBody);

      LauncherHelper.openPage(m.paymentUrl).then(
        (value) {
          getData(newData: true);
          ctx?.read<OrdersCubit>().getData(newData: true);
        },
      );
    } else {
      emit(state.copyWith(error: ErrorManager.getApiError(response), statuses: CubitStatuses.error));
      showErrorFromApi(state);
    }
  }

  Future<Pair<Order?, String?>> _getData() async {
    final response = await APIService().callApi(
      type: ApiType.get,
      url: GetUrl.order,
      path: state.id.toString(),
    );

    if (response.statusCode.success) {
      return Pair(Order.fromJson(response.jsonBodyData), null);
    } else {
      return response.getPairError;
    }
  }

  void setOrder(dynamic order) {
    if (order is! Order) return;

    emit(state.copyWith(result: order));
  }
}
