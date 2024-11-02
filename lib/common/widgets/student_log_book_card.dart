import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/presenstation/student/logbook/widgets/delete_log_book.dart';
import 'package:sistem_magang/presenstation/student/logbook/widgets/edit_log_book.dart';

class LogBookItem {
  final int id;
  final String title;
  final DateTime date;
  final String description;
  final int curentPage;

  LogBookItem({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.curentPage,
  });
}

class LogBookCard extends StatelessWidget {
  final LogBookItem item;

  const LogBookCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      // Menggunakan surface color dari color scheme
      color: colorScheme.surface,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          // Menggunakan warna primary untuk title
          title: Text(
            item.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          // Menggunakan warna secondary untuk subtitle
          subtitle: Text(
            DateFormat('dd/MM/yyyy').format(item.date),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EditLogBook(
                                id: item.id,
                                title: item.title,
                                date: item.date,
                                description: item.description,
                                curentPage: item.curentPage,
                              );
                            },
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DeleteLogBook(
                                id: item.id,
                                title: item.title,
                                curentPage: item.curentPage,
                              );
                            },
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: colorScheme.error,
                              size: 18,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: colorScheme.error,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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