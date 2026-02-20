part of 'signup_cubit.dart';

class SignupInitial extends AbstractState<bool> {
  const SignupInitial({
    required super.request,
    required super.result,
    required this.step,
    super.error,
    super.statuses,
  });

  SignupRequest get mRequest => request;

  final int step;

  factory SignupInitial.initial() {
    return SignupInitial(
      result: false,
      step: 0,
      request: SignupRequest(),
    );
  }

  @override
  List<Object> get props => [
    statuses,
    result,
    error,
    step,
    if (request != null) request,
  ];

  SignupInitial copyWith({
    CubitStatuses? statuses,
    bool? result,
    String? error,
    SignupRequest? request,
    int? step,
  }) {
    return SignupInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      request: request ?? this.request,
      step: step ?? this.step,
    );
  }
}
