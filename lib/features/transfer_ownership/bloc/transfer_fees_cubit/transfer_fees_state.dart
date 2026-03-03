part of 'transfer_fees_cubit.dart';

class TransferFeesInitial extends AbstractState<TransferFee> {
  const TransferFeesInitial({
    required super.result,
    super.error,
    super.statuses,
  });

  factory TransferFeesInitial.initial() {
    return  TransferFeesInitial(
      result: TransferFee.fromJson({}),
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<Object?> get props => [statuses, result, error];

  TransferFeesInitial copyWith({
    CubitStatuses? statuses,
    TransferFee? result,
    String? error,
  }) {
    return TransferFeesInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}
