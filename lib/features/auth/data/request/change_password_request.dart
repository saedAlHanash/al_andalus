class ChangePasswordRequest {
  String oldPass;
  String newPass;

  ChangePasswordRequest({
    this.oldPass = '',
    this.newPass = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'old-password': oldPass,
      'old-pin_code': oldPass,
      'password': newPass,
      'pin_code': newPass,
    };
  }

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> map) {
    return ChangePasswordRequest(
      oldPass: map['old-password'] ?? '',
      newPass: map['password'] ?? '',
    );
  }
}
