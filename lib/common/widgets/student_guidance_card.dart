import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/presenstation/general/pdf_viewer/pdf_viewer.dart';
import 'package:sistem_magang/presenstation/student/guidance/widgets/delete_guidance.dart';
import 'package:sistem_magang/presenstation/student/guidance/widgets/edit_guidance.dart';

enum GuidanceStatus { approved, rejected, inProgress, updated }

class GuidanceCard extends StatelessWidget {
  final int id;
  final String title;
  final DateTime date;
  final GuidanceStatus status;
  final String description;
  final String lecturerNote;
  final String nameFile;
  final int curentPage;

  const GuidanceCard({
    super.key,
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.description,
    required this.lecturerNote,
    required this.nameFile,
    required this.curentPage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      color: status == GuidanceStatus.rejected
          ? colorScheme.error
          : colorScheme.surface,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: _getStatusIcon(colorScheme),
          title: Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: status == GuidanceStatus.rejected
                  ? colorScheme.onError
                  : colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            DateFormat('dd/MM/yyyy').format(date),
            style: textTheme.bodySmall?.copyWith(
              color: status == GuidanceStatus.rejected
                  ? colorScheme.onError
                  : colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: status == GuidanceStatus.rejected
                            ? colorScheme.onError
                            : colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  if (lecturerNote != "tidak ada catatan") ...[
                    const SizedBox(height: 16),
                    Text(
                      'Catatan Dosen :',
                      style: textTheme.titleSmall?.copyWith(
                        color: status == GuidanceStatus.rejected
                            ? colorScheme.onError
                            : colorScheme.onSurface,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        lecturerNote,
                        style: textTheme.bodyMedium?.copyWith(
                          color: status == GuidanceStatus.rejected
                              ? colorScheme.onError
                              : colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                  if (nameFile != "tidak ada file") ...[
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        if (kIsWeb) {
                          // html.window.open(nameFile, "_blank");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerPage(pdfUrl: nameFile),
                            ),
                          );
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.picture_as_pdf_rounded,
                            size: 16,
                            color: status == GuidanceStatus.rejected
                                ? colorScheme.onError
                                : colorScheme.onSurface,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              color: status == GuidanceStatus.rejected
                                  ? colorScheme.onError.withOpacity(0.5)
                                  : colorScheme.outline,
                            ),
                          ),
                        ),
                        child: Text(
                          "File Bimbingan",
                          style: textTheme.bodyMedium?.copyWith(
                            color: status == GuidanceStatus.rejected
                                ? colorScheme.onError
                                : colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  if (status != GuidanceStatus.approved) ...[
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
                                return EditGuidance(
                                  id: id,
                                  title: title,
                                  date: date,
                                  description: description,
                                  curentPage: curentPage,
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
                                return DeleteGuidance(
                                  id: id,
                                  title: title,
                                  curentPage: curentPage,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
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

  Widget _getStatusIcon(ColorScheme colorScheme) {
    switch (status) {
      case GuidanceStatus.approved:
        return const Icon(Icons.check_circle, color: AppColors.lightSuccess);
      case GuidanceStatus.inProgress:
        return Icon(Icons.remove_circle,
            color: colorScheme.onSurface.withOpacity(0.5));
      case GuidanceStatus.rejected:
        return const Icon(Icons.error, color: AppColors.lightDanger);
      case GuidanceStatus.updated:
        return const Icon(Icons.add_circle, color: AppColors.lightWarning);
    }
  }
}