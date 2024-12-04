import 'package:flutter/material.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/utils/seminar_scheduling/seminar_scheduling_overlay.dart';

Future<bool> showSeminarSchedulingOverlay(
  BuildContext context,
  DetailStudentEntity student,
) async {
  final result = await Navigator.of(context).push<bool>(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __) => SeminarSchedulingOverlay(
        student: student,
        onSchedulingComplete: (success) {
          Navigator.of(context).pop(success);
        },
      ),
    ),
  );
  
  return result ?? false;
}
