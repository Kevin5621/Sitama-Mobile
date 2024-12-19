import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/common/bloc/bloc/notification_bloc.dart';
import 'package:Sitama/common/bloc/bloc/notification_event.dart';
import 'package:Sitama/common/bloc/button/button_state.dart';
import 'package:Sitama/common/bloc/button/button_state_cubit.dart';
import 'package:Sitama/common/widgets/alert.dart';
import 'package:Sitama/data/models/log_book.dart';
import 'package:Sitama/domain/entities/log_book_entity.dart';
import 'package:Sitama/domain/usecases/lecturer/update_status_logbook.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:Sitama/service_locator.dart';

class LogBookContent extends StatefulWidget {
  final LogBookEntity logBook;
  final int student_id;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const LogBookContent({
    super.key,
    required this.logBook,
    required this.student_id,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  _LogBookContentState createState() => _LogBookContentState();
}

class _LogBookContentState extends State<LogBookContent> {
  final TextEditingController _lecturerNote = TextEditingController();

  bool get hasExistingNote => 
      widget.logBook.lecturer_note.isNotEmpty && 
      widget.logBook.lecturer_note != 'tidak ada catatan';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!hasExistingNote) ...[
          _buildNoteField(),
          const SizedBox(height: 16),
          _buildActionButtons(widget.colorScheme),
        ],
      ],
    );
  }

  Widget _buildNoteField() {
    return TextField(
      controller: _lecturerNote,
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

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.send, color: colorScheme.onPrimary, size: 16),
          label: Text('Kirim', style: TextStyle(color: colorScheme.onPrimary)),
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary),
          onPressed: () => _showConfirmationDialog(),
        ),
      ],
    );
  }

  void _showConfirmationDialog() {
    CustomAlertDialog.showConfirmation(
      context: context,
      title: 'Konfirmasi',
      message: 'Apakah Anda yakin ingin mengirim catatan ini?',
      icon: Icons.note_add,
      iconColor: Colors.blue,
    ).then((confirmed) {
      if (confirmed == true) {
        _handleConfirmation();
      }
    });
  }

  void _handleConfirmation() {
    final buttonCubit = ButtonStateCubit();
    
    if (_lecturerNote.text.trim().isEmpty) {
      _showErrorDialog('Catatan tidak boleh kosong');
      return;
    }

    final notificationData = {
      'message': widget.logBook.title,
      'detailText': _lecturerNote,
      'category': 'log_book',
      'date': DateTime.now().toIso8601String().split('T').first,
    };

    buttonCubit.excute(
      usecase: sl<UpdateLogBookNoteUseCase>(),   
      params: UpdateLogBookReqParams(
        id: widget.logBook.id,
        lecturer_note: _lecturerNote.text.trim(),
      ),
    );

    buttonCubit.stream.listen((state) {
      if (state is ButtonSuccessState) {
        context.read<NotificationBloc>().add(
          SendNotification(
            notificationData: notificationData,
            userIds: {widget.student_id},
          ),
        );
        _showSuccessDialog();
      }
      
      if (state is ButtonFailurState) {
        _showErrorDialog(state.errorMessage);
      }
    });
  }

  void _showSuccessDialog() {
    CustomAlertDialog.showSuccess(
      context: context,
      title: 'Berhasil',
      message: 'Berhasil menambahkan catatan log book',
    ).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DetailStudentPage(id: widget.student_id),
        ),
      );
    });
  }
  
  void _showErrorDialog(String errorMessage) {
    CustomAlertDialog.showError(
      context: context,
      title: 'Gagal',
      message: errorMessage,
    );
  }

  @override
  void dispose() {
    _lecturerNote.dispose();
    super.dispose();
  }
}