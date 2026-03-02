part of 'transfer_ownership_cubit.dart';

class TransferOwnershipState extends AbstractState<TransferOwnershipResponse?> {
  const TransferOwnershipState({
    super.statuses,
    super.cubitCrud,
    super.error,
    super.result,
    super.request,
    required this.idNotifier,
  });

  TransferOwnershipRequest get mRequest => request as TransferOwnershipRequest;
  final int idNotifier;

  factory TransferOwnershipState.initial() {
    return TransferOwnershipState(
      statuses: CubitStatuses.init,
      error: '',
      result: null,
      request: TransferOwnershipRequest(),
      idNotifier: 0,
    );
  }

  @override
  List<Object?> get props => [
    statuses,
    cubitCrud,
    error,
    result,
    request,
    idNotifier,
  ];

  TransferOwnershipState copyWith({
    CubitStatuses? statuses,
    CubitCrud? cubitCrud,
    String? error,
    TransferOwnershipResponse? result,
    TransferOwnershipRequest? request,
    int? idNotifier,
  }) {
    return TransferOwnershipState(
      statuses: statuses ?? this.statuses,
      cubitCrud: cubitCrud ?? this.cubitCrud,
      error: error ?? this.error,
      result: result ?? this.result,
      request: request ?? this.request,
      idNotifier: idNotifier ?? this.idNotifier,
    );
  }
}
