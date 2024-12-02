import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sistem_magang/common/bloc/bloc/notification_bloc.dart';
import 'package:sistem_magang/common/bloc/bloc/notification_event.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/data/models/log_book.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/domain/usecases/lecturer/update_status_logbook.dart';
import 'package:sistem_magang/service_locator.dart';

// contains the LogBookContent widget which displays the detailed 
// content of a logbook entry, including activities, lecturer notes, and 
// functionality to add new notes.

class LogBookContent extends StatelessWidget {
  final LogBookEntity logBook;
  final int studentId;

  const LogBookContent({
    super.key,
    required this.logBook,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController lecturerNoteController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Aktivitas:', logBook.activity),
          const SizedBox(height: 16),
          _buildSection('Catatan Anda:', logBook.lecturer_note),
          const SizedBox(height: 8),
          _buildNoteField(lecturerNoteController),
          const SizedBox(height: 16),
          _buildActionButtons(context, lecturerNoteController),
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(content),
      ],
    );
  }

  Widget _buildNoteField(TextEditingController controller) {
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

  Widget _buildActionButtons(BuildContext context, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.send),
          label: Text('Kirim'),
          onPressed: () => _showConfirmationDialog(context, controller),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, TextEditingController controller) {
    CustomAlertDialog.showConfirmation(
      context: context,
      title: 'Konfirmasi',
      message: 'Apakah Anda yakin ingin mengirim catatan ini?',
      icon: Icons.note_add,
      iconColor: Colors.blue,
    ).then((confirmed) {
      if (confirmed == true) {
        _handleConfirmation(context, controller.text);
      }
    });
  }

  void _handleConfirmation(BuildContext context, String note) {
    final buttonCubit = ButtonStateCubit();

    final notificationData = {
      'title': note.isNotEmpty 
        ? note 
        : 'Catatan baru ditambahkan pada logbook Anda',
      'message': logBook.title,
      'category': 'log_book',
      'date': DateTime.now().toIso8601String().split('T').first,
    };

    buttonCubit.excute(
      usecase: sl<UpdateLogBookNoteUseCase>(),   
      params: UpdateLogBookReqParams(
        id: logBook.id,
        lecturer_note: note,
      ),
    );

    buttonCubit.stream.listen((state) {
      if (state is ButtonSuccessState) {
        // Notify the student about the new note
        context.read<NotificationBloc>().add(
          SendNotification(
            notificationData: notificationData,
            userIds: {studentId},
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