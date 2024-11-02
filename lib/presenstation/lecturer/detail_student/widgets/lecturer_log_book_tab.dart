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
        return Card(
          margin: const EdgeInsets.all(8),
          color: colorScheme.surface, // Gunakan color scheme untuk background card
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              textTheme: Theme.of(context).textTheme.copyWith(
                bodyMedium: TextStyle(color: colorScheme.onSurface),
              ),
            ),
            child: ExpansionTile(
              title: Text(
                logBooks[index].title,
                style: TextStyle(color: colorScheme.onSurface), // Warna teks judul sesuai color scheme
              ),
              subtitle: Text(
                'Date: ${logBooks[index].date}',
                style: TextStyle(color: colorScheme.onSurfaceVariant), // Warna subtitle
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    logBooks[index].activity,
                    style: TextStyle(color: colorScheme.onBackground), // Warna teks konten sesuai color scheme
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
