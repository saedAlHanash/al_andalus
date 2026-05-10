import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/services/firebase_service.dart';
import 'package:flutter/foundation.dart';

class LoginRequest {
  String? phone;
  String? password;
  String? code;

  LoginRequest({this.phone, this.password, this.code}) {
    if (kDebugMode) {
      phone = '07388915233';
      password = '111111';
    }
  }

  LoginRequest copyWith({String? phone, String? password}) {
    return LoginRequest(phone: phone ?? this.phone, password: password ?? this.password);
  }

  Future<Map<String, dynamic>> toJson() async {
    return {
      'phone': phone.fixPhone,
      'password': password,
      'pin_code': password,
      'code': code,
      // 'fcm_token': 'no token',
      'fcm_token': await FirebaseService.getFireTokenAsync(),
    };
  }
}
