// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api

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
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/section/tab_guidance/guidance_status.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/section/tab_guidance/lecturer_guidance_card_content.dart';
import 'package:sistem_magang/service_locator.dart';

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
    currentStatus = GuidanceStatusHelper.mapStringToStatus(widget.guidance.status);
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
            GuidanceCardContent(
              guidance: widget.guidance,
              currentStatus: currentStatus,
              lecturerNote: _lecturerNote,
              colorScheme: colorScheme,
              textTheme: textTheme,
              onBuildActionButtons: _buildActionButtons,
            ),
          ],
        ),
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

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.done, color: colorScheme.onPrimary, size: 16),
          label: Text('Setujui', style: TextStyle(color: colorScheme.onPrimary)),
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary),
          onPressed: () => _showConfirmationDialog(LecturerGuidanceStatus.approved),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          icon: Icon(Icons.close, color: colorScheme.onPrimary, size: 16),
          label: Text('Revisi', style: TextStyle(color: colorScheme.onPrimary)),
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary),
          onPressed: () => _showConfirmationDialog(LecturerGuidanceStatus.rejected),
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
      message: 'Apakah Anda yakin ingin ${GuidanceStatusHelper.getStatusTitle(newStatus)} bimbingan ini?',
      icon: dialogIcon,
      iconColor: dialogIconColor,
    ).then((confirmed) {
      if (confirmed == true) {
        _handleStatusUpdate(newStatus);
      }
    });
  }

  void _handleStatusUpdate(LecturerGuidanceStatus newStatus) {
    final buttonCubit = ButtonStateCubit();
    
    final notificationData = {
      'title': _lecturerNote.text.isNotEmpty 
        ? _lecturerNote.text 
        : GuidanceStatusHelper.getNotificationTitle(newStatus),
      'message': widget.guidance.title,
      'category': GuidanceStatusHelper.getNotificationCategory(newStatus),
      'date': DateTime.now().toIso8601String().split('T').first,
    };

    buttonCubit.excute(
      usecase: sl<UpdateStatusGuidanceUseCase>(),
      params: UpdateStatusGuidanceReqParams(
        id: widget.guidance.id,
        status: newStatus == LecturerGuidanceStatus.approved ? "approved" : "rejected",
        lecturer_note: _lecturerNote.text
      ),
    );

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

  @override
  void dispose() {
    _lecturerNote.dispose();
    super.dispose();
  }
}