import 'package:equatable/equatable.dart';

class SelectionState extends Equatable {
  final bool isSelectionMode;
  final Set<int> selectedIds;
  final Set<int> archivedIds;
  final Set<int> groupIds;
  final bool isLoading;
  final String? error;
  final bool isLocalOperation;

  const SelectionState({
    required this.isSelectionMode,
    required this.selectedIds,
    required this.archivedIds,
    required this.groupIds,
    this.isLoading = false,
    this.error,
    this.isLocalOperation = false,
  });

  SelectionState copyWith({
    bool? isSelectionMode,
    Set<int>? selectedIds,
    Set<int>? archivedIds,
    Set<int>? groupIds,
    bool? isLoading,
    String? error,
    bool? isLocalOperation,
  }) {
    return SelectionState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
      archivedIds: archivedIds ?? this.archivedIds,
      groupIds: groupIds ?? this.groupIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isLocalOperation: isLocalOperation ?? this.isLocalOperation,
    );
  }

  @override
  List<Object?> get props => [
        isSelectionMode,
        selectedIds,
        archivedIds,
        groupIds,
        isLoading,
        error,
        isLocalOperation,
      ];
}