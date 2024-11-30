import 'package:flutter/widgets.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/internship_section.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/internship_status.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/score_section.dart';

class InfoBoxes extends StatelessWidget {
  final List<InternshipStudentEntity> internships;
  final DetailStudentEntity students;
  final int id;

  const InfoBoxes({
    Key? key,
    required this.internships,
    required this.students,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      status: internship.status,
                      onApprove: () {
                        // Additional actions if needed after approval
                      },
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
          ),
        ],
      ),
    );
  }
}
