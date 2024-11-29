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

// Widget that displays a list of students with grouping, archiving, and selection capabilities
// Used in the lecturer's dashboard to manage their supervised students
class StudentList extends StatefulWidget {
  const StudentList({
    super.key,
    required this.students,
    required this.searchAnimation,
    required this.animationController,
    required this.selectionState,
  });

  // Complete list of students under the lecturer's supervision
  final List<LecturerStudentsEntity> students;
  // Controls fade animation for search results
  final Animation<double> searchAnimation;
  // Controls slide animation for list items
  final AnimationController animationController;
  // Current selection state (selected students, groups, archived items)
  final SelectionState selectionState;

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  // Stores filtered students based on search/filter criteria
  List<LecturerStudentsEntity> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _filteredStudents = widget.students;
  }

  // Updates filtered students when the main student list changes
  @override
  void didUpdateWidget(StudentList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.students != oldWidget.students) {
      setState(() {
        _filteredStudents = widget.students;
      });
    }
  }

  // Animation helpers for smooth UI transitions
  SlideTransition _buildSlideTransition({required Widget child}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(widget.animationController),
      child: child,
    );
  }

  FadeTransition _buildFadeTransition({required Widget child}) {
    return FadeTransition(
      opacity: widget.searchAnimation,
      child: _buildSlideTransition(child: child),
    );
  }

  // UI Components for different sections of the list
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

  // Builds individual student card with selection capability
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

  // Event Handlers for student interactions
  // Handles tap: Opens detail view in normal mode, toggles selection in selection mode
  void _handleStudentTap(BuildContext context, LecturerStudentsEntity student) {
    if (widget.selectionState.isSelectionMode) {
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

  // Initiates selection mode on long press and selects the pressed item
  void _handleStudentLongPress(BuildContext context, LecturerStudentsEntity student) {
    if (!widget.selectionState.isSelectionMode) {
      final bloc = context.read<SelectionBloc>();
      bloc.add(ToggleSelectionMode());
      bloc.add(ToggleItemSelection(student.id));
    }
  }

  // Dialog Methods for user confirmations
  // Shows confirmation dialog before archiving selected students
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

  // Shows dialog for creating a new group from selected students
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

  // Categorizes students into active, grouped, and archived lists
  // This helps organize the UI into distinct sections
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

  // Build Helper Methods for different sections of the UI
  // Builds filter section with search and action buttons
  Widget _buildFilterSection(BuildContext context, SelectionState state) {
    return FilterSection(
      students: widget.students,
      onStudentsFiltered: (filteredStudents) {
        setState(() {
          _filteredStudents = filteredStudents;
        });
      },
      onArchiveTap: state.selectedIds.isNotEmpty
          ? () => _showArchiveConfirmation(context)
          : null,
      onGroupTap: state.selectedIds.isNotEmpty
          ? () => _showGroupConfirmation(context)
          : null,
    );
  }

  // Creates cards for each student group
  List<Widget> _buildGroupCards(SelectionState state, List<LecturerStudentsEntity> groupedStudents) {
    if (groupedStudents.isEmpty) return [];

    return state.groups.entries.map((entry) {
      final groupStudents = groupedStudents
          .where((student) => entry.value.studentIds.contains(student.id))
          .toList();
      
      if (groupStudents.isEmpty) {
        return const SizedBox.shrink();
      }

      return GroupCard(
        groupId: entry.key,
        groupStudents: groupStudents,
      );
    }).where((widget) => widget is! SizedBox).toList();
  }

  // Builds the archived students section with title and list
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

  // Builds the list of active (non-grouped, non-archived) students
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

  // Main build method that assembles all sections into final UI
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        // Organize students into categories for display
        final categorizedStudents = _categorizeStudents(_filteredStudents, state);
        
        return SliverList(
          delegate: SliverChildListDelegate([
            _buildTitle(),
            const SizedBox(height: 16),
            Column(
              children: [
                _buildFilterSection(context, state),
                const SizedBox(height: 16),
                
                // Active students section
                if (categorizedStudents['active']!.isNotEmpty) ...[
                  _buildStudentsList(categorizedStudents['active']!),
                  const SizedBox(height: 16),
                ],
                
                // Grouped students section
                ..._buildGroupCards(state, categorizedStudents['grouped']!),
                if (state.groups.isNotEmpty && 
                    categorizedStudents['grouped']!.isNotEmpty)
                  const SizedBox(height: 16),
                
                // Archived students section
                if (categorizedStudents['archived']!.isNotEmpty)
                  _buildArchiveSection(state, categorizedStudents['archived']!),
              ],
            ),
          ]),
        );
      },
    );
  }
}

// Dialog for creating new student groups
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