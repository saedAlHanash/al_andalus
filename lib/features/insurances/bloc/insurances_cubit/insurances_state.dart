part of 'insurances_cubit.dart';

class InsurancesInitial extends AbstractState<List<InsurancePackage>> {
  const InsurancesInitial({
    required super.result,
    super.error,
    super.statuses,
    // Add custom fields here if needed
  });

  factory InsurancesInitial.initial() {
    return InsurancesInitial(
      result: [],
      error: '',
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<dynamic> get props => [statuses, result, error];

  InsurancesInitial copyWith({
    CubitStatuses? statuses,
    List<InsurancePackage>? result,
    String? error,
  }) {
    return InsurancesInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}
