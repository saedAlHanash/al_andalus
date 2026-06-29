import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/strings/enum_manager.dart';
import 'insurance_policy_request.dart';

extension InsurancePolicyRequestMock on InsurancePolicyRequest {
  void fillMockData() {
    if (!kDebugMode) return;
    insurancePackageId = '1';
    cylinders = '4';
    name = 'سيارة تجريبية';
    manufactureYear = DateTime(2020);
    color = 'أبيض';
    brand = 'تويوتا';
    value = '15000';
    chassisNumber = '${Random().nextInt(1000000)}';
    plateNumber = '${Random().nextInt(1000000)}';
    fuelType = FuelType.petrol;
    engineCapacity = '2000';

    expiryStartDate = DateTime.now();
    expiryEndDate = DateTime.now().add(const Duration(days: 365));

    final random = Random();
    metalBody = _getRandomStatus(random);
    if (metalBody != InspectionStatus.intact) metalBodyNote = 'ملاحظة تجريبية للهيكل';

    glassAndLamps = _getRandomStatus(random);
    if (glassAndLamps != InspectionStatus.intact) glassAndLampsNote = 'ملاحظة تجريبية للزجاج والمصابيح';

    chromeNickel = _getRandomStatus(random);
    if (chromeNickel != InspectionStatus.intact) chromeNickelNote = 'ملاحظة تجريبية للكروم';

    brandSign = _getRandomStatus(random);
    if (brandSign != InspectionStatus.intact) brandSignNote = 'ملاحظة تجريبية لشعار السيارة';

    windshieldWipers = _getRandomStatus(random);
    if (windshieldWipers != InspectionStatus.intact) windshieldWipersNote = 'ملاحظة تجريبية للمساحات';

    radioAntenna = _getRandomStatus(random);
    if (radioAntenna != InspectionStatus.intact) radioAntennaNote = 'ملاحظة تجريبية للهوائي';

    seats = _getRandomStatus(random);
    if (seats != InspectionStatus.intact) seatsNote = 'ملاحظة تجريبية للمقاعد';

    floorCover = _getRandomStatus(random);
    if (floorCover != InspectionStatus.intact) floorCoverNote = 'ملاحظة تجريبية للأرضية';

    radio = _getRandomStatus(random);
    if (radio != InspectionStatus.intact) radioNote = 'ملاحظة تجريبية للراديو';

    airConditioner = _getRandomStatus(random);
    if (airConditioner != InspectionStatus.intact) airConditionerNote = 'ملاحظة تجريبية للمكيف';

    frontTires = _getRandomStatus(random);
    if (frontTires != InspectionStatus.intact) frontTiresNote = 'ملاحظة تجريبية للإطارات الأمامية';

    backTires = _getRandomStatus(random);
    if (backTires != InspectionStatus.intact) backTiresNote = 'ملاحظة تجريبية للإطارات الخلفية';

    spareTire = _getRandomStatus(random);
    if (spareTire != InspectionStatus.intact) spareTireNote = 'ملاحظة تجريبية للإطار الاحتياطي';

    tiresCovers = _getRandomStatus(random);
    if (tiresCovers != InspectionStatus.intact) tiresCoversNote = 'ملاحظة تجريبية لأغطية الإطارات';

    spareTools = _getRandomStatus(random);
    if (spareTools != InspectionStatus.intact) spareToolsNote = 'ملاحظة تجريبية لأدوات الاحتياط';
  }

  InspectionStatus _getRandomStatus(Random random) {
    return InspectionStatus.values[random.nextInt(2)];
  }

  void fillMockImages(UploadFile file) {
    if (!kDebugMode) return;
    ownershipFrontImage = file.copyWith();
    ownershipBackImage = file.copyWith();
    frontImage = file.copyWith();
    backImage = file.copyWith();
    rightSideImage = file.copyWith();
    leftSideImage = file.copyWith();
    interiorImage = file.copyWith();
    engineImage = file.copyWith();
  }
}
