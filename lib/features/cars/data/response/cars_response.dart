import 'package:al_andalus/core/strings/enum_manager.dart';

import 'package:al_andalus/features/insurances/data/response/insurance_package.dart';

class CarsResponse {
  final List<CarPolicy> data;

  CarsResponse({required this.data});

  factory CarsResponse.fromJson(Map<String, dynamic> json) {
    return CarsResponse(
      data: json["data"] == null ? [] : List<CarPolicy>.from(json["data"]!.map((x) => CarPolicy.fromJson(x))),
    );
  }
}

class CarPolicy {
  final int id;
  final bool hasTransferRequest;
  final InsurancePackage insurancePackage;
  final String status;
  final String qrcode;
  final double annualSubscriptionPrice;
  final String startDate;
  final String endDate;
  final Vehicle vehicle;
  final String policyFile;
  final List<String> fieldsToBeRefilled;
  final String created;

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

  factory CarPolicy.fromJson(Map<String, dynamic> json) {
    return CarPolicy(
      id: int.tryParse(json["id"].toString()) ?? 0,
      hasTransferRequest: json["has_transfer_request"] ?? false,
      insurancePackage: InsurancePackage.fromJson(json["insurance_package"] ?? {}),
      status: json["status"] ?? "",
      qrcode: json["qrcode"] ?? "",
      annualSubscriptionPrice: double.tryParse(json["annual_subscription_price"].toString()) ?? 0.0,
      startDate: json["start_date"] ?? "",
      endDate: json["end_date"] ?? "",
      vehicle: Vehicle.fromJson(json["vehicle"] ?? {}),
      policyFile: json["policy_file"] ?? "",
      fieldsToBeRefilled: json["fields_to_be_refilled"] == null
          ? []
          : List<String>.from(json["fields_to_be_refilled"]!.map((x) => x.toString())),
      created: json["created"] ?? "",
    );
  }
}

class Vehicle {
  final int id;
  final String name;
  final String brand;
  final String cylinders;
  final String manufactureYear;
  final String color;
  final String chassisNumber;
  final String plateNumber;
  final FuelType fuelType;
  final int engineCapacity;
  final double value;
  final String expiryStartDate;
  final String expiryEndDate;
  final String ownershipFrontImage;
  final String ownershipBackImage;
  final String inspectionReport;
  final Inspection inspection;
  final Attachment attachment;
  final String created;

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

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: int.tryParse(json["id"].toString()) ?? 0,
      name: json["name"] ?? "",
      brand: json["brand"] ?? "",
      cylinders: json["cylinders"]?.toString() ?? "",
      manufactureYear: json["manufacture_year"]?.toString() ?? "",
      color: json["color"] ?? "",
      chassisNumber: json["chassis_number"] ?? "",
      plateNumber: json["plate_number"] ?? "",
      fuelType: FuelType.getByNameOrIndex(json["fuel_type"]),
      engineCapacity: int.tryParse(json["engine_capacity"].toString()) ?? 0,
      value: double.tryParse(json["value"].toString()) ?? 0.0,
      expiryStartDate: json["expiry_start_date"] ?? "",
      expiryEndDate: json["expiry_end_date"] ?? "",
      ownershipFrontImage: json["ownership_front_image"] ?? "",
      ownershipBackImage: json["ownership_back_image"] ?? "",
      inspectionReport: json["inspection_report"] ?? "",
      inspection: Inspection.fromJson(json["inspection"] ?? {}),
      attachment: Attachment.fromJson(json["attachment"] ?? {}),
      created: json["created"] ?? "",
    );
  }
}

