// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/bloc/bloc/notification_bloc.dart';
import 'package:sistem_magang/common/bloc/bloc/notification_event.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/common/widgets/date_relative_time.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/domain/usecases/lecturer/update_status_guidance.dart';
import 'package:sistem_magang/presenstation/general/pdf_viewer/pdf_viewer.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/service_locator.dart';

class LecturerGuidanceTab extends StatelessWidget {
  final List<GuidanceEntity> guidances;
  final int student_id;

  const LecturerGuidanceTab({
    super.key, 
    required this.guidances, 
    required this.student_id});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: guidances.length,
      itemBuilder: (context, index) {
        return LecturerGuidanceCard(
          guidance: guidances[index],
          student_id: student_id,
        );
      },
    );
  }
}

enum LecturerGuidanceStatus { approved, rejected, inProgress, updated }

class LecturerGuidanceCard extends StatefulWidget {
  final GuidanceEntity guidance;
  final int student_id;

  const LecturerGuidanceCard({
    super.key,
    required this.guidance,
    required this.student_id,
  });

  @override
  _LecturerGuidanceCardState createState() => _LecturerGuidanceCardState();
}

class _LecturerGuidanceCardState extends State<LecturerGuidanceCard> {
  late LecturerGuidanceStatus currentStatus;
  final TextEditingController _lecturerNote = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentStatus = widget.guidance.status == 'approved'
        ? LecturerGuidanceStatus.approved
        : widget.guidance.status == 'in-progress'
            ? LecturerGuidanceStatus.inProgress
            : widget.guidance.status == 'rejected'
                ? LecturerGuidanceStatus.rejected
                : LecturerGuidanceStatus.updated;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.all(8),
      color: currentStatus == LecturerGuidanceStatus.rejected
          ? colorScheme.error
          : colorScheme.surface,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: _buildLeadingIcon(colorScheme),
          title: Text(widget.guidance.title),
          subtitle: Text(
            RelativeTimeUtil.getRelativeTime(widget.guidance.date),
            style: textTheme.bodySmall?.copyWith(
              color: currentStatus == LecturerGuidanceStatus.rejected
                  ? colorScheme.onError.withOpacity(0.7)
                  : colorScheme.onSurface.withOpacity(0.7),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        if (widget.guidance.name_file != "tidak ada file") ...[
          InkWell(
            onTap: () {
              if (kIsWeb) {
                // Handle web viewing
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerPage(pdfUrl: widget.guidance.name_file),
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
                  onPressed: () => PDFViewerPage.downloadPDF(context, widget.guidance.name_file),
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
          ),
          const SizedBox(height: 16),
        ],
        Text(
          'Catatan Mahasiswa:',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.guidance.activity,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 16),
        if (currentStatus != LecturerGuidanceStatus.inProgress) ...[
          Text(
            'Catatan Anda:',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.guidance.lecturer_note,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
        ],
        if (currentStatus != LecturerGuidanceStatus.approved &&
            currentStatus != LecturerGuidanceStatus.rejected) ...[
          const SizedBox(height: 16),
          _buildRevisionField(),
          const SizedBox(height: 16),
          _buildActionButtons(colorScheme),
        ],
      ],
    ),
  );
}

  Widget _buildLeadingIcon(ColorScheme colorScheme) {
    switch (currentStatus) {
      case LecturerGuidanceStatus.approved:
        return const Icon(Icons.check_circle, color: AppColors.lightSuccess);
      case LecturerGuidanceStatus.inProgress:
        return Icon(Icons.remove_circle, color: colorScheme.onSurface.withOpacity(0.5));
      case LecturerGuidanceStatus.rejected:
        return const Icon(Icons.error, color: AppColors.lightDanger);
      case LecturerGuidanceStatus.updated:
        return const Icon(Icons.add_circle, color: AppColors.lightWarning);
      default:
        return Icon(Icons.circle, color: colorScheme.onSurface);
    }
  }

  Widget _buildRevisionField() {
    return TextField(
      controller: _lecturerNote,
      decoration: InputDecoration(
        hintText: 'Masukkan catatan...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      maxLines: 3,
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.done, color: colorScheme.onPrimary, size: 16),
          label: Text('Setujui', style: TextStyle(color: colorScheme.onPrimary)),
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary),
          onPressed: () =>
              _showConfirmationDialog(LecturerGuidanceStatus.approved),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          icon: Icon(Icons.close, color: colorScheme.onPrimary, size: 16),
          label: Text('Revisi', style: TextStyle(color: colorScheme.onPrimary)),
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary),
          onPressed: () =>
              _showConfirmationDialog(LecturerGuidanceStatus.rejected),
        ),
      ],
    );
  }

  void _showConfirmationDialog(LecturerGuidanceStatus newStatus) {
    final colorScheme = Theme.of(context).colorScheme;
    
    IconData dialogIcon;
    Color dialogIconColor;

    switch (newStatus) {
      case LecturerGuidanceStatus.approved:
        dialogIcon = Icons.check_circle;
        dialogIconColor = AppColors.lightSuccess;
        break;
      case LecturerGuidanceStatus.rejected:
        dialogIcon = Icons.error;
        dialogIconColor = AppColors.lightDanger;
        break;
      default:
        dialogIcon = Icons.help_outline;
        dialogIconColor = colorScheme.primary;
    }

    CustomAlertDialog.showConfirmation(
      context: context,
      title: 'Konfirmasi',
      message: 'Apakah Anda yakin ingin ${newStatus == LecturerGuidanceStatus.approved ? 'menyetujui' : 'merevisi'} bimbingan ini?',
      icon: dialogIcon,
      iconColor: dialogIconColor,
    ).then((confirmed) {
      if (confirmed == true) {
        final buttonCubit = ButtonStateCubit();
        
        // Prepare notification data
        final notificationData = {
          'title': widget.guidance.title,
          'message': _lecturerNote.text.isNotEmpty 
            ? _lecturerNote.text 
            : (newStatus == LecturerGuidanceStatus.approved 
              ? 'Bimbingan Anda Disetujui' 
              : 'Bimbingan Anda Perlu Direvisi'),
          'category': newStatus == LecturerGuidanceStatus.approved 
            ? 'guidance' 
            : 'revision',
          'date': DateTime.now().toIso8601String().split('T').first,
        };

        buttonCubit.excute(
          usecase: sl<UpdateStatusGuidanceUseCase>(),
          params: UpdateStatusGuidanceReqParams(
            id: widget.guidance.id,
            status: newStatus == LecturerGuidanceStatus.approved 
              ? "approved" 
              : "rejected",
            lecturer_note: _lecturerNote.text
          ),
        );

        // Send notification
        context.read<NotificationBloc>().add(
          SendNotification(
            notificationData: notificationData,
            userIds: {widget.student_id},
          ),
        );

        buttonCubit.stream.listen((state) {
          if (state is ButtonSuccessState) {
            _showSuccessAndNavigate();
          }
          
          if (state is ButtonFailurState) {
            _showErrorDialog(state.errorMessage);
          }
        });
      }
    });
  }

  void _showSuccessAndNavigate() {
    CustomAlertDialog.showSuccess(
      context: context,
      title: 'Berhasil',
      message: 'Berhasil mengupdate status bimbingan',
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
}