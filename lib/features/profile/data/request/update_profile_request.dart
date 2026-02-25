import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';

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
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone.fixPhone,
  };
}
