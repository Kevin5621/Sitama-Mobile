import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';

class InternshipStatusBox extends StatelessWidget {
  final List<DetailStudentEntity> students;
  final int index;

  const InternshipStatusBox({
    super.key,
    required this.students,
    required this.index,
  });

  Future<bool?> _showConfirmationDialog(
    BuildContext context, bool? currentStatus) async {
    return CustomAlertDialog.showConfirmation(
      context: context,
      title: currentStatus == true ? 'Batalkan Penyelesaian Magang?' : 'Selesaikan Magang?',
      message: currentStatus == true
          ? 'Anda yakin ingin membatalkan status penyelesaian magang ini?'
          : 'Anda yakin ingin menyelesaikan status magang ini?',
      cancelText: 'Batal',
      confirmText: currentStatus == true ? 'Batalkan' : 'Selesaikan',
    );
  }

  Widget _buildInternshipHeader(BuildContext context, ColorScheme colorScheme) {
    final student = students[index];
    final currentStatus = student.is_finished == true 
        ? 'Selesai Magang' 
        : 'Sedang Magang';
    final statusColor = _getStatusColor(colorScheme, currentStatus);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(_getStatusIcon(currentStatus), color: statusColor),
            const SizedBox(width: 8),
            Text(
              currentStatus,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ],
        ),
        _buildCompletionButton(context),
      ],
    );
  }

  Widget _buildCompletionButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final student = students[index];

    return IconButton(
      onPressed: () async {
        final shouldProceed = await _showConfirmationDialog(context, student.is_finished);
        if (shouldProceed == true) {
          context.read<DetailStudentDisplayCubit>().toggleInternshipCompletion(index);
        }
      },
      icon: Icon(
        Icons.check_circle_outline,
        color: student.is_finished == true
            ? colorScheme.tertiary 
            : colorScheme.outline,
      ),
    );
  }

  Widget _buildStudentInfo(BuildContext context, DetailStudentEntity student) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Nama', student.student.name),
          const SizedBox(height: 8),
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
                  Theme.of(context).colorScheme
                ),
                const Divider(height: 24),
                _buildStudentInfo(context, student),
                if (student.is_finished == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle, 
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Internship Completed',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    },
  );
}

  Color _getStatusColor(ColorScheme colorScheme, String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'sedang magang':
        return colorScheme.primary;
      case 'selesai magang':
        return colorScheme.tertiary;
      default:
        return colorScheme.primary;
    }
  }

  IconData _getStatusIcon(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'sedang magang':
        return Icons.work_outline;
      case 'selesai magang':
        return Icons.check_circle_outline;
      default:
        return Icons.work_outline;
    }
  }
}