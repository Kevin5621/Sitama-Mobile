import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/internship_section.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/internship_status.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/score_section.dart';

class InfoBoxes extends StatelessWidget {
  final List<InternshipStudentEntity> internships;
  final DetailStudentEntity students;
  final int id;

  const InfoBoxes({
    super.key,
    required this.internships,
    required this.students,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailStudentDisplayCubit, DetailStudentDisplayState>(
      builder: (context, state) {
        if (state is DetailLoaded) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemCount: internships.length,
                  itemBuilder: (context, index) {
                    final internship = internships[index];
                    
                    return Column(
                      children: [
                        if (index == 0)
                          InternshipStatusBox(
                            students: [students],
                            index: index,
                          ),
                        const SizedBox(height: 8),
                        InternshipBox(
                          index: index,
                          internship: internship,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Ubah kondisi pengecekan
                if (state.isInternshipFinished) 
                  ScoreBox(
                    id: id,
                    assessments: students.assessments,
                    average_all_assessments: students.average_all_assessments,
                  )
                else
                  _buildPendingScoreBox(context),
              ],
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  // New method to build a placeholder for ScoreBox
  Widget _buildPendingScoreBox(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.lock_outline,
            color: colorScheme.onSurfaceVariant,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Selesaikan Status Magang untuk Mengakses Nilai',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}