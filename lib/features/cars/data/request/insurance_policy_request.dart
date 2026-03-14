import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:al_andalus/features/cars/data/response/cars_response.dart';

import '../../../../generated/l10n.dart';
import 'insurance_policy_mock.dart';

class InsurancePolicyRequest {
  InsurancePolicyRequest({
    this.id,
    this.insurancePackageId,
    this.cylinders,
    this.name,
    this.manufactureYear,
    this.color,
    this.brand,
    this.value,
    this.chassisNumber,
    this.plateNumber,
    this.fuelType,
    this.engineCapacity,
    this.paymentType = PaymentType.zainCash,
    this.expiryStartDate,
    this.expiryEndDate,
    // Inspection fields
    this.metalBody /*= .intact*/,
    this.metalBodyNote,
    this.glassAndLamps /*= .intact*/,
    this.glassAndLampsNote,
    this.chromeNickel /*= .intact*/,
    this.chromeNickelNote,
    this.brandSign /*= .intact*/,
    this.brandSignNote,
    this.windshieldWipers /*= .intact*/,
    this.windshieldWipersNote,
    this.radioAntenna /*= .intact*/,
    this.radioAntennaNote,
    this.seats /*= .intact*/,
    this.seatsNote,
    this.floorCover /*= .intact*/,
    this.floorCoverNote,
    this.radio /*= .intact*/,
    this.radioNote,
    this.airConditioner /*= .intact*/,
    this.airConditionerNote,
    this.frontTires /*= .intact*/,
    this.frontTiresNote,
    this.backTires /*= .intact*/,
    this.backTiresNote,
    this.spareTire /*= .intact*/,
    this.spareTireNote,
    this.tiresCovers /*= .intact*/,
    this.tiresCoversNote,
    this.spareTools /*= .intact*/,
    this.spareToolsNote,
    this.otherNotes,
  }) {
    if (kDebugMode) fillMockData();
  }

  factory InsurancePolicyRequest.fromCarPolicy(CarPolicy car) {
    final vehicle = car.vehicle;
    final inspection = vehicle.inspection;
    final attachment = vehicle.attachment;

    final request = InsurancePolicyRequest(
      id: car.id,
      insurancePackageId: car.insurancePackage.id.toString(),
      cylinders: vehicle.cylinders,
      name: vehicle.name,
      manufactureYear: DateTime(int.parse(vehicle.manufactureYear)),
      color: vehicle.color,
      brand: vehicle.brand,
      value: vehicle.value.toString(),
      chassisNumber: vehicle.chassisNumber,
      plateNumber: vehicle.plateNumber,
      fuelType: vehicle.fuelType,
      engineCapacity: vehicle.engineCapacity.toString(),
      expiryStartDate: DateTime.tryParse(vehicle.expiryStartDate),
      expiryEndDate: DateTime.tryParse(vehicle.expiryEndDate),

      // Inspection
      metalBody: InspectionStatus.getByNameOrIndex(inspection.metalBody),
      metalBodyNote: inspection.metalBodyNote,
      glassAndLamps: InspectionStatus.getByNameOrIndex(inspection.glassAndLamps),
      glassAndLampsNote: inspection.glassAndLampsNote,
      chromeNickel: InspectionStatus.getByNameOrIndex(inspection.chromeNickel),
      chromeNickelNote: inspection.chromeNickelNote,
      brandSign: InspectionStatus.getByNameOrIndex(inspection.brandSign),
      brandSignNote: inspection.brandSignNote,
      windshieldWipers: InspectionStatus.getByNameOrIndex(inspection.windshieldWipers),
      windshieldWipersNote: inspection.windshieldWipersNote,
      radioAntenna: InspectionStatus.getByNameOrIndex(inspection.radioAntenna),
      radioAntennaNote: inspection.radioAntennaNote,
      seats: InspectionStatus.getByNameOrIndex(inspection.seats),
      seatsNote: inspection.seatsNote,
      floorCover: InspectionStatus.getByNameOrIndex(inspection.floorCover),
      floorCoverNote: inspection.floorCoverNote,
      radio: InspectionStatus.getByNameOrIndex(inspection.radio),
      radioNote: inspection.radioNote,
      airConditioner: InspectionStatus.getByNameOrIndex(inspection.airConditioner),
      airConditionerNote: inspection.airConditionerNote,
      frontTires: InspectionStatus.getByNameOrIndex(inspection.frontTires),
      frontTiresNote: inspection.frontTiresNote,
      backTires: InspectionStatus.getByNameOrIndex(inspection.backTires),
      backTiresNote: inspection.backTiresNote,
      spareTire: InspectionStatus.getByNameOrIndex(inspection.spareTire),
      spareTireNote: inspection.spareTireNote,
      tiresCovers: InspectionStatus.getByNameOrIndex(inspection.tiresCovers),
      tiresCoversNote: inspection.tiresCoversNote,
      spareTools: InspectionStatus.getByNameOrIndex(inspection.spareTools),
      spareToolsNote: inspection.spareToolsNote,
      otherNotes: inspection.otherNotes,
    );

    request.ownershipFrontImage
      ..remoteUrl = vehicle.ownershipFrontImage
      ..localId = S().uploadedFile;
    request.ownershipBackImage
      ..remoteUrl = vehicle.ownershipBackImage
      ..localId = S().uploadedFile;
    request.inspectionReport
      ..remoteUrl = vehicle.inspectionReport
      ..localId = S().uploadedFile;
    request.frontImage
      ..remoteUrl = attachment.frontImage
      ..localId = S().uploadedFile;
    request.backImage
      ..remoteUrl = attachment.backImage
      ..localId = S().uploadedFile;
    request.rightSideImage
      ..remoteUrl = attachment.rightSideImage
      ..localId = S().uploadedFile;
    request.leftSideImage
      ..remoteUrl = attachment.leftSideImage
      ..localId = S().uploadedFile;
    request.interiorImage
      ..remoteUrl = attachment.interiorImage
      ..localId = S().uploadedFile;
    request.engineImage
      ..remoteUrl = attachment.engineImage
      ..localId = S().uploadedFile;

    return request;
  }

