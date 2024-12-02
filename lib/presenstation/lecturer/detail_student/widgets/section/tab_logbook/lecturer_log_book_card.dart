// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/bloc/bloc/notification_bloc.dart';
import 'package:sistem_magang/common/bloc/bloc/notification_event.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/common/widgets/date_relative_time.dart';
import 'package:sistem_magang/data/models/log_book.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/domain/usecases/lecturer/update_status_logbook.dart';
import 'package:sistem_magang/service_locator.dart';

// Widget to display each log book entry
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

// Widget to display the content of the log book
class LogBookContent extends StatelessWidget {
  final LogBookEntity logBook;
  final TextEditingController lecturerNote;
  final int student_id;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const LogBookContent({
    super.key,
    required this.logBook,
    required this.lecturerNote,
    required this.student_id,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Aktivitas:', logBook.activity),
          const SizedBox(height: 16),
          _buildSection('Catatan Anda:', logBook.lecturer_note),
          const SizedBox(height: 16),
          _buildNoteField(), // Changed to use a separate method for the note field
          const SizedBox(height: 16),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  // Method to build the note input field
  Widget _buildNoteField() {
    return TextField(
      controller: lecturerNote,
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.send, color: colorScheme.onPrimary, size: 16),
          label: Text('Kirim', style: TextStyle(color: colorScheme.onPrimary)),
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary),
          onPressed: () => _showConfirmationDialog(context),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    CustomAlertDialog.showConfirmation(
      context: context,
      title: 'Konfirmasi',
      message: 'Apakah Anda yakin ingin mengirim catatan ini?',
      icon: Icons.note_add,
      iconColor: Colors.blue,
    ).then((confirmed) {
      if (confirmed == true) {
        _handleConfirmation(context);
      }
    });
  }

  void _handleConfirmation(BuildContext context) {
    final buttonCubit = ButtonStateCubit();
    
    final notificationData = {
      'title': lecturerNote.text.isNotEmpty 
        ? lecturerNote.text 
        : 'Catatan baru ditambahkan pada logbook Anda',
      'message': logBook.title,
      'category': 'log_book',
      'date': DateTime.now().toIso8601String().split('T').first,
    };

    buttonCubit.excute(
      usecase: sl<UpdateLogBookNoteUseCase>(),   
      params: UpdateLogBookReqParams(
        id: logBook.id,
        lecturer_note: lecturerNote.text
      ),
    );

    buttonCubit.stream.listen((state) {
      if (state is ButtonSuccessState) {
        context.read<NotificationBloc>().add(
          SendNotification(
            notificationData: notificationData,
            userIds: {student_id},
          ),
        );
        
        _showSuccessDialog(context);
      }
      
      if (state is ButtonFailurState) {
        _showErrorDialog(context, state.errorMessage);
      }
    });
  }

  void _showSuccessDialog(BuildContext context) {
    CustomAlertDialog.showSuccess(
      context: context,
      title: 'Berhasil',
      message: 'Berhasil menambahkan catatan log book',
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    CustomAlertDialog.showError(
      context: context,
      title: 'Gagal',
      message: errorMessage,
    );
  }
}