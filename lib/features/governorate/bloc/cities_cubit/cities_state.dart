part of 'cities_cubit.dart';

class CitiesInitial extends AbstractState<List<City>> {
  const CitiesInitial({
    required super.result,
    super.error,
    super.request,
    super.filterRequest,
    super.cubitCrud,
    super.createUpdateRequest,
    super.statuses,
    super.id,
  });

  factory CitiesInitial.initial() {
    return CitiesInitial(
      result: [],
    );
  }

  String get selectedId => id ?? '';

  @override
  List<Object> get props => [
        statuses,
        result,
        error,
        cubitCrud,
        ?id,
        ?request,
        ?filterRequest,
        ?createUpdateRequest,
      ];

  List<SpinnerItem> getSpinnerItems({String? selectedId}) {
    return List<SpinnerItem>.from(
      result.map(
        (e) => SpinnerItem(
          id: e.id,
          isSelected: e.id.toString() == (selectedId),
          name: e.name,
          item: e,
        ),
      ),
    );
  }

  CitiesInitial copyWith({
    CubitStatuses? statuses,
    CubitCrud? cubitCrud,
    List<City>? result,
    String? error,
    FilterRequest? filterRequest,
    dynamic request,
    dynamic cRequest,
    dynamic id,
  }) {
    return CitiesInitial(
      statuses: statuses ?? this.statuses,
      cubitCrud: cubitCrud ?? this.cubitCrud,
      result: result ?? this.result,
      error: error ?? this.error,
      filterRequest: filterRequest ?? this.filterRequest,
      request: request ?? this.request,
      createUpdateRequest: cRequest ?? this.createUpdateRequest,
      id: id ?? this.id,
    );
  }
}
