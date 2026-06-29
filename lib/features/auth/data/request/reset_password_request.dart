import 'package:al_andalus/core/extensions/extensions.dart';

import '../../../../core/util/shared_preferences.dart';

class ResetPasswordRequest {
  ResetPasswordRequest({
    this.password,
    this.passwordConfirmation,
    this.code,
  });

  String? password;
  String? passwordConfirmation;
  String? code;

  Map<String, dynamic> toJson() => {
    "phone": AppSharedPreference.getPhone.fixPhone,
    "pin_code": password,
    "code": code,
  };
}
