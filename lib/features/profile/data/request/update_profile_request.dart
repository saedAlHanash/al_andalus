import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';

class UpdateProfileRequest {
  UpdateProfileRequest({
    this.name,
    this.phone,
    this.address,
    this.identityId,
    this.birthday,
    this.gender,
    this.licenseNumber,
    this.licenseType,
    this.licenseStartDate,
    this.licenseEndDate,
  });

  String? name;
  String? phone;
  String? address;
  String? identityId;
  DateTime? birthday;
  GenderEnum? gender;

  String? licenseNumber;
  LicenseType? licenseType;
  DateTime? licenseStartDate;
  DateTime? licenseEndDate;

  var identityFrontImage = UploadFile(nameField: 'identity_front_image');
  var identityBackImage = UploadFile(nameField: 'identity_back_image');
  var licenseFrontImage = UploadFile(nameField: 'license_front_image');
  var licenseBackImage = UploadFile(nameField: 'license_back_image');

  List<UploadFile> get identityFiles => [
    identityFrontImage,
    identityBackImage,
  ];

  List<UploadFile> get licenseFiles => [
    licenseFrontImage,
    licenseBackImage,
  ];

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequest(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      identityId: json['identity_id'] as String?,
      birthday: DateTime.tryParse(json['birth_date'] ?? ''),
      gender: json['genderID'] == null ? null : GenderEnum.values[json['genderID'] ?? 0],
      licenseNumber: json['license_number'] as String?,
      licenseType: json['license_type'] == null ? null : LicenseType.values[json['license_type'] ?? 0],
      licenseStartDate: DateTime.tryParse(json['license_start_date'] ?? ''),
      licenseEndDate: DateTime.tryParse(json['license_end_date'] ?? ''),
    );
  }

  Map<String, dynamic> toJsonPhone() => {
    'phone': phone?.fixPhone,
  };

  Map<String, dynamic> toJsonIdentity() => {
    'name': name,
    'address': address,
    'identity_id': identityId,
    'birth_date': birthday?.toIso8601String().split('T').first ?? "1997-02-19",
    'gender': gender?.nameApi ?? 'male',
    'genderID': gender?.index ?? 0,
    'identity_front_image': identityFrontImage.remoteId,
    'identity_back_image': identityBackImage.remoteId,
  };

  Map<String, dynamic> toJsonLicense() => {
    'license_number': licenseNumber,
    'license_type': licenseType?.nameApi,
    'license_start_date': licenseStartDate?.toIso8601String().split('T').first,
    'license_end_date': licenseEndDate?.toIso8601String().split('T').first,
    'license_front_image': licenseFrontImage.remoteId,
    'license_back_image': licenseBackImage.remoteId,
  };

  Map<String, dynamic> toJsonProfile() => {
    'name': name,
    'phone': phone?.fixPhone,
  };
}
