part of 'car_cubit.dart';

class CarInitial extends AbstractState<CarPolicy> {
  const CarInitial({
    required super.result,
    super.error,
    super.statuses,
    super.id,
  });

  factory CarInitial.initial() {
    return CarInitial(
      result: CarPolicy.fromJson({}),
      error: '',
      id: '',
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<dynamic> get props => [statuses, result, error, id];

  CarInitial copyWith({
    CubitStatuses? statuses,
    CarPolicy? result,
    String? error,
    String? id,
  }) {
    return CarInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
    );
  }
}
