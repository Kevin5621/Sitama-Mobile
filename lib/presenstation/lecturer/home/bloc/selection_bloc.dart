import 'package:flutter_bloc/flutter_bloc.dart';
import 'selection_event.dart';
import 'selection_state.dart';

class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
  SelectionBloc()
      : super(const SelectionState(isSelectionMode: false, selectedIds: {})) {
    on<ToggleSelectionMode>(_onToggleSelectionMode);
    on<ToggleItemSelection>(_onToggleItemSelection);
    on<SelectAll>(_onSelectAll);
    on<DeselectAll>(_onDeselectAll);
    on<SendMessage>(_onSendMessage);
  }

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

    // Emit perubahan state dengan daftar ID yang diperbarui
    emit(state.copyWith(selectedIds: selectedIds));

    // Jika tidak ada ID yang dipilih, keluar dari Selection Mode
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
    // Implement send message logic here
    print('Sending message: ${event.message} to ${state.selectedIds}');
    // After sending, you might want to clear the selection
    emit(state.copyWith(isSelectionMode: false, selectedIds: {}));
  }
}