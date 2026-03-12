part of 'confirm_code_cubit.dart';

class ConfirmCodeInitial extends AbstractState<LoginResponse> {
  LoginRequest get mRequest => request;

  String get pin => id.toString();

  const ConfirmCodeInitial({
    required super.result,
    super.error,
    super.statuses,
    super.id,
    required super.request,
  });

  factory ConfirmCodeInitial.initial() {
    return ConfirmCodeInitial(
      result: LoginResponse.fromJson({}),
      request: LoginRequest(),
      id: '',
    );
  }

  bool get canSend => request.code?.length == 6;

  @override
  List<Object> get props => [
    statuses,
    result,
    error,
    request,
    if (id != null) id,
  ];

  ConfirmCodeInitial copyWith({
    CubitStatuses? statuses,
    LoginResponse? result,
    String? error,
    String? pin,
    LoginRequest? request,
  }) {
    return ConfirmCodeInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: pin ?? this.pin,
      request: request ?? this.request,
    );
  }
}
