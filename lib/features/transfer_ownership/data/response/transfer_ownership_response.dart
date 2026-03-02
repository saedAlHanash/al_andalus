class TransferOwnershipResponse {
  TransferOwnershipResponse({
    required this.message,
    required this.status,
  });

  final String message;
  final bool status;

  factory TransferOwnershipResponse.fromJson(Map<String, dynamic> json) {
    return TransferOwnershipResponse(
      message: json["message"] ?? "",
      status: json["status"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
