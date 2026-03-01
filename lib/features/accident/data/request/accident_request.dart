import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:flutter/foundation.dart';

class AccidentRequest {
  AccidentRequest({
    this.vehicleId,
    this.location,
    this.description,
  }) {
    if (!kDebugMode) return;
    location = 'دمشق مخيم اليرموك شارع ال 30';
    description = 'سقوط شظية من صاروخ ايراني على السيارة من الخلف';
  }

  String? vehicleId;
  String? location;
  String? description;

  var policeReport = UploadFile(nameField: 'police_report');
  var frontImage = UploadFile(nameField: 'attachments[front_image]');
  var backImage = UploadFile(nameField: 'attachments[back_image]');
  var rightSideImage = UploadFile(nameField: 'attachments[right_side_image]');
  var leftSideImage = UploadFile(nameField: 'attachments[left_side_image]');
  var interiorImage = UploadFile(nameField: 'attachments[interior_image]');
  var engineImage = UploadFile(nameField: 'attachments[engine_image]');

  List<UploadFile> get files {
    policeReport.nameField = 'police_report';
    frontImage.nameField = 'attachments[front_image]';
    backImage.nameField = 'attachments[back_image]';
    rightSideImage.nameField = 'attachments[right_side_image]';
    leftSideImage.nameField = 'attachments[left_side_image]';
    interiorImage.nameField = 'attachments[interior_image]';
    engineImage.nameField = 'attachments[engine_image]';
    return [
      policeReport,
      frontImage,
      backImage,
      rightSideImage,
      leftSideImage,
      interiorImage,
      engineImage,
    ];
  }

  Map<String, dynamic> toJson() => {
    if (vehicleId != null) 'vehicle_id': vehicleId,
    if (location != null) 'location': location,
    if (description != null) 'description': description,
  };

  void setTempImages(UploadFile file) {
    if (!kDebugMode) return;

    policeReport = file.copyWith();
    frontImage = file.copyWith();

    backImage = file.copyWith();

    rightSideImage = file.copyWith();

    leftSideImage = file.copyWith();

    interiorImage = file.copyWith();

    engineImage = file.copyWith();
  }
}
