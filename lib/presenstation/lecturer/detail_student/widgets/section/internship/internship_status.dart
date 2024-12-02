import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';

class InternshipStatusBox extends StatelessWidget {
  final List<DetailStudentEntity> students;
  final int index;
  final String status;
  final VoidCallback? onApprove;
  final bool isFinished;

  const InternshipStatusBox({
    super.key,
    required this.students,
    required this.index,
    required this.status,
    required this.isFinished,
    this.onApprove,
  });

  Future<bool?> _showConfirmationDialog(
      BuildContext context, bool currentStatus) async {
    return CustomAlertDialog.showConfirmation(
      context: context,
      title: currentStatus ? 'Batalkan Persetujuan?' : 'Setujui Status Magang?',
      message: currentStatus
          ? 'Anda yakin ingin membatalkan persetujuan status magang ini?'
          : 'Anda yakin ingin menyetujui status magang ini?',
      cancelText: 'Batal',
      confirmText: currentStatus ? 'Batalkan' : 'Setujui',
    );
  }

  Widget _buildApproveButton(BuildContext context, bool isApproved) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: () async {
        final shouldProceed = await _showConfirmationDialog(context, isApproved);
        if (shouldProceed == true) {
          context.read<DetailStudentDisplayCubit>().toggleInternshipApproval(index);
          if (onApprove != null) {
            onApprove!();
          }
        }
      },
      icon: Icon(
        isApproved ? Icons.check_circle : Icons.check_circle_outline,
        color: isApproved ? colorScheme.primary : colorScheme.outline,
      ),
    );
  }

  Widget _buildInternshipHeader(
    BuildContext context, 
    ColorScheme colorScheme, 
    {Color? statusColor}
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              _getStatusIcon(), 
              color: statusColor ?? colorScheme.primary
            ),
            const SizedBox(width: 8),
            Text(
              _getStatusText(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: statusColor ?? colorScheme.primary,
              ),
            ),
          ],
        ),
        _buildApproveButton(context, isFinished),
      ],
    );
  }


  Widget _buildStudentInfo(BuildContext context, DetailStudentEntity student) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('NIM', student.username),
          const SizedBox(height: 8),
          _buildInfoRow('Kelas', student.the_class),
          const SizedBox(height: 8),
          _buildInfoRow('Absen', student.username.substring(student.username.length - 2)),
          const SizedBox(height: 8),
          _buildInfoRow('Jurusan', student.major),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Text(': '),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

@override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailStudentDisplayCubit, DetailStudentDisplayState>(
      builder: (context, state) {
        if (state is DetailLoaded) {
          final student = students[index];
          final colorScheme = Theme.of(context).colorScheme;

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInternshipHeader(
                    context, 
                    colorScheme, 
                    statusColor: _getStatusColor(colorScheme)
                  ),
                  const Divider(height: 24),
                  _buildStudentInfo(context, student),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

 Color _getStatusColor(ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'magang':
        return isFinished 
          ? Colors.green
          : colorScheme.primary;
      default:
        return colorScheme.secondary;
    }
  }

  String _getStatusText() {
    switch (status.toLowerCase()) {
      case 'magang':
        return isFinished ? 'Selesai Magang' : 'Magang';
      default:
        return status;
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'magang':
        return isFinished 
          ? Icons.check_circle
          : Icons.work_outline;
      default:
        return Icons.work_outline;
    }
  }
}