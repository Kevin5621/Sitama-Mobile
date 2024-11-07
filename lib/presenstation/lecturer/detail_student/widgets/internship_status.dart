import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';

class InternshipStatusBox extends StatelessWidget {
  final int index;
  final String status;
  final VoidCallback? onApprove;

  const InternshipStatusBox({
    Key? key,
    required this.index,
    required this.status,
    this.onApprove,
  }) : super(key: key);

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
        final shouldProceed =
            await _showConfirmationDialog(context, isApproved);
        // if (shouldProceed == true) {
        //   context.read<DetailStudentDisplayCubit>().toggleInternshipApproval(index);
        //   if (onApprove != null) {
        //     onApprove!();
        //   }
        // }
      },
      icon: Icon(
        isApproved ? Icons.check_circle : Icons.check_circle_outline,
        color: isApproved ? colorScheme.primary : colorScheme.outline,
      ),
    );
  }

  Widget _buildInternshipHeader(BuildContext context, ColorScheme colorScheme) {
    final statusColor = _getStatusColor(colorScheme);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(_getStatusIcon(), color: statusColor),
            const SizedBox(width: 8),
            Text(
              status,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ],
        ),
        _buildApproveButton(context, false),
      ],
    );
  }

  Widget _buildStudentInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('NIM', '2141720180'),
          const SizedBox(height: 8),
          _buildInfoRow('Kelas', 'TI-3H'),
          const SizedBox(height: 8),
          _buildInfoRow('No Absen', '20'),
          const SizedBox(height: 8),
          _buildInfoRow('Jurusan', 'Teknologi Informasi'),
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
          state.isInternshipApproved(index);
          final colorScheme = Theme.of(context).colorScheme;

          return Card(
            elevation: 4, // Menambahkan efek bayangan pada Card
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInternshipHeader(context, colorScheme),
                  const Divider(height: 24),
                  _buildStudentInfo(context),
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
        return colorScheme.primary;
      case 'selesai magang':
        return colorScheme.tertiary;
      default:
        return colorScheme.primary;
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'magang':
        return Icons.work_outline;
      case 'selesai magang':
        return Icons.check_circle_outline;
      default:
        return Icons.work_outline;
    }
  }
}
