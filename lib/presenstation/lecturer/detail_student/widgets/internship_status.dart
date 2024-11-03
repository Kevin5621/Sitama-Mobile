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
                  borderRadius: BorderRadius.circular(8),
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

  Widget _buildStatusBadge(BuildContext context, ColorScheme colorScheme) {
    final statusColor = _getStatusColor(colorScheme);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(),
            size: 20,
            color: statusColor,
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusBadge(context, colorScheme),
                _buildApproveButton(context, isApproved),
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