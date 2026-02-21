part of 'confirm_code_cubit.dart';

class ConfirmCodeInitial extends AbstractState<LoginResponse> {

   LoginRequest get  mRequest =>request;

  const ConfirmCodeInitial({
    required super.result,
    super.error,
    super.statuses,
    required super.request,
  });

  factory ConfirmCodeInitial.initial() {
    return ConfirmCodeInitial(
      result: LoginResponse.fromJson({}),
      request: LoginRequest(),
    );
  }

  bool get canSend=>request.code?.length == 5;
  @override
  List<Object> get props => [statuses, result, error,request];

  ConfirmCodeInitial copyWith({
    CubitStatuses? statuses,
    LoginResponse? result,
    String? error,
    LoginRequest? request,
  }) {
    return ConfirmCodeInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      request: request ?? this.request,
    );
  }
}
