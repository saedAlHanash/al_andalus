part of 'policy_cubit.dart';

class PolicyInitial extends AbstractState<Policy> {
  const PolicyInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
  });

  DataPageType get mRequest => request;

  factory PolicyInitial.initial() {
    return PolicyInitial(
      result: Policy.fromJson({}),
      error: '',
      request: DataPageType.policy,
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

  PolicyInitial copyWith({
    CubitStatuses? statuses,
    Policy? result,
    String? error,
    DataPageType? request,
  }) {
    return PolicyInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      request: request ?? this.request,
    );
  }
}
