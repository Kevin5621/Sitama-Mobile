// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/cards/archive_card.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/dialogs/group_dialog.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/filters/filter_section.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/cards/group_card.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/cards/student_card.dart';

class StudentList extends StatelessWidget {
  const StudentList({
    super.key,
    required this.students,
    required this.searchAnimation,
    required this.animationController,
    required this.selectionState,
  });

  final List<LecturerStudentsEntity> students;
  final Animation<double> searchAnimation;
  final AnimationController animationController;
  final SelectionState selectionState;

  // Animation helpers
  SlideTransition _buildSlideTransition({required Widget child}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(animationController),
      child: child,
    );
  }

  FadeTransition _buildFadeTransition({required Widget child}) {
    return FadeTransition(
      opacity: searchAnimation,
      child: _buildSlideTransition(child: child),
    );
  }

  // UI Components
  Widget _buildTitle() {
    return _buildFadeTransition(
      child: const Text(
        'Mahasiswa Bimbingan',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStudentItem(LecturerStudentsEntity student) {
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
  }

  // Event Handlers
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
      final bloc = context.read<SelectionBloc>();
      bloc.add(ToggleSelectionMode());
      bloc.add(ToggleItemSelection(student.id));
    }
  }

  // Dialog Methods
  Future<void> _showArchiveConfirmation(BuildContext context) async {
    final bloc = context.read<SelectionBloc>();
    final colorScheme = Theme.of(context).colorScheme;
    
    final result = await CustomAlertDialog.show(
      context: context,
      title: 'Konfirmasi Arsip',
      message: 'Apakah Anda yakin ingin mengarsipkan ${bloc.state.selectedIds.length} item?',
      cancelText: 'Batal',
      confirmText: 'Arsipkan',
      confirmColor: colorScheme.primary,
      icon: Icons.archive_outlined,
      iconColor: colorScheme.primary,
    );

    if (result == true) {
      bloc.add(ArchiveSelectedItems());
    }
  }

  Future<void> _showGroupConfirmation(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _GroupCreationDialog(),
    );

    if (result != null) {
      final bloc = context.read<SelectionBloc>();
      bloc.add(GroupSelectedItems(
        title: result['title'],
        icon: result['icon'],
        studentIds: Set<int>.from(bloc.state.selectedIds),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        // 1. Split students into categories
        final Map<String, List<LecturerStudentsEntity>> categorizedStudents = _categorizeStudents(students, state);
        
        return SliverList(
          delegate: SliverChildListDelegate([
            _buildTitle(),
            const SizedBox(height: 16),
            Column(
              children: [
                // 1. Filter Section always at top
                _buildFilterSection(context, state),
                const SizedBox(height: 16),
                
                // 2. Active students list
                if (categorizedStudents['active']!.isNotEmpty) ...[
                  _buildStudentsList(categorizedStudents['active']!),
                  const SizedBox(height: 16),
                ],
                
                // 3. Groups in the middle (only show if there are matching students in the group)
                ..._buildGroupCards(state, categorizedStudents['grouped']!),
                if (state.groups.isNotEmpty && 
                    categorizedStudents['grouped']!.isNotEmpty)
                  const SizedBox(height: 16),
                
                // 4. Archive card always at bottom (only show if there are matching archived students)
                if (categorizedStudents['archived']!.isNotEmpty)
                  _buildArchiveSection(state, categorizedStudents['archived']!),
              ],
            ),
          ]),
        );
      },
    );
  }

  Map<String, List<LecturerStudentsEntity>> _categorizeStudents(
    List<LecturerStudentsEntity> students,
    SelectionState state,
  ) {
    final active = <LecturerStudentsEntity>[];
    final grouped = <LecturerStudentsEntity>[];
    final archived = <LecturerStudentsEntity>[];

    for (final student in students) {
      if (state.archivedIds.contains(student.id)) {
        archived.add(student);
        continue;
      }

      bool isInGroup = false;
      for (var group in state.groups.values) {
        if (group.studentIds.contains(student.id)) {
          grouped.add(student);
          isInGroup = true;
          break;
        }
      }

      if (!isInGroup) {
        active.add(student);
      }
    }

    return {
      'active': active,
      'grouped': grouped,
      'archived': archived,
    };
  }

  // Build Helper Methods
  Widget _buildFilterSection(BuildContext context, SelectionState state) {
    return FilterSection(
      onArchiveTap: state.selectedIds.isNotEmpty
          ? () => _showArchiveConfirmation(context)
          : null,
      onGroupTap: state.selectedIds.isNotEmpty
          ? () => _showGroupConfirmation(context)
          : null,
    );
  }

  List<Widget> _buildGroupCards(SelectionState state, List<LecturerStudentsEntity> groupedStudents) {
    if (groupedStudents.isEmpty) return [];

    return state.groups.entries.map((entry) {
      final groupStudents = groupedStudents
          .where((student) => entry.value.studentIds.contains(student.id))
          .toList();
      
      // Only show group if it has matching students
      if (groupStudents.isEmpty) {
        return const SizedBox.shrink();
      }

      return GroupCard(
        groupId: entry.key,
        groupStudents: groupStudents,
      );
    }).where((widget) => widget is! SizedBox).toList();
  }

  Widget _buildArchiveSection(SelectionState state, List<LecturerStudentsEntity> archivedStudents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFadeTransition(
          child: const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Arsip',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ArchiveCard(archivedStudents: archivedStudents),
      ],
    );
  }


  Widget _buildStudentsList(List<LecturerStudentsEntity> activeStudents) {
  if (activeStudents.isEmpty) {
    return const SizedBox.shrink();
  }

  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: activeStudents.length,
    separatorBuilder: (_, __) => const SizedBox(height: 14),
    itemBuilder: (context, index) => _buildStudentItem(activeStudents[index]),
  );
}
}

// Extracted Dialog Widget
class _GroupCreationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GroupDialogForm(
      title: 'Create New Group',
      onSubmit: (title, icon) {
        Navigator.of(context).pop({
          'title': title,
          'icon': icon,
        });
      },
    );
  }
}