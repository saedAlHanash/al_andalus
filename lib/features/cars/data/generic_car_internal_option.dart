import 'package:equatable/equatable.dart';

import '../../../core/strings/enum_manager.dart';

class GenericCarInternalOption extends Equatable {
  const GenericCarInternalOption({
    required this.onOptionChanged,
    required this.groupValue,
    required this.note,
    required this.title,
    required  this.onDetailsButtonTap,
  });

  final Function(InspectionStatus state) onOptionChanged;
  final InspectionStatus? Function() groupValue;
  final String? Function() note;
  final String title;
  final Function(String note) onDetailsButtonTap;

  @override
  List<Object?> get props => [title, groupValue, onOptionChanged, onDetailsButtonTap];
}
