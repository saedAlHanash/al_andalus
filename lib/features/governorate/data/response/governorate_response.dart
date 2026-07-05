import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';

class Governorates {
  Governorates({
    required this.data,
  });

  final List<Governorate> data;

  factory Governorates.fromJson(Map<String, dynamic> json) {
    return Governorates(
      data: json["data"] == null ? [] : List<Governorate>.from(json["data"]!.map((x) => Governorate.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class Governorate {
  Governorate({
    required this.id,
    required this.name,
    required this.deliveryPrice,
    required this.iraqGovernorate,
  });

  final int id;
  final String name;
  final num deliveryPrice;
  final IraqGovernorate iraqGovernorate;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "delivery_price": deliveryPrice,
    };
  }

  factory Governorate.fromJson(Map<String, dynamic> json) {
    return Governorate(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      deliveryPrice: (json["delivery_price"] ?? "0").toString().tryParseOrZero,
      iraqGovernorate: IraqGovernorate.getByApproximateName(json["name"] ?? ""),
    );
  }
}

class City {
  final int id;
  final String name;
  final Governorate governorate;

  City({required this.id, required this.name, required this.governorate});

  City copyWith({int? id, String? name, Governorate? governorate}) {
    return City(
      id: id ?? this.id,
      name: name ?? this.name,
      governorate: governorate ?? this.governorate,
    );
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
      governorate: Governorate.fromJson(json['governorate'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "governorate": governorate.toJson(),
  };
}