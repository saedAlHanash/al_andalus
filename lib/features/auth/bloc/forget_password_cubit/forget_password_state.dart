part of 'forget_password_cubit.dart';

class ForgetPasswordInitial extends AbstractState<bool> {
  @override
  final ForgetPasswordRequest request;

  const ForgetPasswordInitial({
    required this.request,
    required super.result,
    super.error,
    super.statuses,
  });

  factory ForgetPasswordInitial.initial() {
    return ForgetPasswordInitial(
      result: false,
      error: '',
      statuses: CubitStatuses.init,
      request: ForgetPasswordRequest(),
    );
  }

  @override
  List<Object> get props => [statuses, result, error];

  ForgetPasswordInitial copyWith({
    ForgetPasswordRequest? request,
    CubitStatuses? statuses,
    bool? result,
    String? error,
  }) {
    return ForgetPasswordInitial(
      request: request ?? this.request,
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}
