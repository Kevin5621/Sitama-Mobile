import 'package:equatable/equatable.dart';

class SelectionState extends Equatable {
  final bool isSelectionMode;
  final Set<int> selectedIds;
  final Set<int> archivedIds;

  const SelectionState({
    required this.isSelectionMode,
    required this.selectedIds,
    required this.archivedIds,
  });

  SelectionState copyWith({
    bool? isSelectionMode,
    Set<int>? selectedIds,
    Set<int>? archivedIds,
  }) {
    return SelectionState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
      archivedIds: archivedIds ?? this.archivedIds,
    );
  }

  @override
  List<Object> get props => [isSelectionMode, selectedIds];
}