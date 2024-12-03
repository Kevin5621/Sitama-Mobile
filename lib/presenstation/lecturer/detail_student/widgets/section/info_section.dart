import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/domain/repository/lecturer.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/section/internship/internship_section.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/section/internship/internship_status.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/utils/score_section.dart';
import 'package:sistem_magang/service_locator.dart';

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
                        // Additional actions if needed after approval
                        Either result = await sl<LecturerRepository>()
                            .updateFinishedStudent(
                                id: id, status: !students.student.isFinished);

                        result.fold((e) {}, (_) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailStudentPage(id: id)));
                        });
                      },
                      isFinished: students.student.isFinished,
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
          ),
        ],
      ),
    );
  }
}