import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';

class ActivityHelper {
  static IconData getActivityIcon(String activity) {
    switch (activity) {
      case 'is_in_progress':
        return Icons.visibility_off;
      case 'is_updated':
        return Icons.help;
      case 'is_rejected':
        return Icons.edit_document;
      default:
        return Icons.circle;
    }
  }

  static Color getActivityColor(String activity) {
    switch (activity) {
      case 'is_in_progress':
        return AppColors.lightGray;
      case 'is_updated':
        return AppColors.lightWarning;
      case 'is_rejected':
        return AppColors.lightDanger;
      default:
        return AppColors.lightGray;
    }
  }

  // Widget untuk menampilkan activity icons dalam stack
  static Widget buildActivityIconsStack({
      required List<String> activities,
      required BuildContext context,
      Color? borderColor,
      bool isSelected = false,
    }) {
      if (activities.isEmpty) return const SizedBox.shrink();

      return Positioned(
        top: 8,
        right: 8,
        child: SizedBox(
          // Menggunakan max() untuk memastikan lebar minimal adalah 24.0
          width: max(24.0, activities.length * 20.0),
          height: 24,
          child: Stack(
            alignment: Alignment.centerRight,
            children: activities
                .asMap()
                .entries
                .map((entry) {
                  final activity = entry.value;
                  return Positioned(
                    right: entry.key * 15.0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: getActivityColor(activity),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor ?? 
                            (isSelected 
                              ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.8)
                              : Theme.of(context).colorScheme.surface),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          getActivityIcon(activity),
                          size: 14,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  );
                })
                .toList()
                .reversed
                .toList(),
          ),
        ),
      );
    }

  // Helper method untuk mendapatkan active activities dari student
  static List<String> getActiveActivities(Map<String, bool> activities) {
    List<String> activeActivities = [];
    activities.forEach((key, value) {
      if (value == true) {
        activeActivities.add(key);
      }
    });
    return activeActivities;
  }

  // Helper method untuk mendapatkan activities dari group
  static List<String> getGroupActivities(List<LecturerStudentsEntity> students) {
    return students.expand((student) {
      return student.activities.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key);
    }).toSet().toList();
  }
}