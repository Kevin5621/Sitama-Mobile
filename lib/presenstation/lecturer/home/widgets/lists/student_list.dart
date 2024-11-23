import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/cards/archive_card.dart';
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

  Widget _buildStudentItem(BuildContext context, LecturerStudentsEntity student) {
    final activitiesList = _getStudentActivities(student);

    return _buildFadeTransition(
      child: StudentCard(
        id: student.id,
        imageUrl: student.photo_profile ?? AppImages.defaultProfile,
        name: student.name,
        jurusan: student.major,
        kelas: student.the_class,
        nim: student.username,
        isSelected: selectionState.selectedIds.contains(student.id),
        activities: activitiesList,
        onTap: () => _handleStudentTap(context, student),
        onLongPress: () => _handleStudentLongPress(context, student),
      ),
    );
  }

  // Helper Methods
  List<String> _getStudentActivities(LecturerStudentsEntity student) {
    final activities = <String>[];
    if (student.activities['is_in_progress'] == true) activities.add('in-progress');
    if (student.activities['is_updated'] == true) activities.add('updated');
    if (student.activities['is_rejected'] == true) activities.add('rejected');
    return activities;
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
        // Filter out students that are in groups or archived
        final activeStudents = students.where((student) {
          // Check if student is archived
          if (state.archivedIds.contains(student.id)) {
            return false;
          }
          
          // Check if student is in any group
          for (var group in state.groups.values) {
            if (group.studentIds.contains(student.id)) {
              return false;
            }
          }
          
          return true;
        }).toList();

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
                if (activeStudents.isNotEmpty) ...[
                  _buildStudentsList(activeStudents, state),
                  const SizedBox(height: 16),
                ],
                
                // 3. Groups in the middle
                ..._buildGroupCards(state),
                if (state.groups.isNotEmpty)
                  const SizedBox(height: 16),
                
                // 4. Archive card always at bottom
                _buildArchiveSection(state),
              ],
            ),
          ]),
        );
      },
    );
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

  List<Widget> _buildGroupCards(SelectionState state) {
    return state.groups.entries.map((entry) {
      final groupStudents = students
          .where((student) => entry.value.studentIds.contains(student.id))
          .toList();
      return GroupCard(
        groupId: entry.key,
        groupStudents: groupStudents,
      );
    }).toList();
  }

  Widget _buildArchiveCard(SelectionState state) {
    return ArchiveCard(
      archivedStudents: students
          .where((student) => state.archivedIds.contains(student.id))
          .toList(),
    );
  }

  Widget _buildArchiveSection(SelectionState state) {
    final archivedStudents = students
        .where((student) => state.archivedIds.contains(student.id))
        .toList();
    
    if (archivedStudents.isEmpty) {
      return const SizedBox.shrink();
    }

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


  Widget _buildStudentsList(List<LecturerStudentsEntity> activeStudents, SelectionState state) {
    if (activeStudents.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activeStudents.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) => _buildStudentItem(context, activeStudents[index]),
    );
  }
}

// Extracted Dialog Widget
class _GroupCreationDialog extends StatefulWidget {
  @override
  _GroupCreationDialogState createState() => _GroupCreationDialogState();
}

class _GroupCreationDialogState extends State<_GroupCreationDialog> {
  final titleController = TextEditingController();
  IconData selectedIcon = Icons.group;

  static const List<IconData> availableIcons = [
    Icons.group,
    Icons.school,
    Icons.work,
    Icons.star,
    Icons.favorite,
    Icons.rocket_launch,
    Icons.psychology,
    Icons.science,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Create New Group'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Group Name',
              hintText: 'Enter group name',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a group name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('Select Icon'),
          const SizedBox(height: 8),
          _buildIconSelector(colorScheme),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleCreateGroup,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24),
            elevation: 0, 
          ),
          child: Text('Create'),
        ),
      ],
    );
  }

  Widget _buildIconSelector(ColorScheme colorScheme) {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Wrap(
      spacing: 12, 
      runSpacing: 12,
      children: [
        for (final icon in availableIcons)
          Material(
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => selectedIcon = icon),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selectedIcon == icon
                      ? colorScheme.primary.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedIcon == icon 
                      ? colorScheme.primary 
                      : Colors.transparent,
                  ),
                ),
                child: Icon(
                  icon,
                  color: selectedIcon == icon 
                    ? colorScheme.primary 
                    : colorScheme.onSurface,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

  void _handleCreateGroup() {
    Navigator.of(context).pop({
      'title': titleController.text,
      'icon': selectedIcon,
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}