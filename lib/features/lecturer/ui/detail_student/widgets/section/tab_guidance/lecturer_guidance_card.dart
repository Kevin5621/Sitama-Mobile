// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/core/shared/widgets/alert/alert.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state_cubit.dart';
import 'package:sitama/core/shared/widgets/common/date_relative_time.dart';
import 'package:sitama/features/lecturer/domain/usecases/update_status_guidance.dart';
import 'package:sitama/features/lecturer/ui/detail_student/pages/detail_student.dart';
import 'package:sitama/features/lecturer/ui/detail_student/widgets/section/tab_guidance/guidance_status.dart';
import 'package:sitama/features/lecturer/ui/detail_student/widgets/section/tab_guidance/lecturer_guidance_card_content.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/notification/notification_bloc.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/notification/notification_event.dart';
import 'package:sitama/features/shared/data/models/guidance.dart';
import 'package:sitama/features/student/domain/entities/guidance_entity.dart';
import 'package:sitama/service_locator.dart';

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
          : colorScheme.surfaceContainer,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: _buildLeadingIcon(colorScheme),
          title: Text(widget.guidance.title),
          subtitle: Text(
            RelativeTimeUtil.getRelativeTime(widget.guidance.date),
            style: textTheme.bodySmall?.copyWith(
            color: currentStatus == LecturerGuidanceStatus.rejected
                ? colorScheme.onError.withAlpha((0.7*255).round())
                : colorScheme.onSurface.withAlpha((0.7*255).round()),
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
        return Icon(Icons.remove_circle, color: colorScheme.onSurface.withAlpha((0.5*255).round()));
      case LecturerGuidanceStatus.rejected:
        return const Icon(Icons.error, color: AppColors.lightDanger);
      case LecturerGuidanceStatus.updated:
        return const Icon(Icons.add_circle, color: AppColors.lightWarning);
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

    buttonCubit.excute(
      usecase: sl<UpdateStatusGuidanceUseCase>(),
      params: UpdateStatusGuidanceReqParams(
        id: widget.guidance.id,
        status: newStatus == LecturerGuidanceStatus.approved ? "approved" : "rejected",
        lecturer_note: _lecturerNote.text
      ),
    );

    buttonCubit.stream.listen((state) {
      if (state is ButtonSuccessState) {
        if (!mounted) return;
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
      if (!mounted) return;
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