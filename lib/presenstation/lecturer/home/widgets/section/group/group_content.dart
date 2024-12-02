import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/section/cards/student_card.dart';

// Widget to display group content with student list and interaction
class GroupContent extends StatefulWidget {
  // Refresh indicator and student filtering parameters
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey; 
  final Future<void> Function() onRefresh;
  final List<LecturerStudentsEntity> filteredStudents;

  const GroupContent({
    super.key,
    required this.refreshIndicatorKey,
    required this.onRefresh,
    required this.filteredStudents,
  });

  @override
  State<GroupContent> createState() => _GroupContentState();
}

class _GroupContentState extends State<GroupContent> with SingleTickerProviderStateMixin {
  // Animation controller for list item entrance
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize animation for smooth list rendering
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    // Clean up animation controller
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: widget.refreshIndicatorKey,
      onRefresh: widget.onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: widget.filteredStudents.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final student = widget.filteredStudents[index];
          return BlocBuilder<SelectionBloc, SelectionState>(
            builder: (context, state) {
              return StudentCard(
                student: student,
                isSelected: state.selectedIds.contains(student.id),
                isFinished: student.isFinished,
                onTap: () => _handleStudentTap(context, student),
                onLongPress: () => _handleStudentLongPress(context, student),
              );
            },
          );
        },
      ),
    );
  }

  // Handles tap on a student card
  void _handleStudentTap(BuildContext context, LecturerStudentsEntity student) {
    final state = context.read<SelectionBloc>().state;
    if (state.isSelectionMode) {
      context.read<SelectionBloc>().add(ToggleItemSelection(student.id));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailStudentPage(id: student.id),
        ),
      );
    }
  }

  // Handles long press on a student card
  void _handleStudentLongPress(BuildContext context, LecturerStudentsEntity student) {
    final state = context.read<SelectionBloc>().state;
    if (!state.isSelectionMode) {
      context.read<SelectionBloc>().add(ToggleSelectionMode());
      context.read<SelectionBloc>().add(ToggleItemSelection(student.id));
    }
  }
}