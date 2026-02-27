import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';

class InsurancePolicyRequest {
  InsurancePolicyRequest({
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
  });

  int? insurancePackageId;
  String? cylinders;
  String? name;
  String? manufactureYear;
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

  List<UploadFile> get files => [
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

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return date.toIso8601String().split('T').first;
  }

  Map<String, dynamic> toJson() => {
    'insurance_package_id': insurancePackageId,
    'cylinders': cylinders,
    'name': name,
    'manufacture_year': manufactureYear,
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
    'inspection[metal_body_note]': metalBodyNote,
    'inspection[glass_and_lamps]': glassAndLamps?.nameApi,
    'inspection[glass_and_lamps_note]': glassAndLampsNote,
    'inspection[chrome_nickel]': chromeNickel?.nameApi,
    'inspection[chrome_nickel_note]': chromeNickelNote,
    'inspection[brand_sign]': brandSign?.nameApi,
    'inspection[brand_sign_note]': brandSignNote,
    'inspection[windshield_wipers]': windshieldWipers?.nameApi,
    'inspection[windshield_wipers_note]': windshieldWipersNote,
    'inspection[radio_antenna]': radioAntenna?.nameApi,
    'inspection[radio_antenna_note]': radioAntennaNote,
    'inspection[seats]': seats?.nameApi,
    'inspection[seats_note]': seatsNote,
    'inspection[floor_cover]': floorCover?.nameApi,
    'inspection[floor_cover_note]': floorCoverNote,
    'inspection[radio]': radio?.nameApi,
    'inspection[radio_note]': radioNote,
    'inspection[air_conditioner]': airConditioner?.nameApi,
    'inspection[air_conditioner_note]': airConditionerNote,
    'inspection[front_tires]': frontTires?.nameApi,
    'inspection[front_tires_note]': frontTiresNote,
    'inspection[back_tires]': backTires?.nameApi,
    'inspection[back_tires_note]': backTiresNote,
    'inspection[spare_tire]': spareTire?.nameApi,
    'inspection[spare_tire_note]': spareTireNote,
    'inspection[tires_covers]': tiresCovers?.nameApi,
    'inspection[tires_covers_note]': tiresCoversNote,
    'inspection[spare_tools]': spareTools?.nameApi,
    'inspection[spare_tools_note]': spareToolsNote,
    'inspection[other_notes]': otherNotes,
  };
}
