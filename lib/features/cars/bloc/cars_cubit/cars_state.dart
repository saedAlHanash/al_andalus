part of 'cars_cubit.dart';

class CarsInitial extends AbstractState<List<CarPolicy>> {
  const CarsInitial({
    required super.result,
    super.error,
    super.statuses,
    super.request,
    required this.step,
    required this.idNotifier,
    required this.url,
    super.cubitCrud,
    super.id,
  });

  InsurancePolicyRequest get mRequest => request as InsurancePolicyRequest;
  final int idNotifier;
  final String url;
  final int step;

  factory CarsInitial.initial() {
    return CarsInitial(
      result: [],
      error: '',
      request: InsurancePolicyRequest(),
      step: 0,
      idNotifier: 0,
      url: '',

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
    idNotifier,
    url,
    cubitCrud,
  ];

  CarsInitial copyWith({
    CubitStatuses? statuses,
    List<CarPolicy>? result,
    String? error,
    InsurancePolicyRequest? request,
    int? step,
    int? idNotifier,
    String? url,
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
      idNotifier: idNotifier ?? this.idNotifier,
      url: url ?? this.url,
      id: id ?? this.id,
    );
  }
}
