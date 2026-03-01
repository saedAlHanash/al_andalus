import '../../../../core/strings/enum_manager.dart';
import '../../../insurances/data/response/insurance_package.dart';

class CarPolicies {
  CarPolicies({
    required this.data,
  });

  final List<CarPolicy> data;

  factory CarPolicies.fromJson(Map<String, dynamic> json) {
    return CarPolicies(
      data: json["data"] == null ? [] : List<CarPolicy>.from(json["data"]!.map((x) => CarPolicy.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class CarPolicy {
  CarPolicy({
    required this.id,
    required this.hasTransferRequest,
    required this.insurancePackage,
    required this.status,
    required this.qrcode,
    required this.annualSubscriptionPrice,
    required this.startDate,
    required this.endDate,
    required this.vehicle,
    required this.policyFile,
    required this.fieldsToBeRefilled,
    required this.created,
  });

  final int id;
  final bool hasTransferRequest;
  final InsurancePackage insurancePackage;
  final InsurancePolicyStatus status;
  final String qrcode;
  final num annualSubscriptionPrice;
  final String startDate;
  final String endDate;
  final Vehicle vehicle;
  final String policyFile;
  final dynamic fieldsToBeRefilled;
  final String created;

  factory CarPolicy.fromJson(Map<String, dynamic> json) {
    return CarPolicy(
      id: json["id"] ?? 0,
      hasTransferRequest: json["has_transfer_request"] ?? false,
      insurancePackage: InsurancePackage.fromJson(json["insurance_package"] ?? {}),
      status: InsurancePolicyStatus.getByNameOrIndex(json["status"]),
      qrcode: json["qrcode"] ?? "",
      annualSubscriptionPrice: json["annual_subscription_price"] ?? 0,
      startDate: json["start_date"] ?? "",
      endDate: json["end_date"] ?? "",
      vehicle: Vehicle.fromJson(json["vehicle"] ?? {}),
      policyFile: json["policy_file"] ?? "",
      fieldsToBeRefilled: json["fields_to_be_refilled"],
      created: json["created"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "has_transfer_request": hasTransferRequest,
    "insurance_package": insurancePackage.toJson(),
    "status": status.index,
    "qrcode": qrcode,
    "annual_subscription_price": annualSubscriptionPrice,
    "start_date": startDate,
    "end_date": endDate,
    "vehicle": vehicle.toJson(),
    "policy_file": policyFile,
    "fields_to_be_refilled": fieldsToBeRefilled,
    "created": created,
  };
}

class Vehicle {
  Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.cylinders,
    required this.manufactureYear,
    required this.color,
    required this.chassisNumber,
    required this.plateNumber,
    required this.fuelType,
    required this.engineCapacity,
    required this.value,
    required this.expiryStartDate,
    required this.expiryEndDate,
    required this.ownershipFrontImage,
    required this.ownershipBackImage,
    required this.inspectionReport,
    required this.inspection,
    required this.attachment,
    required this.created,
  });

  final int id;
  final String name;
  final String brand;
  final String cylinders;
  final String manufactureYear;
  final String color;
  final String chassisNumber;
  final String plateNumber;
  final FuelType fuelType;
  final num engineCapacity;
  final num value;
  final String expiryStartDate;
  final String expiryEndDate;
  final String ownershipFrontImage;
  final String ownershipBackImage;
  final String inspectionReport;
  final Inspection? inspection;
  final Attachment? attachment;
  final String created;

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      brand: json["brand"] ?? "",
      cylinders: json["cylinders"] ?? "",
      manufactureYear: json["manufacture_year"] ?? "",
      color: json["color"] ?? "",
      chassisNumber: json["chassis_number"] ?? "",
      plateNumber: json["plate_number"] ?? "",
      fuelType: FuelType.getByNameOrIndex(json["fuel_type"] ?? ""),
      engineCapacity: json["engine_capacity"] ?? 0,
      value: json["value"] ?? 0,
      expiryStartDate: json["expiry_start_date"] ?? "",
      expiryEndDate: json["expiry_end_date"] ?? "",
      ownershipFrontImage: json["ownership_front_image"] ?? "",
      ownershipBackImage: json["ownership_back_image"] ?? "",
      inspectionReport: json["inspection_report"] ?? "",
      inspection: json["inspection"] == null ? null : Inspection.fromJson(json["inspection"]),
      attachment: json["attachment"] == null ? null : Attachment.fromJson(json["attachment"]),
      created: json["created"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "brand": brand,
    "cylinders": cylinders,
    "manufacture_year": manufactureYear,
    "color": color,
    "chassis_number": chassisNumber,
    "plate_number": plateNumber,
    "fuel_type": fuelType.index,
    "engine_capacity": engineCapacity,
    "value": value,
    "expiry_start_date": expiryStartDate,
    "expiry_end_date": expiryEndDate,
    "ownership_front_image": ownershipFrontImage,
    "ownership_back_image": ownershipBackImage,
    "inspection_report": inspectionReport,
    "inspection": inspection?.toJson(),
    "attachment": attachment?.toJson(),
    "created": created,
  };
}

class Attachment {
  Attachment({
    required this.id,
    required this.frontImage,
    required this.rightSideImage,
    required this.leftSideImage,
    required this.interiorImage,
    required this.backImage,
    required this.engineImage,
    required this.created,
  });

  final int id;
  final String frontImage;
  final String rightSideImage;
  final String leftSideImage;
  final String interiorImage;
  final String backImage;
  final String engineImage;
  final String created;

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json["id"] ?? 0,
      frontImage: json["front_image"] ?? "",
      rightSideImage: json["right_side_image"] ?? "",
      leftSideImage: json["left_side_image"] ?? "",
      interiorImage: json["interior_image"] ?? "",
      backImage: json["back_image"] ?? "",
      engineImage: json["engine_image"] ?? "",
      created: json["created"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "front_image": frontImage,
    "right_side_image": rightSideImage,
    "left_side_image": leftSideImage,
    "interior_image": interiorImage,
    "back_image": backImage,
    "engine_image": engineImage,
    "created": created,
  };
}

class Inspection {
  Inspection({
    required this.id,
    required this.metalBody,
    required this.metalBodyNote,
    required this.glassAndLamps,
    required this.glassAndLampsNote,
    required this.chromeNickel,
    required this.chromeNickelNote,
    required this.brandSign,
    required this.brandSignNote,
    required this.windshieldWipers,
    required this.windshieldWipersNote,
    required this.radioAntenna,
    required this.radioAntennaNote,
    required this.seats,
    required this.seatsNote,
    required this.floorCover,
    required this.floorCoverNote,
    required this.radio,
    required this.radioNote,
    required this.airConditioner,
    required this.airConditionerNote,
    required this.frontTires,
    required this.frontTiresNote,
    required this.backTires,
    required this.backTiresNote,
    required this.spareTire,
    required this.spareTireNote,
    required this.tiresCovers,
    required this.tiresCoversNote,
    required this.spareTools,
    required this.spareToolsNote,
    required this.otherNotes,
    required this.created,
  });

  final int id;
  final String metalBody;
  final String metalBodyNote;
  final String glassAndLamps;
  final String glassAndLampsNote;
  final String chromeNickel;
  final String chromeNickelNote;
  final String brandSign;
  final String brandSignNote;
  final String windshieldWipers;
  final String windshieldWipersNote;
  final String radioAntenna;
  final String radioAntennaNote;
  final String seats;
  final String seatsNote;
  final String floorCover;
  final String floorCoverNote;
  final String radio;
  final String radioNote;
  final String airConditioner;
  final String airConditionerNote;
  final String frontTires;
  final String frontTiresNote;
  final String backTires;
  final String backTiresNote;
  final String spareTire;
  final String spareTireNote;
  final String tiresCovers;
  final String tiresCoversNote;
  final String spareTools;
  final String spareToolsNote;
  final String otherNotes;
  final String created;

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      id: json["id"] ?? 0,
      metalBody: json["metal_body"] ?? "",
      metalBodyNote: json["metal_body_note"] ?? "",
      glassAndLamps: json["glass_and_lamps"] ?? "",
      glassAndLampsNote: json["glass_and_lamps_note"] ?? "",
      chromeNickel: json["chrome_nickel"] ?? "",
      chromeNickelNote: json["chrome_nickel_note"] ?? "",
      brandSign: json["brand_sign"] ?? "",
      brandSignNote: json["brand_sign_note"] ?? "",
      windshieldWipers: json["windshield_wipers"] ?? "",
      windshieldWipersNote: json["windshield_wipers_note"] ?? "",
      radioAntenna: json["radio_antenna"] ?? "",
      radioAntennaNote: json["radio_antenna_note"] ?? "",
      seats: json["seats"] ?? "",
      seatsNote: json["seats_note"] ?? "",
      floorCover: json["floor_cover"] ?? "",
      floorCoverNote: json["floor_cover_note"] ?? "",
      radio: json["radio"] ?? "",
      radioNote: json["radio_note"] ?? "",
      airConditioner: json["air_conditioner"] ?? "",
      airConditionerNote: json["air_conditioner_note"] ?? "",
      frontTires: json["front_tires"] ?? "",
      frontTiresNote: json["front_tires_note"] ?? "",
      backTires: json["back_tires"] ?? "",
      backTiresNote: json["back_tires_note"] ?? "",
      spareTire: json["spare_tire"] ?? "",
      spareTireNote: json["spare_tire_note"] ?? "",
      tiresCovers: json["tires_covers"] ?? "",
      tiresCoversNote: json["tires_covers_note"] ?? "",
      spareTools: json["spare_tools"] ?? "",
      spareToolsNote: json["spare_tools_note"] ?? "",
      otherNotes: json["other_notes"] ?? "",
      created: json["created"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "metal_body": metalBody,
    "metal_body_note": metalBodyNote,
    "glass_and_lamps": glassAndLamps,
    "glass_and_lamps_note": glassAndLampsNote,
    "chrome_nickel": chromeNickel,
    "chrome_nickel_note": chromeNickelNote,
    "brand_sign": brandSign,
    "brand_sign_note": brandSignNote,
    "windshield_wipers": windshieldWipers,
    "windshield_wipers_note": windshieldWipersNote,
    "radio_antenna": radioAntenna,
    "radio_antenna_note": radioAntennaNote,
    "seats": seats,
    "seats_note": seatsNote,
    "floor_cover": floorCover,
    "floor_cover_note": floorCoverNote,
    "radio": radio,
    "radio_note": radioNote,
    "air_conditioner": airConditioner,
    "air_conditioner_note": airConditionerNote,
    "front_tires": frontTires,
    "front_tires_note": frontTiresNote,
    "back_tires": backTires,
    "back_tires_note": backTiresNote,
    "spare_tire": spareTire,
    "spare_tire_note": spareTireNote,
    "tires_covers": tiresCovers,
    "tires_covers_note": tiresCoversNote,
    "spare_tools": spareTools,
    "spare_tools_note": spareToolsNote,
    "other_notes": otherNotes,
    "created": created,
  };
}
