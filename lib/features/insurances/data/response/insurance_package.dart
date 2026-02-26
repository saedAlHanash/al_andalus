import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/widgets/spinner_widget.dart';
import 'package:collection/collection.dart';

class InsurancesResponse {
  InsurancesResponse({required this.data});

  final List<InsurancePackage> data;

  factory InsurancesResponse.fromJson(Map<String, dynamic> json) {
    return InsurancesResponse(
      data: json["data"] == null
          ? []
          : List<InsurancePackage>.from(json["data"]!.map((x) => InsurancePackage.fromJson(x))),
    );
  }
}

class InsurancePackage {
  InsurancePackage({
    required this.id,
    required this.title,
    required this.brief,
    required this.type,
    required this.level,
    required this.tag,
    required this.descriptionFile,
    required this.features,
    required this.cylinders,
    required this.created,
  });

  final int? id;
  final String title;
  final String brief;
  final InsuranceTypeEnum type;
  final InsuranceLevelEnum level;
  final String tag;
  final String descriptionFile;
  final List<Feature> features;
  final List<Cylinder> cylinders;
  final String created;

  factory InsurancePackage.fromJson(Map<String, dynamic> json) {
    return InsurancePackage(
      id: int.tryParse(json["id"].toString()) ?? 0,
      title: json["title"] ?? "",
      brief: json["brief"] ?? "",
      type: InsuranceTypeEnum.getByNameOrIndex(json["type"]),
      level: InsuranceLevelEnum.getByNameOrIndex(json["level"]),
      tag: json["tag"]?.toString() ?? "",
      descriptionFile: json["description_file"] ?? "",
      features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
      cylinders: json["cylinders"] == null
          ? []
          : List<Cylinder>.from(json["cylinders"]!.map((x) => Cylinder.fromJson(x))),
      created: json["created"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "brief": brief,
    "type": type.index,
    "level": level.index,
    "tag": tag,
    "description_file": descriptionFile,
    "features": features.map((x) => x.toJson()).toList(),
    "cylinders": cylinders.map((x) => x.toJson()).toList(),
    "created": created,
  };

  List<SpinnerItem> get getCylinders {
    return cylinders
        .mapIndexed((i, e) => SpinnerItem(id: e.id, item: e, name: e.cylinders, isSelected: i == 0))
        .toList();
  }
}

class Cylinder {
  Cylinder({
    required this.id,
    required this.cylinders,
    required this.pricingType,
    required this.value,
    required this.created,
  });

  final int id;
  final String cylinders;
  final PricingTypeEnum pricingType;
  final double value;
  final String created;

  factory Cylinder.fromJson(Map<String, dynamic> json) {
    return Cylinder(
      id: int.tryParse(json["id"].toString()) ?? 0,
      cylinders: json["cylinders"]?.toString() ?? "",
      pricingType: PricingTypeEnum.getByNameOrIndex(json["pricing_type"] ?? "fixed"),
      value: double.tryParse(json["value"].toString()) ?? 0.0,
      created: json["created"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "cylinders": cylinders,
    "pricing_type": pricingType.name,
    "value": value,
    "created": created,
  };
}

class Feature {
  Feature({
    required this.id,
    required this.title,
    required this.created,
  });

  final int id;
  final String title;
  final String created;

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: int.tryParse(json["id"].toString()) ?? 0,
      title: json["title"] ?? "",
      created: json["created"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "created": created,
  };
}
