part of 'update_profile_cubit.dart';

class UpdateProfileInitial extends AbstractState<Profile> {
  UpdateProfileRequest get mRequest => request as UpdateProfileRequest;

  // final  bool educationalGradeParam;
  const UpdateProfileInitial({
    required super.result,
    super.error,
    super.request,
    super.statuses,
    this.uploadProgress = 0.0,
  }); //

  final double uploadProgress;

  factory UpdateProfileInitial.initial() {
    return UpdateProfileInitial(
      result: Profile.fromJson({}),
      error: '',
      // educationalGradeParam: false,
      request: UpdateProfileRequest.fromJson({}),
      statuses: CubitStatuses.init,
      uploadProgress: 0.0,
    );
  }

  @override
  List<Object> get props => [statuses, result, error, uploadProgress];

  UpdateProfileInitial copyWith({
    CubitStatuses? statuses,
    Profile? result,
    String? error,
    UpdateProfileRequest? request,
    double? uploadProgress,
  }) {
    return UpdateProfileInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      request: request ?? this.request,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}
