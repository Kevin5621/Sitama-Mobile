import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SelectionEvent extends Equatable {
  const SelectionEvent();

  @override
  List<Object> get props => [];
}

class ToggleSelectionMode extends SelectionEvent {}

class ToggleItemSelection extends SelectionEvent {
  final int id;

  const ToggleItemSelection(this.id);

  @override
  List<Object> get props => [id];
}

class SelectAll extends SelectionEvent {
  final Set<int> ids;

  const SelectAll(this.ids);

  @override
  List<Object> get props => [ids];
}

class DeselectAll extends SelectionEvent {}

class SendMessage extends SelectionEvent {
  final String message;

  const SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

//archive
class ArchiveSelectedItems extends SelectionEvent {}

class UnarchiveItems extends SelectionEvent {
  final Set<int> ids;
  
  const UnarchiveItems(this.ids);

  @override
  List<Object> get props => [ids];
}

class LoadArchivedItems extends SelectionEvent {}

//group
class LoadGroupItems extends SelectionEvent {}

class GroupSelectedItems extends SelectionEvent {
  final String title;
  final IconData icon;
  final Set<int> studentIds;

  const GroupSelectedItems({
    required this.title,
    required this.icon,
    required this.studentIds,
  });

  @override
  List<Object> get props => [title, icon, studentIds];
}

class UnGroupItems extends SelectionEvent {
  final Set<int> ids;
  
  const UnGroupItems(this.ids);

  @override
  List<Object> get props => [ids];
}

class ClearSelectionMode extends SelectionEvent {}

class DeleteGroup extends SelectionEvent {
  final String groupId;
  
  const DeleteGroup(this.groupId);

  @override
  List<Object> get props => [groupId];
}

class UpdateGroup extends SelectionEvent {
  final String groupId;
  final String title;
  final IconData icon;

  const UpdateGroup({
    required this.groupId,
    required this.title,
    required this.icon,
  });
  
  @override
  List<Object> get props => [groupId, title, icon];
}

class AddStudentToGroup extends SelectionEvent {
  final String groupId;
  final int studentId;

  const AddStudentToGroup({
    required this.groupId,
    required this.studentId,
  });

  @override
  List<Object> get props => [groupId, studentId];
}

class RemoveStudentFromGroup extends SelectionEvent {
  final String groupId;
  final int studentId;

  const RemoveStudentFromGroup({
    required this.groupId,
    required this.studentId,
  });

  @override
  List<Object> get props => [groupId, studentId];
}