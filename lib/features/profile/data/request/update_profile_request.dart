import 'package:al_andalus/core/app/app_provider.dart';

class UpdateProfileRequest {
  UpdateProfileRequest({
    this.name,
    // this.birthday,
    this.phone,
  });

  String? name;
  String? phone;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequest(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    if (phone != AppProvider.getMe.phone) 'phone': phone,
  };
}
