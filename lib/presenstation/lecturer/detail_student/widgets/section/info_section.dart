import 'package:Sitama/presenstation/lecturer/detail_student/widgets/section/internship/internship_section.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/widgets/section/internship/internship_status.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/widgets/utils/score_section.dart';
import 'package:flutter/material.dart';
import 'package:Sitama/domain/entities/lecturer_detail_student.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/bloc/detail_student_display_cubit.dart';

class InfoBoxes extends StatelessWidget {
  final List<InternshipStudentEntity> internships;
  final DetailStudentEntity students;
  final int id;
  final bool isOffline;

  const InfoBoxes({
    super.key,
    required this.internships,
    required this.students,
    required this.id,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (internships.isEmpty)
            Text('Tidak ada data magang'),
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
                      status: internship.status,
                      onApprove: () async {
                        final cubit = context.read<DetailStudentDisplayCubit>();
                        await cubit.updateStudentStatus(
                          id: id,
                          status: !students.student.isFinished,
                        );
                      },
                      isFinished: students.student.isFinished,
                      isOffline: isOffline,
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
          ScoreBox(
            id: id,
            assessments: students.assessments,
            average_all_assessments: students.average_all_assessments,
            isFinished: students.student.isFinished,
            isOffline: isOffline,
          ),
        ],
      ),
    );
  }
}