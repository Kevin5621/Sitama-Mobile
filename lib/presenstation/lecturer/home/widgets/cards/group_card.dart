import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/lecturer_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/helper/activity_helper.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/lists/group.dart';

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
  }
}
