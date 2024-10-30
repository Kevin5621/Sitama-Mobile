import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/filter_section.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/student_card.dart';

class StudentList extends StatelessWidget {
  final List<LecturerStudentsEntity> students;
  final Animation<double> searchAnimation;
  final AnimationController animationController;
  final SelectionState selectionState;

  const StudentList({
    super.key,
    required this.students,
    required this.searchAnimation,
    required this.animationController,
    required this.selectionState,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _buildTitle(),
        const SizedBox(height: 16),
        const FilterSection(),
        const SizedBox(height: 16),
        _buildStudentsList(context),
      ]),
    );
  }

  Widget _buildTitle() {
    return FadeTransition(
      opacity: searchAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(animationController),
        child: const Text(
          'Mahasiswa Bimbingan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentsList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) => _buildStudentItem(context, index),
    );
  }

  Widget _buildStudentItem(BuildContext context, int index) {
    final student = students[index];
    return FadeTransition(
      opacity: searchAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(animationController),
        child: StudentCard(
          id: student.id,
          imageUrl: 'https://picsum.photos/200/300',
          name: student.name,
          jurusan: student.major,
          kelas: student.study_program,
          nim: student.username,
          isSelected: selectionState.selectedIds.contains(student.id),
          notificationStatus: 2,
          activities: ['revisi', 'updated', 'unseen'],
          onTap: () => _handleStudentTap(context, student),
          onLongPress: () => _handleStudentLongPress(context, student),
        ),
      ),
    );
  }

  void _handleStudentTap(BuildContext context, LecturerStudentsEntity student) {
    if (selectionState.isSelectionMode) {
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
    if (!selectionState.isSelectionMode) {
      context.read<SelectionBloc>().add(ToggleSelectionMode());
      context.read<SelectionBloc>().add(ToggleItemSelection(student.id));
    }
  }
}