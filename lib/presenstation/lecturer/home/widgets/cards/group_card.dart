import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/lecturer_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/helper/activity_helper.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/lists/group/group.dart';

class GroupCard extends StatelessWidget {
  final String groupId;
  final List<LecturerStudentsEntity> groupStudents;

  const GroupCard({
    super.key,
    required this.groupId,
    required this.groupStudents,
  });

  List<String> _getGroupActivities(List<LecturerStudentsEntity> students) {
    return ActivityHelper.getGroupActivities(students);
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
          final selectionBloc = context.read<SelectionBloc>();
          Future.microtask(() {
            selectionBloc.add(DeleteGroup(groupId));
          });
          return const SizedBox.shrink();
        }

        final groupActivities = _getGroupActivities(groupStudentsList);

        return DragTarget<LecturerStudentsEntity>(
          onWillAcceptWithDetails: (data) => data != true && !group.studentIds.contains(data.data.id),
          onAcceptWithDetails: (data) {
            context.read<SelectionBloc>().add(
              AddStudentToGroup(
                groupId: groupId,
                studentId: data.data.id,
              ),
            );
          },
          builder: (context, candidateData, rejectedData) {
            final isDragging = candidateData.isNotEmpty;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: isDragging
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : null,
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
                    if (groupActivities.isNotEmpty)
                      ActivityHelper.buildActivityIconsStack(
                        activities: groupActivities,
                        context: context,
                        borderColor: Theme.of(context).colorScheme.surface,
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}