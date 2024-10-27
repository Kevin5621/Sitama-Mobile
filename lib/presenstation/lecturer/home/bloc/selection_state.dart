import 'package:equatable/equatable.dart';

class SelectionState extends Equatable {
  final bool isSelectionMode;
  final Set<int> selectedIds;

  const SelectionState({
    required this.isSelectionMode,
    required this.selectedIds,
  });

  SelectionState copyWith({
    bool? isSelectionMode,
    Set<int>? selectedIds,
  }) {
    return SelectionState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  @override
  List<Object> get props => [isSelectionMode, selectedIds];
}