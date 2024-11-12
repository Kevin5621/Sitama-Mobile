// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'selection_event.dart';
import 'selection_state.dart';

class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
  static const String _archiveKey = 'archived_students';

  SelectionBloc()
      : super(const SelectionState(
          isSelectionMode: false,
          selectedIds: {},
          archivedIds: {},
        )) {
    on<ToggleSelectionMode>(_onToggleSelectionMode);
    on<ToggleItemSelection>(_onToggleItemSelection);
    on<SelectAll>(_onSelectAll);
    on<DeselectAll>(_onDeselectAll);
    on<SendMessage>(_onSendMessage);
    on<ArchiveSelectedItems>(_onArchiveSelectedItems);
    on<UnarchiveItems>(_onUnarchiveItems);
    on<LoadArchivedItems>(_onLoadArchivedItems);
    on<ClearSelectionMode>(_onClearSelectionMode);

    // Load archived items when bloc is created
    add(LoadArchivedItems());
  }

  void _onToggleSelectionMode(
      ToggleSelectionMode event, Emitter<SelectionState> emit) {
    emit(state.copyWith(
      isSelectionMode: !state.isSelectionMode,
      selectedIds: const {},
    ));
  }

  void _onToggleItemSelection(
      ToggleItemSelection event, Emitter<SelectionState> emit) {
    final selectedIds = Set<int>.from(state.selectedIds);
    if (selectedIds.contains(event.id)) {
      selectedIds.remove(event.id);
    } else {
      selectedIds.add(event.id);
    }

    emit(state.copyWith(
      selectedIds: selectedIds,
      isSelectionMode: selectedIds.isNotEmpty,
    ));
  }

  void _onSelectAll(SelectAll event, Emitter<SelectionState> emit) {
    final selectedIds = Set<int>.from(event.ids);
    emit(state.copyWith(
      selectedIds: selectedIds,
      isSelectionMode: selectedIds.isNotEmpty,
    ));
  }

  void _onDeselectAll(DeselectAll event, Emitter<SelectionState> emit) {
    emit(state.copyWith(
      selectedIds: {},
      isSelectionMode: false,
    ));
  }

  void _onSendMessage(SendMessage event, Emitter<SelectionState> emit) {
    // Implement message sending logic here
    print('Sending message: ${event.message} to ${state.selectedIds}');
    emit(state.copyWith(
      isSelectionMode: false,
      selectedIds: {},
    ));
  }

  Future<void> _onLoadArchivedItems(
    LoadArchivedItems event,
    Emitter<SelectionState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final archivedIds = await _getArchivedIds();
      emit(state.copyWith(
        archivedIds: archivedIds,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load archived items: $e',
      ));
    }
  }

  Future<void> _onClearSelectionMode(
  ClearSelectionMode event,
  Emitter<SelectionState> emit,
) async {
  emit(state.copyWith(
    isSelectionMode: false,
    selectedIds: {},
  ));
}

  Future<void> _onArchiveSelectedItems(
    ArchiveSelectedItems event,
    Emitter<SelectionState> emit,
  ) async {
    if (state.selectedIds.isEmpty) return;

    try {
      emit(state.copyWith(isLoading: true, error: null));
      
      final newArchivedIds = {...state.archivedIds, ...state.selectedIds};
      await _saveArchivedIds(newArchivedIds);

      emit(state.copyWith(
        isSelectionMode: false,
        selectedIds: {},
        archivedIds: newArchivedIds,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to archive items: $e',
      ));
    }
  }

  Future<void> _onUnarchiveItems(
    UnarchiveItems event,
    Emitter<SelectionState> emit,
  ) async {
    try {
      // Set isLocalOperation to true to prevent unnecessary loading states
      emit(state.copyWith(isLocalOperation: true));

      final updatedArchivedIds = Set<int>.from(state.archivedIds)
        ..removeAll(event.ids);
      
      // Update state immediately for UI responsiveness
      emit(state.copyWith(
        archivedIds: updatedArchivedIds,
        selectedIds: {},
        isSelectionMode: false,
        isLocalOperation: true,
      ));

      // Save to SharedPreferences in the background
      await _saveArchivedIds(updatedArchivedIds);

      // Final emit to confirm persistence
      emit(state.copyWith(isLocalOperation: false));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to unarchive items: $e',
        isLocalOperation: false,
      ));
    }
  }

  Future<Set<int>> _getArchivedIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? archived = prefs.getStringList(_archiveKey);
      if (archived == null || archived.isEmpty) return {};
      return archived.map((id) => int.parse(id)).toSet();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveArchivedIds(Set<int> ids) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> archived = ids.map((id) => id.toString()).toList();
      await prefs.setStringList(_archiveKey, archived);
    } catch (e) {
      rethrow;
    }
  }
}