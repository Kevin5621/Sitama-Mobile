// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sitama/features/lecturer/ui/detail_student/widgets/section/tab_logbook/lecturer_log_book_card.dart';
import 'package:sitama/features/student/domain/entities/log_book_entity.dart';

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

    // Add null check
    if (logBooks.isEmpty) {
      return const Center(child: Text('Tidak ada data bimbingan'));
    }
    
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
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