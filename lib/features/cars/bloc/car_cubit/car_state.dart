part of 'car_cubit.dart';

class CarInitial extends AbstractState<CarPolicy> {
  final String qr;

  const CarInitial({
    required super.result,
    super.error,
    super.statuses,
    super.id,
    this.qr = '',
  });

  factory CarInitial.initial() {
    return CarInitial(
      result: CarPolicy.fromJson({}),
      error: '',
      id: '',
      qr: '',
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<dynamic> get props => [statuses, result, error, id, qr];

  CarInitial copyWith({
    CubitStatuses? statuses,
    CarPolicy? result,
    String? error,
    String? id,
    String? qr,
  }) {
    return CarInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      qr: qr ?? this.qr,
    );
  }
}
