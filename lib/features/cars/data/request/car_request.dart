class AddCarRequest {
  final int packageId;
  final int cylinderId;
  final double estimatedPrice;

  AddCarRequest({
    required this.packageId,
    required this.cylinderId,
    required this.estimatedPrice,
  });

  Map<String, dynamic> toJson() => {
    'insurance_package_id': packageId,
    'cylinder_id': cylinderId,
    'estimated_price': estimatedPrice,
  };
}
