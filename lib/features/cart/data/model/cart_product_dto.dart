import 'package:al_andalus/features/product/data/response/product_response.dart';

class CartProductDto {
  CartProductDto({
    required this.id,
    required this.product,
  });

  final String id;
  final Product product;

  factory CartProductDto.fromJson(Map<String, dynamic> json) {
    json["product"]?['color'] = (json["id"] ?? '').toString().split('-').lastOrNull ?? '';
    return CartProductDto(
      id: json["id"] ?? '',
      product: Product.fromJson(json["product"] ?? {}),
    );
  }

  factory CartProductDto.fromProduct(Product p) {
    return CartProductDto(
      id: p.cartId,
      product: p,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product.toJson(),
  };
}
