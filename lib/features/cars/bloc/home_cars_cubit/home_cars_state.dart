part of 'home_cars_cubit.dart';

class HomeCarsInitial extends AbstractState<List<CarPolicy>> {
  const HomeCarsInitial({
    required super.result,
    super.error,
    super.statuses,
    super.request,
    required this.step,
    required this.idNotifier,
    required this.url,
    this.uploadProgress = 0.0,
    super.cubitCrud,
    super.id,
  });

  InsurancePolicyRequest get mRequest => request as InsurancePolicyRequest;
  final int idNotifier;
  final String url;
  final int step;
  final double uploadProgress;

  factory HomeCarsInitial.initial() {
    return HomeCarsInitial(
      result: [],
      error: '',
      request: InsurancePolicyRequest(),
      step: 0,
      idNotifier: 0,
      url: '',
      id: '',
      uploadProgress: 0.0,
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<dynamic> get props => [
    statuses,
    result,
    error,
    ?id,
    ?request,
    step,
    idNotifier,
    url,
    uploadProgress,
    cubitCrud,
  ];

  HomeCarsInitial copyWith({
    CubitStatuses? statuses,
    List<CarPolicy>? result,
    String? error,
    InsurancePolicyRequest? request,
    int? step,
    int? idNotifier,
    String? url,
    CubitCrud? cubitCrud,
    double? uploadProgress,
    dynamic id,
  }) {
    return HomeCarsInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      request: request ?? this.request,
      step: step ?? this.step,
      cubitCrud: cubitCrud ?? this.cubitCrud,
      idNotifier: idNotifier ?? this.idNotifier,
      url: url ?? this.url,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      id: id ?? this.id,
    );
  }
}