class Inspection {
  final int id;
  final InspectionStatus metalBody;
  final String metalBodyNote;
  final InspectionStatus glassAndLamps;
  final String glassAndLampsNote;
  final InspectionStatus chromeNickel;
  final String chromeNickelNote;
  final InspectionStatus brandSign;
  final String brandSignNote;
  final InspectionStatus windshieldWipers;
  final String windshieldWipersNote;
  final InspectionStatus radioAntenna;
  final String radioAntennaNote;
  final InspectionStatus seats;
  final String seatsNote;
  final InspectionStatus floorCover;
  final String floorCoverNote;
  final InspectionStatus radio;
  final String radioNote;
  final InspectionStatus airConditioner;
  final String airConditionerNote;
  final InspectionStatus frontTires;
  final String frontTiresNote;
  final InspectionStatus backTires;
  final String backTiresNote;
  final InspectionStatus spareTire;
  final String spareTireNote;
  final InspectionStatus tiresCovers;
  final String tiresCoversNote;
  final InspectionStatus spareTools;
  final String spareToolsNote;
  final String otherNotes;
  final String created;

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

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      id: int.tryParse(json["id"].toString()) ?? 0,
      metalBody: InspectionStatus.getByNameOrIndex(json["metal_body"]),
      metalBodyNote: json["metal_body_note"] ?? "",
      glassAndLamps: InspectionStatus.getByNameOrIndex(json["glass_and_lamps"]),
      glassAndLampsNote: json["glass_and_lamps_note"] ?? "",
      chromeNickel: InspectionStatus.getByNameOrIndex(json["chrome_nickel"]),
      chromeNickelNote: json["chrome_nickel_note"] ?? "",
      brandSign: InspectionStatus.getByNameOrIndex(json["brand_sign"]),
      brandSignNote: json["brand_sign_note"] ?? "",
      windshieldWipers: InspectionStatus.getByNameOrIndex(json["windshield_wipers"]),
      windshieldWipersNote: json["windshield_wipers_note"] ?? "",
      radioAntenna: InspectionStatus.getByNameOrIndex(json["radio_antenna"]),
      radioAntennaNote: json["radio_antenna_note"] ?? "",
      seats: InspectionStatus.getByNameOrIndex(json["seats"]),
      seatsNote: json["seats_note"] ?? "",
      floorCover: InspectionStatus.getByNameOrIndex(json["floor_cover"]),
      floorCoverNote: json["floor_cover_note"] ?? "",
      radio: InspectionStatus.getByNameOrIndex(json["radio"]),
      radioNote: json["radio_note"] ?? "",
      airConditioner: InspectionStatus.getByNameOrIndex(json["air_conditioner"]),
      airConditionerNote: json["air_conditioner_note"] ?? "",
      frontTires: InspectionStatus.getByNameOrIndex(json["front_tires"]),
      frontTiresNote: json["front_tires_note"] ?? "",
      backTires: InspectionStatus.getByNameOrIndex(json["back_tires"]),
      backTiresNote: json["back_tires_note"] ?? "",
      spareTire: InspectionStatus.getByNameOrIndex(json["spare_tire"]),
      spareTireNote: json["spare_tire_note"] ?? "",
      tiresCovers: InspectionStatus.getByNameOrIndex(json["tires_covers"]),
      tiresCoversNote: json["tires_covers_note"] ?? "",
      spareTools: InspectionStatus.getByNameOrIndex(json["spare_tools"]),
      spareToolsNote: json["spare_tools_note"] ?? "",
      otherNotes: json["other_notes"] ?? "",
      created: json["created"] ?? "",
    );
  }
}

class Attachment {
  final int id;
  final String frontImage;
  final String rightSideImage;
  final String leftSideImage;
  final String interiorImage;
  final String backImage;
  final String engineImage;
  final String created;

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

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: int.tryParse(json["id"].toString()) ?? 0,
      frontImage: json["front_image"] ?? "",
      rightSideImage: json["right_side_image"] ?? "",
      leftSideImage: json["left_side_image"] ?? "",
      interiorImage: json["interior_image"] ?? "",
      backImage: json["back_image"] ?? "",
      engineImage: json["engine_image"] ?? "",
      created: json["created"] ?? "",
    );
  }
}
