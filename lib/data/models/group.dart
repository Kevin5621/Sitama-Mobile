import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupModel {
  final String id;
  final String title;
  final String iconName; 
  final Color iconColor;
  final Set<int> studentIds;

  const GroupModel({
    required this.id,
    required this.title,
    required this.iconName,
    this.iconColor = Colors.blue,
    required this.studentIds,
  });

  // Static map that can be easily extended
  static final Map<String, IconData> iconMap = {
    'group': Icons.group,
    'school': Icons.school,
    'work': Icons.work,
    'star': Icons.star,
    'favorite': Icons.favorite,
    'rocket_launch': Icons.rocket_launch,
    'psychology': Icons.psychology,
    'science': Icons.science,
  };

  // Predefined color palette
  static final List<Color> colorPalette = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  // Getter to retrieve the icon associated with the group model
  IconData get icon {
    return iconMap[iconName] ?? Icons.group;
  }

  // Additional method to retrieve all available icons
  static Map<String, IconData> get availableIcons => Map.unmodifiable(iconMap);

  // Serialization methods for SharedPreferences
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'iconName': iconName,
        'iconColor': iconColor.value, // Store color as integer
        'studentIds': studentIds.toList(),
      };

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    try {
      return GroupModel(
        id: json['id'] as String,
        title: json['title'] as String,
        iconName: json['iconName'] as String,
        iconColor: Color(json['iconColor'] ?? Colors.blue.value), // Provide default if not found
        studentIds: Set<int>.from(json['studentIds']),
      );
    } catch (e) {
      debugPrint('Error parsing GroupModel: $e');
      rethrow;
    }
  }

  // Utility method to create a copy with optional modifications
  GroupModel copyWith({
    String? id,
    String? title,
    String? iconName,
    Color? iconColor,
    Set<int>? studentIds,
  }) =>
      GroupModel(
        id: id ?? this.id,
        title: title ?? this.title,
        iconName: iconName ?? this.iconName,
        iconColor: iconColor ?? this.iconColor,
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
        (key, value) => MapEntry(key, value.toJson()),
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

      if (groupsString == null || groupsString.isEmpty) {
        debugPrint('No saved groups found. Returning empty map.');
        return {};
      }

      try {
        final Map<String, dynamic> groupsJson = 
            Map<String, dynamic>.from(jsonDecode(groupsString));
        
        return groupsJson.map(
          (key, value) => MapEntry(
            key,
            GroupModel.fromJson(Map<String, dynamic>.from(value)),
          ),
        );
      } on FormatException catch (e) {
        debugPrint('JSON Parsing Error: $e');
        // Optional: Clear corrupted data
        await prefs.remove(_groupsKey);
        return {};
      }
    } catch (e) {
      debugPrint('Unexpected error loading groups: $e');
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
      Set<int> studentIds) async {
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
            studentIds: updatedStudentIds,
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