  int? id;
  String? insurancePackageId;
  String? cylinders;
  String? name;
  DateTime? manufactureYear;
  String? color;
  String? brand;
  String? value;
  String? chassisNumber;
  String? plateNumber;
  FuelType? fuelType;
  String? engineCapacity;
  PaymentType? paymentType;
  DateTime? expiryStartDate;
  DateTime? expiryEndDate;

  // Inspection
  InspectionStatus? metalBody;
  String? metalBodyNote;
  InspectionStatus? glassAndLamps;
  String? glassAndLampsNote;
  InspectionStatus? chromeNickel;
  String? chromeNickelNote;
  InspectionStatus? brandSign;
  String? brandSignNote;
  InspectionStatus? windshieldWipers;
  String? windshieldWipersNote;
  InspectionStatus? radioAntenna;
  String? radioAntennaNote;
  InspectionStatus? seats;
  String? seatsNote;
  InspectionStatus? floorCover;
  String? floorCoverNote;
  InspectionStatus? radio;
  String? radioNote;
  InspectionStatus? airConditioner;
  String? airConditionerNote;
  InspectionStatus? frontTires;
  String? frontTiresNote;
  InspectionStatus? backTires;
  String? backTiresNote;
  InspectionStatus? spareTire;
  String? spareTireNote;
  InspectionStatus? tiresCovers;
  String? tiresCoversNote;
  InspectionStatus? spareTools;
  String? spareToolsNote;
  String? otherNotes;

  bool annualInfoCheck = false;
  bool carPreviewInfoCheck = false;

  // Files
  var ownershipFrontImage = UploadFile(nameField: 'ownership_front_image');
  var ownershipBackImage = UploadFile(nameField: 'ownership_back_image');
  var inspectionReport = UploadFile(nameField: 'inspection_report');

