// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sistem_magang/common/widgets/date_relative_time.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/section/tab_logbook/logbook_content.dart';

class LecturerLogBookCard extends StatefulWidget {
  final LogBookEntity logBook;
  final int student_id;

  const LecturerLogBookCard({
    super.key,
    required this.logBook,
    required this.student_id,
  });

  @override
  _LecturerLogBookCardState createState() => _LecturerLogBookCardState();
}

class _LecturerLogBookCardState extends State<LecturerLogBookCard> {
  final TextEditingController _lecturerNote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.all(8),
      color: colorScheme.surface,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(widget.logBook.title),
          subtitle: Text(
            RelativeTimeUtil.getRelativeTime(widget.logBook.date),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          children: [
            LogBookContent(
              logBook: widget.logBook,
              lecturerNote: _lecturerNote,
              student_id: widget.student_id,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ],
        ),
      ),
    );
  }
}

class NoteField extends StatelessWidget {
  final TextEditingController controller;

  const NoteField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Masukkan catatan...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      maxLines: 3,
    );
  }
}