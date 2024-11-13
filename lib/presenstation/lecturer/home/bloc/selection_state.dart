import 'package:equatable/equatable.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';

class SelectionState extends Equatable {
  final bool isSelectionMode;
  final Set<int> selectedIds;
  final Set<int> archivedIds;
  final List<GroupModel> groups;
  final bool isLoading;
  final String? error;
  final bool isLocalOperation;

  const SelectionState({
    required this.isSelectionMode,
    required this.selectedIds,
    required this.archivedIds,
    this.groups = const [],
    this.isLoading = false,
    this.error,
    this.isLocalOperation = false,
  });

  SelectionState copyWith({
    bool? isSelectionMode,
    Set<int>? selectedIds,
    Set<int>? archivedIds,
    List<GroupModel>? groups,
    bool? isLoading,
    String? error,
    bool? isLocalOperation,
  }) {
    return SelectionState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
      archivedIds: archivedIds ?? this.archivedIds,
      groups: groups ?? this.groups,
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
        groups,
        isLoading,
        error,
        isLocalOperation,
      ];
}