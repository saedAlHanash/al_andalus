class SupportInfo {
  SupportInfo({
    required this.phone,
    required this.email,
    required this.whatsApp,
  });

  final String phone;
  final String email;
  final String whatsApp;

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
      "email": email,
      "whatsApp": whatsApp,
    };
  }

  factory SupportInfo.fromJson(Map<String, dynamic> json) {
    return SupportInfo(
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      whatsApp: json["whatsApp"] ?? "",
    );
  }
}
