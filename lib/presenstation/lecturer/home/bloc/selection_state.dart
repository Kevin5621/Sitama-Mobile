import 'package:equatable/equatable.dart';
class SelectionState extends Equatable {
  final bool isSelectionMode;
  final Set<int> selectedIds;
  final Set<int> archivedIds;
  final bool isLoading;
  final String? error;

  const SelectionState({
    required this.isSelectionMode,
    required this.selectedIds,
    required this.archivedIds,
    this.isLoading = false,
    this.error,
  });

  SelectionState copyWith({
    bool? isSelectionMode,
    Set<int>? selectedIds,
    Set<int>? archivedIds,
    bool? isLoading,
    String? error,
  }) {
    return SelectionState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
      archivedIds: archivedIds ?? this.archivedIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isSelectionMode,
        selectedIds,
        archivedIds,
        isLoading,
        error,
      ];
}
