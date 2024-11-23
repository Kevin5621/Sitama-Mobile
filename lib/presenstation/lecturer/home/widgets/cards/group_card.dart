import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/lecturer_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/lists/group.dart';

class GroupCard extends StatelessWidget {
  final String groupId;
  final List<LecturerStudentsEntity> groupStudents;

  const GroupCard({
    super.key,
    required this.groupId,
    required this.groupStudents,
  });

  IconData _getActivityIcon(String activity) {
    switch (activity) {
      case 'is_in_progress':
        return Icons.visibility_off;
      case 'is_updated':
        return Icons.help;
      case 'is_rejected':
        return Icons.edit_document;
      default:
        return Icons.circle;
    }
  }

  Color _getActivityColor(String activity) {
    switch (activity) {
      case 'is_in_progress':
        return AppColors.lightGray;
      case 'is_updated':
        return AppColors.lightWarning;
      case 'is_rejected':
        return AppColors.lightDanger;
      default:
        return AppColors.lightGray;
    }
  }

  List<String> _getGroupActivities(List<LecturerStudentsEntity> students) {
    // Gabungkan semua activities mahasiswa dalam grup menjadi list unik
    return students.expand((student) {
      return student.activities.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key);
    }).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        final group = state.groups[groupId];
        if (group == null) return const SizedBox.shrink();

        final groupStudentsList = groupStudents
            .where((student) => group.studentIds.contains(student.id))
            .toList();

        if (groupStudentsList.isEmpty) {
          Future.microtask(() {
            context.read<SelectionBloc>().add(DeleteGroup(groupId));
          });
          return const SizedBox.shrink();
        }

        final groupActivities = _getGroupActivities(groupStudentsList);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: () {
              final selectionBloc = context.read<SelectionBloc>();
              final lecturerCubit = context.read<LecturerDisplayCubit>();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: selectionBloc),
                      BlocProvider.value(value: lecturerCubit),
                    ],
                    child: GroupPage(
                      groupId: groupId,
                      groupStudents: groupStudentsList,
                    ),
                  ),
                ),
              ).then((_) {
                lecturerCubit.displayLecturer();
              });
            },
            child: Stack(
              children: [
                // Main content of the card
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(group.icon, size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${groupStudentsList.length} students',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Activity Icons Stack
                if (groupActivities.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: SizedBox(
                      width: max(24.0, groupActivities.length * 20.0),
                      height: 24,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: groupActivities
                            .asMap()
                            .entries
                            .map((entry) {
                              final activity = entry.value;
                              return Positioned(
                                right: entry.key * 15.0,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _getActivityColor(activity),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      _getActivityIcon(activity),
                                      size: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                              );
                            })
                            .toList()
                            .reversed
                            .toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
