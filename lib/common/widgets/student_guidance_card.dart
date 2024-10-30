import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


// import 'dart:html' as html;
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/presenstation/general/pdf_viewer/pages/pdf_viewer.dart';
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
    Key? key,
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.description,
    required this.lecturerNote,
    required this.nameFile,
    required this.curentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      color: status == GuidanceStatus.rejected
          ? AppColors.danger500
          : AppColors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: _getStatusIcon(),
          title: Text(title),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(date)),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(description, textAlign: TextAlign.left),
                  ),
                  if (lecturerNote != "tidak ada catatan") ...[
                    const SizedBox(height: 16),
                    Text('Catatan Dosen :'),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(lecturerNote, textAlign: TextAlign.left),
                    ),
                  ],
                  if (nameFile != "tidak ada file") ...[
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        if (kIsWeb) {
                          // html.window.open(nameFile, "_blank");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PDFViewerPage(pdfUrl: nameFile),
                            ),
                          );
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.picture_as_pdf_rounded,
                            size: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text("File Bimbingan"),
                      ),
                    ),
                  ],
                  if (status != GuidanceStatus.approved) ...[
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColors.info,
                                size: 18,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: AppColors.info,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                color: AppColors.danger,
                                size: 18,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: AppColors.danger,
                                ),
                              )
                            ],
                          ),
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

  Widget _getStatusIcon() {
    switch (status) {
      case GuidanceStatus.approved:
        return const Icon(Icons.check_circle, color: AppColors.success);
      case GuidanceStatus.inProgress:
        return const Icon(Icons.remove_circle, color: AppColors.gray);
      case GuidanceStatus.rejected:
        return const Icon(Icons.error, color: AppColors.danger);
      case GuidanceStatus.updated:
        return const Icon(Icons.help, color: AppColors.warning);
    }
  }
}