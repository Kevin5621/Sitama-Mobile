import 'package:flutter/widgets.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/internship_section.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/score_section.dart';

class InfoBoxes extends StatelessWidget {
  final List<InternshipStudentEntity> internships;

  const InfoBoxes({
    Key? key,
    required this.internships,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final internship = internships[index];
              return InternshipBox(
                index: index,
                internship: internship,
              );
            },
            shrinkWrap: true,
            itemCount: internships.length,
          ),
          SizedBox(height: 16),
          ScoreBox(),
        ],
      ),
    );
  }
}