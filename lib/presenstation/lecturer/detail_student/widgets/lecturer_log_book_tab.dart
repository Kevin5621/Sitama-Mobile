import 'package:flutter/material.dart';
import 'package:sistem_magang/common/widgets/date_relative_time.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';

class LecturerLogBookTab extends StatelessWidget {
  final List<LogBookEntity> logBooks;
  
  const LecturerLogBookTab({super.key, required this.logBooks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: logBooks.length,
      itemBuilder: (context, index) {
        return LogBookCard(
          logBook: logBooks[index],
        );
      },
    );
  }
}

class LogBookCard extends StatefulWidget {
  final LogBookEntity logBook;

  const LogBookCard({
    super.key,
    required this.logBook,
  });

  @override
  State<LogBookCard> createState() => _LogBookCardState();
}

class _LogBookCardState extends State<LogBookCard> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submitNote() {
    if (_noteController.text.trim().isEmpty) return;
    
    // TODO: Implement API call to save the note
    print('Saving note: ${_noteController.text}');
    
    // Clear the input field after submission
    _noteController.clear();
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
            controller: _noteController,
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