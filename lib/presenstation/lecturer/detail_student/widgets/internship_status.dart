import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> _showConfirmationDialog(BuildContext context, bool currentStatus) async {
    final colorScheme = Theme.of(context).colorScheme;
    
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            currentStatus ? 'Batalkan Persetujuan?' : 'Setujui Status Magang?',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
            currentStatus 
              ? 'Anda yakin ingin membatalkan persetujuan status magang ini?'
              : 'Anda yakin ingin menyetujui status magang ini?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Batal',
                style: TextStyle(color: colorScheme.secondary),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentStatus ? Colors.red : colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                currentStatus ? 'Batalkan' : 'Setujui',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildApproveButton(BuildContext context, bool isApproved) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () async {
          final shouldProceed = await _showConfirmationDialog(context, isApproved);
          // if (shouldProceed == true) {
          //   context.read<DetailStudentDisplayCubit>().toggleInternshipApproval(index);
          //   if (onApprove != null) {
          //     onApprove!();
          //   }
          // }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isApproved ? Icons.check_circle : Icons.check_circle_outline,
              key: ValueKey<bool>(isApproved),
              color: isApproved ? Colors.green : Colors.grey,
              size: 28,
            ),
          ),
        ),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getStatusIcon(),
                color: statusColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                Text(
                  'Status saat ini',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        _buildApproveButton(context, false),
      ],
    );
  }

  Widget _buildStudentInfo(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            'NIM',
            '2141720180',
            Icons.assignment_ind_outlined,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            'Kelas',
            'TI-3H',
            Icons.class_outlined,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            'No Absen',
            '20',
            Icons.format_list_numbered_outlined,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            'Jurusan',
            'Teknologi Informasi',
            Icons.school_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailStudentDisplayCubit, DetailStudentDisplayState>(
      builder: (context, state) {
        if (state is DetailLoaded) {
          final isApproved = state.isInternshipApproved(index);
          final colorScheme = Theme.of(context).colorScheme;

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isApproved 
                  ? Colors.green.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInternshipHeader(context, colorScheme),
                const SizedBox(height: 16),
                _buildStudentInfo(context),
              ],
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
        return Colors.green;
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