import 'package:al_andalus/core/extensions/extensions.dart';

class ForgetPasswordRequest {
  ForgetPasswordRequest({this.phone});

  String? phone;

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordRequest(phone: json["phone"] ?? "");
  }

  Map<String, dynamic> toJson() => {
        "phone": phone.fixPhone,
      };
}
