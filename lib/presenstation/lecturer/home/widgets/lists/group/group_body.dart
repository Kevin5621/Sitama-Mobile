import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/cards/student_card.dart';

class GroupBody extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey; 
  final Future<void> Function() onRefresh;
  final List<LecturerStudentsEntity> filteredStudents;

  const GroupBody({
    super.key,
    required this.refreshIndicatorKey,
    required this.onRefresh,
    required this.filteredStudents,
  });

  @override
  State<GroupBody> createState() => _GroupBodyState();
}

class _GroupBodyState extends State<GroupBody> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );


    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: widget.refreshIndicatorKey,
      onRefresh: widget.onRefresh,
      child: widget.filteredStudents.isEmpty
          ? ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Tidak ada mahasiswa yang diarsipkan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
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
                      onTap: () => _handleStudentTap(context, student),
                      onLongPress: () => _handleStudentLongPress(context, student),
                    );
                  },
                );
              },
            ),
    );
  }

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

  void _handleStudentLongPress(BuildContext context, LecturerStudentsEntity student) {
    final state = context.read<SelectionBloc>().state;
    if (!state.isSelectionMode) {
      context.read<SelectionBloc>().add(ToggleSelectionMode());
      context.read<SelectionBloc>().add(ToggleItemSelection(student.id));
    }
  }
}