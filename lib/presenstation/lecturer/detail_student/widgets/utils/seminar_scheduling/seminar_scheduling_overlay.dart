import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/common/bloc/bloc/notification_bloc.dart';
import 'package:sistem_magang/common/bloc/bloc/notification_event.dart';
import 'package:sistem_magang/common/widgets/custom_snackbar.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/utils/seminar_scheduling/seminar_datePicker.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/utils/seminar_scheduling/seminar_message_field.dart';

class SeminarSchedulingOverlay extends StatefulWidget {
  final DetailStudentEntity student;
  final Function(bool) onSchedulingComplete;

  const SeminarSchedulingOverlay({
    Key? key,
    required this.student,
    required this.onSchedulingComplete,
  }) : super(key: key);

  @override
  State<SeminarSchedulingOverlay> createState() => _SeminarSchedulingOverlayState();
}

class _SeminarSchedulingOverlayState extends State<SeminarSchedulingOverlay> {
  final TextEditingController messageController = TextEditingController();
  final ValueNotifier<DateTime?> selectedDateNotifier = ValueNotifier<DateTime?>(null);

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void _handleScheduling() {
    final selectedDate = selectedDateNotifier.value;
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Pilih tanggal seminar terlebih dahulu',
          icon: Icons.error_outline,
          backgroundColor: Colors.red.shade800,
        ),
      );
      return;
    }

    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    final combinedMessage = messageController.text.isEmpty
        ? 'Seminar dijadwalkan pada $formattedDate'
        : 'Seminar dijadwalkan pada $formattedDate. Catatan: ${messageController.text}';

    final notificationData = {
      'title': 'Anda telah Dijadwalkan Seminar',
      'message': combinedMessage,
      'category': 'seminar',
      'date': selectedDate.toIso8601String().split('T').first,
    };

    context.read<NotificationBloc>().add(
      SendNotification(
        notificationData: notificationData,
        userIds: {int.parse(widget.student.username)},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: 'Seminar berhasil dijadwalkan! 📅',
        icon: Icons.check_circle_outline,
        backgroundColor: Colors.green.shade800,
      ),
    );

    widget.onSchedulingComplete(true);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: Container(
              width: size.width * 0.9,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkWhite : AppColors.lightWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  SeminarDatePicker(
                    selectedDateNotifier: selectedDateNotifier,
                  ),
                  const SizedBox(height: 16),
                  SeminarMessageField(
                    controller: messageController,
                  ),
                  const SizedBox(height: 24),
                  _buildScheduleButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Jadwalkan Seminar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.lightWhite : AppColors.lightBlack,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: isDark ? AppColors.lightWhite : AppColors.lightBlack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildScheduleButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleScheduling,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.darkPrimaryLight : AppColors.lightPrimary,
          foregroundColor: AppColors.lightWhite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.calendar_month, size: 20),
            SizedBox(width: 8),
            Text(
              'Jadwalkan Seminar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
