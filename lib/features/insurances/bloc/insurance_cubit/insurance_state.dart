part of 'insurance_cubit.dart';

class InsuranceInitial extends AbstractState<InsurancePackage> {
  const InsuranceInitial({
    required super.result,
    super.error,
    super.statuses,
    super.id,
  });

  factory InsuranceInitial.initial() {
    return InsuranceInitial(
      result: InsurancePackage.fromJson({}),
      error: '',
      id: 0,
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<dynamic> get props => [statuses, result, error, id];

  InsuranceInitial copyWith({
    CubitStatuses? statuses,
    InsurancePackage? result,
    String? error,
    int? id,
  }) {
    return InsuranceInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
    );
  }
}
