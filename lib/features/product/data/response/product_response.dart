import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../category/data/response/category_response.dart';

class Products {
  Products({required this.data});

  final List<Product> data;

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      data: json["data"] == null ? [] : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x))),
    );
  }

  factory Products.fromJsonFav(Map<String, dynamic> json) {
    return Products(
      data: json["data"] == null
          ? []
          : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x['product'] ?? {}))),
    );
  }

  Map<String, dynamic> toJson() => {"data": data.map((x) => x.toJson()).toList()};
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.description,
    required this.price,
    required this.pa,
    required this.isOffer,
    required this.isFavorite,
    required this.offerName,
    required this.image,
    required this.category,
    required this.colors,
    required this.suggestedProducts,
    required this.count,
  });

  num get priceAfter => pa > 0 ? pa : price;
  final int id;
  final String name;
  final num quantity;
  final String description;
  final num price;
  final num pa;
  final bool isOffer;
  bool isFavorite;
  final String offerName;
  final List<String> image;
  final Category category;
  final List<ProductColor> colors;

  int count = 1;
  String colorId = '';
  final List<Product> suggestedProducts;

  String get cartId => '$id-$colorId';

  Widget get priceWidgetH => Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      DrawableText(text: priceAfter.formatPrice, color: AppColorManager.black, fontFamily: FontManager.bold.name),
      5.0.horizontalSpace,
      if ((price != priceAfter))
        DrawableText(
          text: price.formatPrice,
          size: 12.0.sp,
          textDecoration: TextDecoration.lineThrough,
          color: AppColorManager.lightGrayAb,
        ),
    ],
  );

  Widget get priceWidgetH1 => Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      if ((price != priceAfter))
        DrawableText(
          text: price.formatPrice,
          textDecoration: TextDecoration.lineThrough,
          color: AppColorManager.grey,
          size: 18.0.sp,
        ),
      5.0.horizontalSpace,
      DrawableText(
        text: priceAfter.formatPrice,
        fontFamily: FontManager.bold.name,
        color: AppColorManager.mainColor,
        fontWeight: FontWeight.bold,
        size: 18.0.sp,
      ),
    ],
  );

  factory Product.fromJson(Map<String, dynamic> json) {
    var p = Product(
      id: json["id"] ?? 0,
      count: json["count"] ?? 1,
      name: json["name"] ?? "",
      quantity: json["quantity"] ?? 0,
      description: json["description"] ?? "",
      price: json["price"] ?? 0,
      pa: json["price_after"] ?? 0,
      isOffer: json["is_offer"] ?? false,
      isFavorite: json["isFavorite"] ?? false,
      offerName: json["offer_name"] ?? "",
      image: (json["image"] ?? json["images"]) == null
          ? []
          : ((json["image"] ?? json["images"]) is String)
          ? [(json["image"] ?? json["images"]).toString()]
          : (json['image'] is Map)
          ? [json['image']?['image_url'] ?? '']
          : List<String>.from(
              (json["image"] ?? json["images"])!.map((x) => (x is Map) ? (x['image_url'] ?? '') : x.toString()),
            ),
      colors: json["colors"] == null
          ? []
          : List<ProductColor>.from(json["colors"]!.map((x) => ProductColor.fromJson(x))),
      category: Category.fromJson(json["category"] ?? {}),
      suggestedProducts: json["suggested_products"] == null
          ? []
          : List<Product>.from(json["suggested_products"]!.map((x) => Product.fromJson(x))),
    );

    if (json["color"].toString().isBlank) {
      p.colorId = (p.colors.firstOrNull ?? ProductColor.fromJson({})).id.toString();
    } else {
      p.colorId = json["color"].toString();
    }
    return p;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "count": count,
    "quantity": quantity,
    "description": description,
    "price": price,
    "price_after": pa,
    "is_offer": isOffer,
    "isFavorite": isFavorite,
    "offer_name": offerName,
    "image": image.map((x) => x).toList(),
    "colors": colors.map((x) => x.toJson()).toList(),
    "category": category.toJson(),
    "suggested_products": suggestedProducts.map((x) => x.toJson()).toList(),
  };
}

class ProductColor {
  ProductColor({
    required this.id,
    required this.name,
    required this.hex,
  });

  final int id;
  final String name;
  final String hex;

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      hex: json["hex"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "hex": hex,
  };
}
