import 'package:flutter/material.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';

class LecturerLogBookTab extends StatelessWidget {
  final List<LogBookEntity> logBooks;
  
  const LecturerLogBookTab({super.key, required this.logBooks});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: logBooks.length,
      itemBuilder: (context, index) {
        return LogBookCard(
          logBook: logBooks[index],
          colorScheme: colorScheme,
        );
      },
    );
  }
}

class LogBookCard extends StatefulWidget {
  final LogBookEntity logBook;
  final ColorScheme colorScheme;

  const LogBookCard({
    super.key,
    required this.logBook,
    required this.colorScheme,
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
    return Card(
      margin: const EdgeInsets.all(8),
      color: widget.colorScheme.surface,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          textTheme: Theme.of(context).textTheme.copyWith(
            bodyMedium: TextStyle(color: widget.colorScheme.onSurface),
          ),
        ),
        child: ExpansionTile(
          title: Text(
            widget.logBook.title,
            style: TextStyle(color: widget.colorScheme.onSurface),
          ),
          subtitle: Text(
            'Date: ${widget.logBook.date}',
            style: TextStyle(color: widget.colorScheme.onSurfaceVariant),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.logBook.activity,
                    style: TextStyle(color: widget.colorScheme.onBackground),
                  ),
                  const SizedBox(height: 16),
                  // Existing Note Section
                  if (widget.logBook.lecturer_note.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Catatan Anda:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(widget.logBook.lecturer_note),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Note Input Section
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan catatan...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _submitNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.colorScheme.primary,
                        foregroundColor: widget.colorScheme.onPrimary,
                      ),
                      child: const Text('Kirim'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}