part of 'accident_cubit.dart';

class AccidentInitial extends AbstractState<AccidentResponse> {
  const AccidentInitial({
    required super.result,
    super.error,
    super.statuses,
    super.id,
  });

  factory AccidentInitial.initial() {
    return AccidentInitial(
      result: AccidentResponse.fromJson({}),
      error: '',
      id: '',
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<dynamic> get props => [statuses, result, error, id];

  AccidentInitial copyWith({
    CubitStatuses? statuses,
    AccidentResponse? result,
    String? error,
    String? id,
  }) {
    return AccidentInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
    );
  }
}
