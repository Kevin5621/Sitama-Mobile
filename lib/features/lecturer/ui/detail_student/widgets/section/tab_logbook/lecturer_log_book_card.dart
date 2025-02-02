// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sitama/core/shared/widgets/common/date_relative_time.dart';
import 'package:sitama/features/lecturer/ui/detail_student/widgets/section/tab_logbook/logbook_content.dart';
import 'package:sitama/features/student/domain/entities/log_book_entity.dart';

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
  bool get hasNote => 
      widget.logBook.lecturer_note.isNotEmpty && 
      widget.logBook.lecturer_note != 'tidak ada catatan';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.all(8),
      color: colorScheme.surfaceContainer,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            widget.logBook.title,
            textAlign: TextAlign.start,
          ),
          subtitle: Text(
            RelativeTimeUtil.getRelativeTime(widget.logBook.date),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withAlpha((0.7*255).round()),
            ),
            textAlign: TextAlign.start,
          ),
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: EdgeInsets.zero,
          children: [
            _buildLogBookDetails(colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildLogBookDetails(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildSection('Aktivitas:', widget.logBook.activity, textTheme),
            const SizedBox(height: 16),
            if (hasNote) _buildLecturerNote(textTheme),
            if (hasNote) const SizedBox(height: 16),
            LogBookContent(
              logBook: widget.logBook,
              student_id: widget.student_id,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildLecturerNote(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Catatan Anda:',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          Text(
            widget.logBook.lecturer_note,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}