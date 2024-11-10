// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'selection_event.dart';
import 'selection_state.dart';

class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
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
    
    // Load archived items when bloc is created
    _loadArchivedItems();
  }

  // Existing event handlers
  void _onToggleSelectionMode(
      ToggleSelectionMode event, Emitter<SelectionState> emit) {
    emit(state
        .copyWith(isSelectionMode: !state.isSelectionMode, selectedIds: {}));
  }

  void _onToggleItemSelection(
      ToggleItemSelection event, Emitter<SelectionState> emit) {
    final selectedIds = Set<int>.from(state.selectedIds);
    if (selectedIds.contains(event.id)) {
      selectedIds.remove(event.id);
    } else {
      selectedIds.add(event.id);
    }

    emit(state.copyWith(selectedIds: selectedIds));

    if (selectedIds.isEmpty) {
      emit(state.copyWith(isSelectionMode: false));
    }
  }

  void _onSelectAll(SelectAll event, Emitter<SelectionState> emit) {
    // Implement select all logic here
    // You'll need to pass the list of all student IDs to this method
  }

  void _onDeselectAll(DeselectAll event, Emitter<SelectionState> emit) {
    emit(state.copyWith(selectedIds: {}));
  }

  void _onSendMessage(SendMessage event, Emitter<SelectionState> emit) {
    print('Sending message: ${event.message} to ${state.selectedIds}');
    emit(state.copyWith(isSelectionMode: false, selectedIds: {}));
  }

  // New archive-related methods
  Future<void> _loadArchivedItems() async {
    final archivedIds = await _getArchivedIds();
    emit(state.copyWith(archivedIds: archivedIds));
  }

  Future<void> _onArchiveSelectedItems(
  ArchiveSelectedItems event, 
  Emitter<SelectionState> emit,
) async {
  if (state.selectedIds.isEmpty) return;
  
  final newArchivedIds = {...state.archivedIds, ...state.selectedIds};
  
  // Save to persistent storage
  await _saveArchivedIds(newArchivedIds);
  
  // Update state
  emit(state.copyWith(
    isSelectionMode: false,
    selectedIds: {},
    archivedIds: newArchivedIds,
  ));
}
  Future<void> _onUnarchiveItems(
    UnarchiveItems event, 
    Emitter<SelectionState> emit,
  ) async {
    // Remove specified ids from archived items
    final newArchivedIds = {...state.archivedIds}..removeAll(event.ids);
    
    // Save to persistent storage
    await _saveArchivedIds(newArchivedIds);
    
    // Update state
    emit(state.copyWith(archivedIds: newArchivedIds));
  }

  // Persistent storage methods
  static const String _archiveKey = 'archived_students';

  Future<Set<int>> _getArchivedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> archived = prefs.getStringList(_archiveKey) ?? [];
    return archived.map((id) => int.parse(id)).toSet();
  }

  Future<void> _saveArchivedIds(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> archived = ids.map((id) => id.toString()).toList();
    await prefs.setStringList(_archiveKey, archived);
  }
}
