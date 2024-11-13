import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/archive_card.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/filter_section.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/group_card.dart';
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

  Widget _buildStudentItem(BuildContext context, LecturerStudentsEntity student) {
    // Konversi activities dari Map ke List
    List<String> activitiesList = [];
    if (student.activities['is_in_progress'] == true) activitiesList.add('in-progress');
    if (student.activities['is_updated'] == true) activitiesList.add('updated');
    if (student.activities['is_rejected'] == true) activitiesList.add('rejected');

    return FadeTransition(
      opacity: searchAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(animationController),
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

  void _handleStudentLongPress(
      BuildContext context, LecturerStudentsEntity student) {
    if (!selectionState.isSelectionMode) {
      context.read<SelectionBloc>().add(ToggleSelectionMode());
      context.read<SelectionBloc>().add(ToggleItemSelection(student.id));
    }
  }

  Future<void> _showArchiveConfirmation(BuildContext context) async {
    final bloc = context.read<SelectionBloc>();
    final state = bloc.state;
    final colorScheme = Theme.of(context).colorScheme;
    
    final result = await CustomAlertDialog.show(
      context: context,
      title: 'Konfirmasi Arsip',
      message: 'Apakah Anda yakin ingin mengarsipkan ${state.selectedIds.length} item?',
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
  final bloc = context.read<SelectionBloc>();
  final state = bloc.state;
  final colorScheme = Theme.of(context).colorScheme;
  final List<IconData> availableIcons = [
    Icons.group,
    Icons.school,
    Icons.work,
    Icons.star,
    Icons.favorite,
    Icons.rocket_launch,
    Icons.psychology,
    Icons.science,
  ];

  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      final titleController = TextEditingController();
      IconData selectedIcon = Icons.group;

      return AlertDialog(
        title: const Text('Create New Group'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Group Name',
                    hintText: 'Enter group name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a group name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Select Icon'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final icon in availableIcons)
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedIcon == icon
                                ? colorScheme.primary.withOpacity(0.1)
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop({
                'title': titleController.text,
                'icon': selectedIcon,
              });
            },
            child: const Text('Create'),
          ),
        ],
      );
    },
  );

  if (result != null) {
    bloc.add(
      GroupSelectedItems(
        title: result['title'],
        icon: result['icon'],
        studentIds: state.selectedIds,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        return SliverList(
          delegate: SliverChildListDelegate([
            _buildTitle(),
            const SizedBox(height: 16),
            BlocBuilder<SelectionBloc, SelectionState>(
              builder: (context, state) {
                return FilterSection(
                  onArchiveTap: state.selectedIds.isNotEmpty
                      ? () => _showArchiveConfirmation(context)
                      : null,
                  onGroupTap: state.selectedIds.isNotEmpty
                      ? () => _showGroupConfirmation(context)
                      : null,
                );
              },
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                GroupCard(
                  groupStudents: students
                      .where((student) => state.archivedIds.contains(student.id))
                      .toList(),
                ),
                ArchiveCard(
                  archivedStudents: students
                      .where((student) => state.archivedIds.contains(student.id))
                      .toList(),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: students
                      .where((student) => !state.archivedIds.contains(student.id))
                      .length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final activeStudents = students
                        .where((student) => !state.archivedIds.contains(student.id))
                        .toList();
                    return _buildStudentItem(context, activeStudents[index]);
                  },
                ),
              ],
            ),
          ]),
        );
      },
    );
  }
}
