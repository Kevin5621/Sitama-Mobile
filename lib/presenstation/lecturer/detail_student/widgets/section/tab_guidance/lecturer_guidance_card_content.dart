// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Sitama/domain/entities/guidance_entity.dart';
import 'package:Sitama/presenstation/general/pdf_viewer/pdf_viewer.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/widgets/section/tab_guidance/guidance_status.dart';

class GuidanceCardContent extends StatelessWidget {
  final GuidanceEntity guidance;
  final LecturerGuidanceStatus currentStatus;
  final TextEditingController lecturerNote;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final Function(ColorScheme) onBuildActionButtons;

  const GuidanceCardContent({
    super.key,
    required this.guidance,
    required this.currentStatus,
    required this.lecturerNote,
    required this.colorScheme,
    required this.textTheme,
    required this.onBuildActionButtons,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          if (guidance.name_file != "tidak ada file") ...[
            _buildFileAttachment(context),
            const SizedBox(height: 16),
          ],
          _buildStudentNote(),
          const SizedBox(height: 16),
          if (currentStatus != LecturerGuidanceStatus.inProgress) ...[
            _buildLecturerNote(),
          ],
          if (currentStatus != LecturerGuidanceStatus.approved &&
              currentStatus != LecturerGuidanceStatus.rejected) ...[
            const SizedBox(height: 16),
            _buildRevisionField(),
            const SizedBox(height: 16),
            onBuildActionButtons(colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildFileAttachment(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!kIsWeb) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerPage(pdfUrl: guidance.name_file),
            ),
          );
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.picture_as_pdf_rounded,
            size: 16,
            color: currentStatus == LecturerGuidanceStatus.rejected
                ? colorScheme.onError
                : colorScheme.onSurface,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.download,
              size: 16,
              color: currentStatus == LecturerGuidanceStatus.rejected
                  ? colorScheme.onError
                  : colorScheme.onSurface,
            ),
            onPressed: () => PDFViewerPage.downloadPDF(context, guidance.name_file),
          ),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
              color: currentStatus == LecturerGuidanceStatus.rejected
                  ? colorScheme.onError.withOpacity(0.5)
                  : colorScheme.outline,
            ),
          ),
        ),
        child: Text(
          "File Bimbingan",
          style: textTheme.bodyMedium?.copyWith(
            color: currentStatus == LecturerGuidanceStatus.rejected
                ? colorScheme.onError
                : colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildStudentNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catatan Mahasiswa:',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          guidance.activity,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildLecturerNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catatan Anda:',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          guidance.lecturer_note,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildRevisionField() {
    return TextField(
      controller: lecturerNote,
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
}