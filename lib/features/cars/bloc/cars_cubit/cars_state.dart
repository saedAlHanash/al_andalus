part of 'cars_cubit.dart';

class CarsInitial extends AbstractState<List<CarPolicy>> {
  const CarsInitial({
    required super.result,
    super.error,
    super.statuses,
    super.request,
    required this.step,
    super.cubitCrud,
    super.id,
  });

  InsurancePolicyRequest get mRequest => request as InsurancePolicyRequest;
  final int step;

  factory CarsInitial.initial() {
    return CarsInitial(
      result: [],
      error: '',
      request: InsurancePolicyRequest(),
      step: 0,

      statuses: CubitStatuses.init,
    );
  }

  @override
  List<dynamic> get props => [
    statuses,
    result,
    error,
    id,
    request,
    step,
    cubitCrud,
  ];

  CarsInitial copyWith({
    CubitStatuses? statuses,
    List<CarPolicy>? result,
    String? error,
    InsurancePolicyRequest? request,
    int? step,
    CubitCrud? cubitCrud,
    dynamic id,
  }) {
    return CarsInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      request: request ?? this.request,
      step: step ?? this.step,
      cubitCrud: cubitCrud ?? this.cubitCrud,
      id: id ?? this.id,
    );
  }
}
