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

  Widget _buildApproveButton(BuildContext context, bool isApproved) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(
        isApproved ? Icons.check_circle : Icons.check_circle_outline,
        color: isApproved ? Colors.green : colorScheme.onPrimary,
        size: 24,
      ),
      onPressed: () {
        context.read<DetailStudentDisplayCubit>().toggleInternshipApproval(index);
        if (onApprove != null) {
          onApprove!();
        }
      },
    );
  }

  Widget _buildStatusInfo(BuildContext context, bool isApproved) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(colorScheme).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStatusIcon(),
                size: 18,
                color: _getStatusColor(colorScheme),
              ),
              SizedBox(width: 8),
              Text(
                status,
                style: TextStyle(
                  color: _getStatusColor(colorScheme),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        _buildApproveButton(context, isApproved),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailStudentDisplayCubit, DetailStudentDisplayState>(
      builder: (context, state) {
        if (state is DetailLoaded) {
          final isApproved = state.isInternshipApproved(index);
          
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: _buildStatusInfo(context, isApproved),
          );
        }
        return SizedBox(); // or some loading/error state
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
        return Icons.work;
      case 'selesai magang':
        return Icons.check_circle;
      default:
        return Icons.work;
    }
  }
}