import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/util/snack_bar_message.dart';
import '../../../address/data/response/address_response.dart';
import '../../../product/data/response/product_response.dart';
import '../../data/model/cart_product_dto.dart';
import '../../data/response/coupon_response.dart';

part 'cart_state.dart';

class CartCubit extends MCubit<CartInitial> {
  CartCubit() : super(CartInitial.initial());

  @override
  AbstractState get mState => state;

  @override
  String get nameCache => 'cart';

  //region getData

  Future<void> getDataFromCache() async => await getFromCache(
    fromJson: CartProductDto.fromJson,
    state: state,
    onSuccess: (data) {
      emit(state.copyWith(result: data));
    },
  );

  //endregion

  //region CRUD

  Future<bool> _addToCart(CartProductDto dto) async {
    final item = dto.product;
    await getDataFromCache();
    final products = state.result;
    final index = products.indexWhere((p) => p.id == item.cartId);

    if (index != -1) {
      final updated = products[index].product;
      final newCount = updated.count + item.count;

      if (newCount <= updated.quantity) {
        updated.count = newCount;
        updated.colorId = item.colorId;
        await addOrUpdateProductToCache(products[index]);
        return true;
      } else {
        loggerObject.w("لا يمكن إضافة أكثر من الكمية المتوفرة: ${updated.quantity}");
        return false;
      }
    } else {
      if (item.count <= item.quantity) {
        await addOrUpdateProductToCache(dto);
        return true;
      } else {
        loggerObject.w("لا يمكن إضافة أكثر من الكمية المتوفرة: ${item.quantity}");
        return false;
      }
    }
  }

  Future<void> addToCart(Product item, {required BuildContext context}) async {
    var r = await _addToCart(CartProductDto.fromProduct(item));
    if (!context.mounted) return;

    if (r) {
      NoteMessage.showTopMessage(context: context);
    } else {
      NoteMessage.showTopMessageError(context: context);
    }
  }

  Future<void> decrementQuantity(Product item) async {
    await getDataFromCache();
    final products = state.result;
    final index = products.indexWhere((p) => p.id == item.cartId);
    if (index != -1) {
      final updated = products[index].product;
      if (updated.count > 1) {
        updated.count -= 1;
        await addOrUpdateProductToCache(products[index]);
      } else {
        await deleteProductFromCache([updated.id.toString()]);
      }
    }
  }

  Future<bool> incrementQuantity(Product item, {required BuildContext context}) async {
    await getDataFromCache();
    final products = state.result;
    final index = products.indexWhere((p) => p.id == item.cartId);

    if (index != -1) {
      final updated = products[index].product;

      if (updated.count < updated.quantity) {
        updated.count += 1;
        await addOrUpdateProductToCache(products[index]);
        return true;
      } else {
        loggerObject.w("لا يمكن زيادة الكمية، الحد الأقصى هو ${updated.quantity}");
        return false;
      }
    } else {
      if (item.count <= item.quantity) {
        await addToCart(item, context: context);
        return true;
      } else {
        loggerObject.w("لا يمكن إضافة أكثر من الكمية المتاحة: ${item.quantity}");
        return false;
      }
    }
  }

  Future<void> removeFromCart(Product item) async {
    await deleteProductFromCache([item.cartId.toString()]);
  }

  //endregion

  void setCouponCode(String coupon) {
    emit(state.copyWith(request: coupon));
  }

  void setCoupon(CouponData coupon) {
    emit(state.copyWith(coupon: coupon));
  }

  void setAddress(Address address) {
    emit(state.copyWith(address: address));
  }

  @override
  Future<void> clearCash() async {
    await deleteProductFromCache(state.result.map((e) => e.id.toString()).toList());
  }

  Future<void> addOrUpdateProductToCache(CartProductDto item) async {
    final listJson = await addOrUpdateDate([item]);
    if (listJson == null) return;
    final list = listJson.map((e) => CartProductDto.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }

  Future<void> deleteProductFromCache(List<String> ids) async {
    final listJson = await deleteDate(ids);
    if (listJson == null) return;
    final list = listJson.map((e) => CartProductDto.fromJson(e)).toList();
    emit(state.copyWith(result: list));
  }
}
