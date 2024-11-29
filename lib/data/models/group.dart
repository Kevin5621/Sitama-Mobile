import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Group model to represent group data
class GroupModel {
  final String id;
  final String title;
  final IconData icon;
  final Set<int> studentIds;

  const GroupModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.studentIds,
  });

  // Serialization methods for SharedPreferences
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'icon': icon.codePoint,
    'studentIds': studentIds.toList(),
  };

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json['id'],
    title: json['title'],
    icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    studentIds: Set<int>.from(json['studentIds']),
  );

  // Utility method to create a copy with optional modifications
  GroupModel copyWith({
    String? id,
    String? title,
    IconData? icon,
    Set<int>? studentIds,
  }) => GroupModel(
    id: id ?? this.id,
    title: title ?? this.title,
    icon: icon ?? this.icon,
    studentIds: studentIds ?? this.studentIds,
  );
}

// Repository class for managing group persistence
class GroupRepository {
  static const String _groupsKey = 'lecturer_groups_v1';

  // Save groups to SharedPreferences
  Future<void> saveGroups(Map<String, GroupModel> groups) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final groupsJson = groups.map(
        (key, value) => MapEntry(key, value.toJson())
      );
      
      await prefs.setString(_groupsKey, jsonEncode(groupsJson));
    } catch (e) {
      debugPrint('Error saving groups: $e');
      rethrow;
    }
  }

  // Load groups from SharedPreferences
  Future<Map<String, GroupModel>> loadGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final groupsString = prefs.getString(_groupsKey);
      
      if (groupsString == null) return {};

      final Map<String, dynamic> groupsJson = 
          Map<String, dynamic>.from(jsonDecode(groupsString));
      
      return groupsJson.map(
        (key, value) => MapEntry(
          key, 
          GroupModel.fromJson(Map<String, dynamic>.from(value))
        )
      );
    } catch (e) {
      debugPrint('Error loading groups: $e');
      return {};
    }
  }

  // Delete a specific group
  Future<void> deleteGroup(String groupId) async {
    try {
      final currentGroups = await loadGroups();
      currentGroups.remove(groupId);
      await saveGroups(currentGroups);
    } catch (e) {
      debugPrint('Error deleting group: $e');
      rethrow;
    }
  }

  // Add or update a group
  Future<void> addOrUpdateGroup(GroupModel group) async {
    try {
      final currentGroups = await loadGroups();
      currentGroups[group.id] = group;
      await saveGroups(currentGroups);
    } catch (e) {
      debugPrint('Error adding/updating group: $e');
      rethrow;
    }
  }

  // Remove a student from all groups
  Future<Map<String, GroupModel>> removeStudentFromAllGroups(
    Set<int> studentIds
  ) async {
    try {
      final currentGroups = await loadGroups();
      final updatedGroups = Map<String, GroupModel>.from(currentGroups);

      updatedGroups.forEach((groupId, group) {
        final updatedStudentIds = Set<int>.from(group.studentIds)
          ..removeAll(studentIds);
        
        if (updatedStudentIds.isEmpty) {
          updatedGroups.remove(groupId);
        } else {
          updatedGroups[groupId] = group.copyWith(
            studentIds: updatedStudentIds
          );
        }
      });

      await saveGroups(updatedGroups);
      return updatedGroups;
    } catch (e) {
      debugPrint('Error removing students from groups: $e');
      rethrow;
    }
  }
}