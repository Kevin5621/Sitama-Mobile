import 'package:flutter/material.dart';
import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'lecturer_guidance_tab.dart';

// Widget to organize and display guidance content
class LecturerGuidanceContent extends StatelessWidget {
  // List of guidance entries and student ID
  final List<GuidanceEntity> guidances;
  final int studentId;

  const LecturerGuidanceContent({
    super.key,
    required this.guidances,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    // Check if there are any guidance entries
    if (guidances.isEmpty) {
      // Display message when no guidance entries exist
      return Center(
        child: Text(
          'Belum ada bimbingan',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    // Display guidance tab with entries
    return LecturerGuidanceTab(
      guidances: guidances,
      student_id: studentId,
    );
  }
}