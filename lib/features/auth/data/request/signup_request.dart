import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:flutter/foundation.dart';

class SignupRequest {
  SignupRequest({
    this.name,
    this.gender,
    this.birthday,
    this.phone,
    this.password,
    this.address,
    this.identityId,
    this.licenseNumber,
    this.licenseType,
    this.licenseStartDate,
    this.licenseEndDate,
    this.biometricId,
  }) {
    if (!kDebugMode) return;
    name = 'مستخدم تجريبي';
    gender = GenderEnum.male;
    birthday = DateTime(1997, 2, 19);
    phone = '07801234567';
    password = '12345678';
    address = 'بغداد - الكرادة';
    identityId = '123456789';
    licenseNumber = '987654321';
    licenseType = LicenseType.private;
    licenseStartDate = DateTime.now();
    licenseEndDate = DateTime.now().add(const Duration(days: 365 * 10));
  }

  String? name;
  GenderEnum? gender;
  DateTime? birthday;
  String? phone;
  String? password;
  String? address;
  String? identityId;
  String? licenseNumber;
  LicenseType? licenseType;
  DateTime? licenseStartDate;
  DateTime? licenseEndDate;
  String? biometricId;

  var identityFrontImage = UploadFile(nameField: 'identity_front_image');
  var identityBackImage = UploadFile(nameField: 'identity_back_image');
  var licenseFrontImage = UploadFile(nameField: 'license_front_image');
  var licenseBackImage = UploadFile(nameField: 'license_back_image');

  bool infoChecked = false;
  bool licenseChecked = false;

  List<UploadFile> get files => [
    identityFrontImage,
    identityBackImage,
    licenseFrontImage,
    licenseBackImage,
  ];

  factory SignupRequest.fromJson(Map<String, dynamic> json) {
    return SignupRequest(
      name: json['name'] as String?,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      identityId: json['identity_id'] as String?,
      licenseNumber: json['license_number'] as String?,
      licenseType: json['license_type'] == null ? null : LicenseType.values[json['license_type'] ?? 0],
      biometricId: json['biometric_id'] as String?,
      gender: json['genderID'] == null ? null : GenderEnum.values[json['genderID'] ?? 0],
      birthday: DateTime.tryParse(json['birth_date'] ?? ''),
      licenseStartDate: DateTime.tryParse(json['license_start_date'] ?? ''),
      licenseEndDate: DateTime.tryParse(json['license_end_date'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'password': password,
    'phone': phone?.fixPhone,
    'gender': gender?.nameApi ?? 'male',
    'genderID': gender?.index ?? 0,
    'birth_date': birthday?.toIso8601String().split('T').first ?? "1997-02-19",
    'address': address,
    'identity_id': identityId,
    'license_number': licenseNumber,
    'license_type': licenseType?.nameApi,
    'license_start_date': licenseStartDate?.toIso8601String().split('T').first,
    'license_end_date': licenseEndDate?.toIso8601String().split('T').first,
    'biometric_id': biometricId,
  };
}
//  '': 'koki',
//   '': '12345678966',
//   '': '3333',
//   '': '1997-02-19',
//   '': 'female'