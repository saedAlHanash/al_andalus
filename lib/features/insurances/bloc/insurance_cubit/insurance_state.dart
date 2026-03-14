part of 'insurance_cubit.dart';

class InsuranceInitial extends AbstractState<InsurancePackage> {
  const InsuranceInitial({
    required this.selectedCylinder,
    required this.estimatedPrice,
    required super.result,
    super.error,
    super.statuses,
    super.id,
  });

  final int selectedCylinder;
  final double estimatedPrice;



  factory InsuranceInitial.initial() {
    return InsuranceInitial(
      result: InsurancePackage.fromJson({}),
      error: '',
      id: '',
      selectedCylinder: 0,
      estimatedPrice: 0,
      statuses: CubitStatuses.init,
    );
  }

  Cylinder get cylinder => result.cylinders.firstWhereOrNull((e) => e.id == selectedCylinder) ?? Cylinder.fromJson({});

  num get price {
    return cylinder.pricingType == .fixed ? cylinder.value : (cylinder.value * estimatedPrice) / 100;
  }

  @override
  List<dynamic> get props => [
    statuses,
    result,
    error,
    id,
    selectedCylinder,
    estimatedPrice,
  ];

  InsuranceInitial copyWith({
    CubitStatuses? statuses,
    InsurancePackage? result,
    String? error,
    String? id,
    int? selectedCylinder,
    double? estimatedPrice,
  }) {
    return InsuranceInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      selectedCylinder: selectedCylinder ?? this.selectedCylinder,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
    );
  }
}