  // Attachments nested files
  var frontImage = UploadFile(nameField: 'attachments[front_image]');
  var backImage = UploadFile(nameField: 'attachments[back_image]');
  var rightSideImage = UploadFile(nameField: 'attachments[right_side_image]');
  var leftSideImage = UploadFile(nameField: 'attachments[left_side_image]');
  var interiorImage = UploadFile(nameField: 'attachments[interior_image]');
  var engineImage = UploadFile(nameField: 'attachments[engine_image]');

  List<UploadFile> get files {
    ownershipFrontImage.nameField = 'ownership_front_image';
    ownershipBackImage.nameField = 'ownership_back_image';
    inspectionReport.nameField = 'inspection_report';
    frontImage.nameField = 'attachments[front_image]';
    backImage.nameField = 'attachments[back_image]';
    rightSideImage.nameField = 'attachments[right_side_image]';
    leftSideImage.nameField = 'attachments[left_side_image]';
    interiorImage.nameField = 'attachments[interior_image]';
    engineImage.nameField = 'attachments[engine_image]';
    return [
      ownershipFrontImage,
      ownershipBackImage,
      inspectionReport,
      frontImage,
      backImage,
      rightSideImage,
      leftSideImage,
      interiorImage,
      engineImage,
    ];
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return date.toIso8601String().split('T').first;
  }

  Map<String, dynamic> toJson() => {
    'insurance_package_id': insurancePackageId,
    'cylinders': cylinders,
    'name': name,
    'manufacture_year': manufactureYear?.year,
    'color': color,
    'brand': brand,
    'value': value,
    'chassis_number': chassisNumber,
    'plate_number': plateNumber,
    'fuel_type': fuelType?.nameApi,
    'engine_capacity': engineCapacity,
    'payment_type': paymentType?.nameApi,
    'expiry_start_date': _formatDate(expiryStartDate),
    'expiry_end_date': _formatDate(expiryEndDate),

    // Inspection
    'inspection[metal_body]': metalBody?.nameApi,
    'inspection[metal_body_note]': metalBodyNote ?? '-',
    'inspection[glass_and_lamps]': glassAndLamps?.nameApi,
    'inspection[glass_and_lamps_note]': glassAndLampsNote ?? '-',
    'inspection[chrome_nickel]': chromeNickel?.nameApi,
    'inspection[chrome_nickel_note]': chromeNickelNote ?? '-',
    'inspection[brand_sign]': brandSign?.nameApi,
    'inspection[brand_sign_note]': brandSignNote ?? '-',
    'inspection[windshield_wipers]': windshieldWipers?.nameApi,
    'inspection[windshield_wipers_note]': windshieldWipersNote ?? '-',
    'inspection[radio_antenna]': radioAntenna?.nameApi,
    'inspection[radio_antenna_note]': radioAntennaNote ?? '-',
    'inspection[seats]': seats?.nameApi,
    'inspection[seats_note]': seatsNote ?? '-',
    'inspection[floor_cover]': floorCover?.nameApi,
    'inspection[floor_cover_note]': floorCoverNote ?? '-',
    'inspection[radio]': radio?.nameApi,
    'inspection[radio_note]': radioNote ?? '-',
    'inspection[air_conditioner]': airConditioner?.nameApi,
    'inspection[air_conditioner_note]': airConditionerNote ?? '-',
    'inspection[front_tires]': frontTires?.nameApi,
    'inspection[front_tires_note]': frontTiresNote ?? '-',
    'inspection[back_tires]': backTires?.nameApi,
    'inspection[back_tires_note]': backTiresNote ?? '-',
    'inspection[spare_tire]': spareTire?.nameApi,
    'inspection[spare_tire_note]': spareTireNote ?? '-',
    'inspection[tires_covers]': tiresCovers?.nameApi,
    'inspection[tires_covers_note]': tiresCoversNote ?? '-',
    'inspection[spare_tools]': spareTools?.nameApi,
    'inspection[spare_tools_note]': spareToolsNote ?? '-',
    'inspection[other_notes]': otherNotes,
  };

  void setTempImages(UploadFile file) {
    if (kDebugMode) fillMockImages(file);
  }
}
