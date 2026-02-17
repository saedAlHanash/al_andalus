class Profiles {
  Profiles({required this.data});

  final Profile data;

  factory Profiles.fromJson(Map<String, dynamic> json) {
    return Profiles(data: Profile.fromJson(json["data"] ?? {}));
  }

  Map<String, dynamic> toJson() => {"data": data.toJson()};
}

class Profile {
  Profile({
    required this.id,
    required this.name,
    required this.phone,
    required this.identityId,
    required this.address,
    required this.birthDate,
    required this.qrcode,
    required this.gender,
    required this.identityFrontImage,
    required this.identityBackImage,
    required this.licenseNumber,
    required this.licenseType,
    required this.licenseStartDate,
    required this.licenseEndDate,
    required this.licenseFrontImage,
    required this.licenseBackImage,
    required this.biometricId,
    required this.created,
  });

  final int id;
  final String name;
  final String phone;
  final String identityId;
  final String address;
  final DateTime? birthDate;
  final String qrcode;
  final String gender;
  final String identityFrontImage;
  final String identityBackImage;
  final String licenseNumber;
  final String licenseType;
  final DateTime? licenseStartDate;
  final DateTime? licenseEndDate;
  final String licenseFrontImage;
  final String licenseBackImage;
  final String biometricId;
  final String created;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: int.tryParse(json["id"].toString()) ?? 0,
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      identityId: json["identity_id"] ?? "",
      address: json["address"] ?? "",
      birthDate: DateTime.tryParse(json["birth_date"] ?? ""),
      qrcode: json["qrcode"] ?? "",
      gender: json["gender"] ?? "",
      identityFrontImage: json["identity_front_image"] ?? "",
      identityBackImage: json["identity_back_image"] ?? "",
      licenseNumber: json["license_number"] ?? "",
      licenseType: json["license_type"] ?? "",
      licenseStartDate: DateTime.tryParse(json["license_start_date"] ?? ""),
      licenseEndDate: DateTime.tryParse(json["license_end_date"] ?? ""),
      licenseFrontImage: json["license_front_image"] ?? "",
      licenseBackImage: json["license_back_image"] ?? "",
      biometricId: json["biometric_id"] ?? "",
      created: json["created"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "identity_id": identityId,
    "address": address,
    "birth_date": birthDate?.toIso8601String(),
    "qrcode": qrcode,
    "gender": gender,
    "identity_front_image": identityFrontImage,
    "identity_back_image": identityBackImage,
    "license_number": licenseNumber,
    "license_type": licenseType,
    "license_start_date": licenseStartDate?.toIso8601String(),
    "license_end_date": licenseEndDate?.toIso8601String(),
    "license_front_image": licenseFrontImage,
    "license_back_image": licenseBackImage,
    "biometric_id": biometricId,
    "created": created,
  };
}
