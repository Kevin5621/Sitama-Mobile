// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sitama/domain/entities/guidance_entity.dart';
import 'lecturer_guidance_card.dart';

// Widget to display a list of guidance entries for a lecturer
class LecturerGuidanceTab extends StatelessWidget {
  final List<GuidanceEntity> guidances;
  final int student_id;

  const LecturerGuidanceTab({
    super.key,
    required this.guidances,
    required this.student_id,
  });

  @override
  Widget build(BuildContext context) {
    
    // Add null check
    if (guidances.isEmpty) {
      return const Center(child: Text('Tidak ada data bimbingan'));
    }

    // Create a scrollable list of guidance cards
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: guidances.length,
      itemBuilder: (context, index) {
        // Generate a card for each guidance entry
        return LecturerGuidanceCard(
          guidance: guidances[index],
          student_id: student_id,
        );
      },
    );
  }
}