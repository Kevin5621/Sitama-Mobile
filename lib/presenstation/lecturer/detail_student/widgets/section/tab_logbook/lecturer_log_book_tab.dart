// Main widget for displaying the list of logbook entries
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/section/tab_logbook/lecturer_log_book_card.dart';

class LecturerLogBookTab extends StatelessWidget {
  final List<LogBookEntity> logBooks;
  final int student_id;

  const LecturerLogBookTab({
    super.key, 
    required this.logBooks, 
    required this.student_id,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: logBooks.length,
      itemBuilder: (context, index) {
        return LecturerLogBookCard(
          logBook: logBooks[index],
          student_id: student_id,
        );
      },
    );
  }
}