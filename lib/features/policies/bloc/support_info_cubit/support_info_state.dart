part of 'support_info_cubit.dart';

class SupportInfoInitial extends AbstractState<SupportInfo> {
  const SupportInfoInitial({
    required super.result,
    super.error,
    super.request,
    super.statuses,
  });

  factory SupportInfoInitial.initial() {
    return SupportInfoInitial(
      result: SupportInfo.fromJson({}),
      error: '',
      statuses: CubitStatuses.init,
    );
  }

  @override
  List<Object> get props => [
    statuses,
    result,
    error,
    ?request,
  ];

  SupportInfoInitial copyWith({
    CubitStatuses? statuses,
    SupportInfo? result,
    String? error,
    dynamic request,
  }) {
    return SupportInfoInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      request: request ?? this.request,
    );
  }
}
