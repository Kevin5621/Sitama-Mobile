import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Sitama/core/config/themes/app_color.dart';
import 'package:Sitama/presenstation/student/logbook/widgets/delete_log_book.dart';
import 'package:Sitama/presenstation/student/logbook/widgets/edit_log_book.dart';

/// Key Features:
/// - Displays the logbook entry title and date in a visually appealing card.
/// - Expands to show detailed information, including description and lecturer notes.
/// - Provides action buttons for editing and deleting the entry, with confirmation dialogs.
/// - Uses theming for consistent styling and color management based on the app's theme.

class LogBookItem {
  final int id;
  final String title;
  final DateTime date;
  final String description;
  final String lecturerNote; 
  final int curentPage;

  LogBookItem({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.lecturerNote, 
    required this.curentPage,
  });
}


class LogBookCard extends StatelessWidget {
  final LogBookItem item;

  const LogBookCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: colorScheme.surface,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            item.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
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
                  const SizedBox(height: 16),
                  Text(
                    'Catatan Dosen :',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (item.lecturerNote.isNotEmpty && item.lecturerNote != "tidak ada catatan") ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.lecturerNote,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ] else ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tidak ada catatan',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildActionButton(
                        context: context,
                        icon: Icons.edit,
                        label: 'Edit',
                        color: colorScheme.primary,
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
                      ),
                      const SizedBox(width: 10),
                      _buildActionButton(
                        context: context,
                        icon: Icons.delete,
                        label: 'Delete',
                        color: AppColors.lightDanger,
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

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
            ),
          )
        ],
      ),
    );
  }
}