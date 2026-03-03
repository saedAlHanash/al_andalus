class TransferFee {
  TransferFee({
    required this.data,
  });

  final num data;

  factory TransferFee.fromJson(Map<String, dynamic> json) {
    return TransferFee(
      data: json["data"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data,
  };
}
