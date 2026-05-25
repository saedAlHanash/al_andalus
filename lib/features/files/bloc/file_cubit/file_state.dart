part of 'file_cubit.dart';

class FileInitial extends AbstractState<FileResponse> {
  const FileInitial({
    required super.result,
    super.error,
    required super.request,
    super.statuses,
    super.id,
  });

  factory FileInitial.initial() {
    return FileInitial(
      result: FileResponse.fromJson({}),
      request: '',
    );
  }

  @override
  List<Object> get props => [
    statuses,
    result,
    error,
    if (request != null) request,
    if (id != null) id,
    if (filterRequest != null) filterRequest!,
  ];

  FileInitial copyWith({
    CubitStatuses? statuses,
    FileResponse? result,
    String? error,
    dynamic id,
    String? request,
  }) {
    return FileInitial(
      statuses: statuses ?? this.statuses,
      result: result ?? this.result,
      error: error ?? this.error,
      id: id ?? this.id,
      request: request ?? this.request,
    );
  }
}
