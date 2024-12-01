// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/data/models/group.dart';
import 'selection_event.dart';
import 'selection_state.dart';

class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
  static const String _archiveKey = 'archived_students';
  static const String _groupKey = 'group_students';
  final GroupRepository _groupRepository = GroupRepository();

  SelectionBloc()
      : super(const SelectionState(
          isSelectionMode: false,
          selectedIds: {},
          archivedIds: {},
          groups: {},
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
    on<GroupSelectedItems>(_onGroupSelectedItems);
    on<UnGroupItems>(_onUnGroupItems);
    on<LoadGroupItems>(_onLoadGroupItems);
    on<DeleteGroup>(_onDeleteGroup);
    on<AddStudentToGroup>(_onAddStudentToGroup);
    on<UpdateGroup>((event, emit) {
      final updatedGroups = Map<String, GroupModel>.from(state.groups);
      updatedGroups[event.groupId] = updatedGroups[event.groupId]!.copyWith(
        title: event.title,
        iconName: _mapIconToName(event.icon),
      );
      
      emit(state.copyWith(groups: updatedGroups));
    });

    // Load archived items and groups when bloc is created
    add(LoadArchivedItems());
    add(LoadGroupItems());
  }

  // Helper method to convert IconData to iconName
  String _mapIconToName(IconData icon) {
    final iconMap = {
      Icons.group: 'group',
      Icons.person: 'person',
      Icons.school: 'school',
    };
    return iconMap[icon] ?? 'group';
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


//archive
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
  Future<void> _onLoadGroupItems(
    LoadGroupItems event,
    Emitter<SelectionState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      
      // Load both legacy and new group data
      final legacyGroupIds = await _getGroupIds();
      final groupsData = await _loadGroups();
      
      // Intelligent data migration
      if (legacyGroupIds.isNotEmpty && groupsData.isEmpty) {
        // Convert legacy group IDs to a default group
        final defaultGroup = GroupModel(
          id: 'default_migrated_group',
          title: 'Migrated Students',
          iconName: 'group', // Use iconName instead of icon
          studentIds: legacyGroupIds,
        );
        
        final initialGroups = {'default_migrated_group': defaultGroup};
        await _saveGroups(initialGroups);
        
        emit(state.copyWith(
          groups: initialGroups,
          isLoading: false,
          error: 'Migrated legacy group data',
        ));
      } else {
        emit(state.copyWith(
          groups: groupsData,
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Group load failed: ${e.toString()}',
        groups: {}, 
      ));
    }
  }

  Future<void> _onGroupSelectedItems(
    GroupSelectedItems event,
    Emitter<SelectionState> emit,
  ) async {
    if (event.studentIds.isEmpty) return;

    try {
      emit(state.copyWith(isLoading: true, error: null));

      // Generate a more unique group ID
      final String groupId = 'group_${DateTime.now().millisecondsSinceEpoch}_${event.title.hashCode}';
      
      final GroupModel newGroup = GroupModel(
        id: groupId,
        title: event.title.trim(), 
        iconName: _mapIconToName(event.icon), // Convert icon to iconName
        studentIds: Set<int>.from(event.studentIds),
      );

      final updatedGroups = Map<String, GroupModel>.from(state.groups)
        ..[groupId] = newGroup;

      await _saveGroups(updatedGroups);

      emit(state.copyWith(
        isSelectionMode: false,
        selectedIds: {},
        groups: updatedGroups,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Group creation failed: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUnGroupItems(
    UnGroupItems event,
    Emitter<SelectionState> emit,
  ) async {
    try {
      emit(state.copyWith(isLocalOperation: true));

      // Create updated groups map by removing students from all groups
      final updatedGroups = Map<String, GroupModel>.from(state.groups);
      updatedGroups.forEach((groupId, group) {
        final updatedStudentIds = Set<int>.from(group.studentIds)
          ..removeAll(event.ids);
        
        if (updatedStudentIds.isEmpty) {
          // If group becomes empty, remove it entirely
          updatedGroups.remove(groupId);
        } else {
          // Otherwise update the group with remaining students
          updatedGroups[groupId] = group.copyWith(studentIds: updatedStudentIds);
        }
      });

      // Update state immediately for UI responsiveness
      emit(state.copyWith(
        groups: updatedGroups,
        selectedIds: {},
        isSelectionMode: false,
        isLocalOperation: true,
      ));

      // Save both formats for backward compatibility
      await _saveGroups(updatedGroups);
      await _saveGroupIds(state.groupIds);

      // Final emit to confirm persistence
      emit(state.copyWith(isLocalOperation: false));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to remove items from groups: $e',
        isLocalOperation: false,
      ));
    }
  }

  // Helper methods for persisting data
  Future<Map<String, GroupModel>> _loadGroups() async {
    return await _groupRepository.loadGroups();
  }

  Future<void> _saveGroups(Map<String, GroupModel> groups) async {
    await _groupRepository.saveGroups(groups);
  }

  // Legacy methods maintained for backward compatibility
  Future<Set<int>> _getGroupIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? groupIds = prefs.getStringList(_groupKey);
      if (groupIds == null || groupIds.isEmpty) return {};
      return groupIds.map((id) => int.parse(id)).toSet();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveGroupIds(Set<int> ids) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> groupIds = ids.map((id) => id.toString()).toList();
      await prefs.setStringList(_groupKey, groupIds);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> _onDeleteGroup(
    DeleteGroup event,
    Emitter<SelectionState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      // Get the group that will be deleted
      final groupToDelete = state.groups[event.groupId];
      if (groupToDelete == null) return;

      // Create updated groups map by removing the group
      final updatedGroups = Map<String, GroupModel>.from(state.groups)
        ..remove(event.groupId);

      // Save the updated groups
      await _saveGroups(updatedGroups);

      emit(state.copyWith(
        groups: updatedGroups,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to delete group: $e',
      ));
    }
  }

  Future<void> _onAddStudentToGroup(
    AddStudentToGroup event, 
    Emitter<SelectionState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final updatedGroups = Map<String, GroupModel>.from(state.groups);
      final group = updatedGroups[event.groupId];
      
      if (group != null) {
        final updatedStudentIds = Set<int>.from(group.studentIds)
          ..add(event.studentId);
        
        updatedGroups[event.groupId] = group.copyWith(
          studentIds: updatedStudentIds,
        );
        
        // Save changes to persistent storage
        await _saveGroups(updatedGroups);
        
        emit(state.copyWith(
          groups: updatedGroups,
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to add student to group: $e',
      ));
    }
  }
}