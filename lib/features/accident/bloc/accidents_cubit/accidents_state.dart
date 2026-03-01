part of 'accidents_cubit.dart';

class AccidentsInitial extends AbstractState<List<AccidentResponse>> {
  const AccidentsInitial({
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

  AccidentRequest get mRequest => request as AccidentRequest;
  final int idNotifier;
  final String url;
  final int step;

  factory AccidentsInitial.initial() {
    return AccidentsInitial(
      result: [],
      error: '',
      request: AccidentRequest(),
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

  AccidentsInitial copyWith({
    CubitStatuses? statuses,
    List<AccidentResponse>? result,
    String? error,
    AccidentRequest? request,
    int? step,
    int? idNotifier,
    String? url,
    CubitCrud? cubitCrud,
    dynamic id,
  }) {
    return AccidentsInitial(
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
