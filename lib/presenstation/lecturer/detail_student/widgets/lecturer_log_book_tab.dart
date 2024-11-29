// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/common/widgets/date_relative_time.dart';
import 'package:sistem_magang/data/models/log_book.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/domain/usecases/lecturer/update_status_logbook.dart';
import 'package:sistem_magang/service_locator.dart';

class LecturerLogBookTab extends StatelessWidget {
  final List<LogBookEntity> logBooks;
  final int student_id;

  
  const LecturerLogBookTab({
    super.key, 
    required this.logBooks, 
    required this.student_id});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: logBooks.length,
      itemBuilder: (context, index) {
        return LogBookCard(
          logBook: logBooks[index],
          student_id: student_id,
        );
      },
    );
  }
}

class LogBookCard extends StatefulWidget {
  final LogBookEntity logBook;
  final int student_id;

  const LogBookCard({
    super.key,
    required this.logBook,
    required this.student_id,
  });

  @override
  _LogBookCardState createState() => _LogBookCardState();
}

class _LogBookCardState extends State<LogBookCard> {
  final TextEditingController _lecturerNote = TextEditingController();

  void _submitNote() {
    final buttonCubit = ButtonStateCubit();
    
    // Tampilkan konfirmasi dialog
    CustomAlertDialog.showConfirmation(
      context: context,
      title: 'Konfirmasi',
      message: 'Apakah Anda yakin ingin mengirim catatan ini?',
      icon: Icons.note_add,
      iconColor: Colors.blue,
    ).then((confirmed) {
      if (confirmed == true) {
        buttonCubit.excute(
          usecase: sl<UpdateLogBookNoteUseCase>(),   
          params: UpdateLogBookReqParams(
            id: widget.logBook.id,
            lecturer_note: _lecturerNote.text
          ),
        );

        buttonCubit.stream.listen((state) {
          if (state is ButtonSuccessState) {
            _showSuccessDialog();
          }
          
          if (state is ButtonFailurState) {
            _showErrorDialog(state.errorMessage);
          }
        });
      }
    });
  }

  void _showSuccessDialog() {
    CustomAlertDialog.showSuccess(
      context: context,
      title: 'Berhasil',
      message: 'Berhasil menambahkan catatan log book',
    );
  }

  void _showErrorDialog(String errorMessage) {
    CustomAlertDialog.showError(
      context: context,
      title: 'Gagal',
      message: errorMessage,
    );
  }

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
          title: Text(
            widget.logBook.title,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            RelativeTimeUtil.getRelativeTime(widget.logBook.date),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          children: [
            _buildCardContent(colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktivitas:',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.logBook.activity,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),
          if (widget.logBook.lecturer_note.isNotEmpty) ...[
            Text(
              'Catatan Anda:',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.logBook.lecturer_note,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            'Tambah Catatan:',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _lecturerNote,
            decoration: InputDecoration(
              hintText: 'Masukkan catatan...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: Icon(Icons.send, color: colorScheme.onPrimary, size: 16),
              label: Text(
                'Kirim',
                style: TextStyle(color: colorScheme.onPrimary),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
              ),
              onPressed: _submitNote,
            ),
          ),
        ],
      ),
    );
  }
}