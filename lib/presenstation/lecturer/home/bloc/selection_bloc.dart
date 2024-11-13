// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'selection_event.dart';
import 'selection_state.dart';

class GroupModel {
  final String id;
  final String title;
  final IconData icon;
  final Set<int> studentIds;

  GroupModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.studentIds,
  });

  GroupModel copyWith({
    String? id,
    String? title,
    IconData? icon,
    Set<int>? studentIds,
  }) {
    return GroupModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      studentIds: studentIds ?? this.studentIds,
    );
  }
}

class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
  static const String _archiveKey = 'archived_students';
  static const String _groupsKey = 'student_groups';

  SelectionBloc()
      : super(const SelectionState(
          isSelectionMode: false,
          selectedIds: {},
          archivedIds: {},
          groups: [],
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
    on<CreateGroup>(_onCreateGroup);
    on<RemoveFromGroup>(_onRemoveFromGroup);

    // Load archived items and groups when bloc is created
    add(LoadArchivedItems());
    _loadGroups();
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


//group
   Future<void> _onCreateGroup(
    CreateGroup event,
    Emitter<SelectionState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final newGroup = GroupModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        icon: event.icon,
        studentIds: event.studentIds,
      );

      final updatedGroups = [...state.groups, newGroup];
      await _saveGroups(updatedGroups);

      emit(state.copyWith(
        groups: updatedGroups,
        isSelectionMode: false,
        selectedIds: {},
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to create group: $e',
      ));
    }
  }

  Future<void> _onRemoveFromGroup(
    RemoveFromGroup event,
    Emitter<SelectionState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final updatedGroups = state.groups.map((group) {
        if (group.id == event.groupId) {
          final updatedStudentIds = Set<int>.from(group.studentIds)
            ..removeAll(event.studentIds);
          return group.copyWith(studentIds: updatedStudentIds);
        }
        return group;
      }).toList();

      // Remove empty groups
      updatedGroups.removeWhere((group) => group.studentIds.isEmpty);

      await _saveGroups(updatedGroups);

      emit(state.copyWith(
        groups: updatedGroups,
        isSelectionMode: false,
        selectedIds: {},
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to remove from group: $e',
      ));
    }
  }

  Future<void> _loadGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? groupsJson = prefs.getString(_groupsKey);
      
      if (groupsJson != null) {
        final List<dynamic> decodedGroups = jsonDecode(groupsJson);
        final groups = decodedGroups.map((groupData) {
          return GroupModel(
            id: groupData['id'],
            title: groupData['title'],
            icon: IconData(groupData['icon'], fontFamily: 'MaterialIcons'),
            studentIds: (groupData['studentIds'] as List<dynamic>)
                .map((id) => id as int)
                .toSet(),
          );
        }).toList();

        emit(state.copyWith(groups: groups));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load groups: $e'));
    }
  }

  Future<void> _saveGroups(List<GroupModel> groups) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final groupsJson = jsonEncode(groups.map((group) => {
            'id': group.id,
            'title': group.title,
            'icon': group.icon.codePoint,
            'studentIds': group.studentIds.toList(),
          }).toList());
      await prefs.setString(_groupsKey, groupsJson);
    } catch (e) {
      rethrow;
    }
  }
}