import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/features/lecturer/domain/entities/lecturer_home_entity.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/display/lecturer_display_cubit.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_bloc.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_event.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_state.dart';
import 'package:sitama/features/lecturer/ui/home/widgets/section/group/group_page.dart';
import 'package:sitama/features/lecturer/ui/home/widgets/utils/helper/activity_helper.dart';

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

  Future<void> _handleMultiDrop(BuildContext context, Set<int> studentIds) async {
    final selectionBloc = context.read<SelectionBloc>();
    
    // Create a list to store all Future operations
    final List<Future<void>> operations = [];
    
    // Add all operations to the list
    for (final studentId in studentIds) {
      operations.add(
        Future(() => selectionBloc.add(AddStudentToGroup(
          groupId: groupId,
          studentId: studentId,
        )))
      );
    }

    // Wait for all operations to complete
    await Future.wait(operations);
    
    // Clear selection mode after all operations are complete
    selectionBloc.add(ClearSelectionMode());
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI using BlocBuilder to listen to changes in SelectionBloc
    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        // Retrieve the group data from the current state using groupId
        final group = state.groups[groupId];
        
        // If the group is null, render an invisible widget to avoid errors
        if (group == null) return const SizedBox.shrink();

        // Filter and create a list of students that belong to the group
        final groupStudentsList = groupStudents
            .where((student) => group.studentIds.contains(student.id))
            .toList();

        // Handle case where no students are in the group by deleting the group
        if (groupStudentsList.isEmpty) {
          final selectionBloc = context.read<SelectionBloc>();
          // Schedule deletion to prevent issues during widget rebuild
          Future.microtask(() {
            selectionBloc.add(DeleteGroup(groupId));
          });
          return const SizedBox.shrink();
        }

        // Retrieve activities related to the group for display
        final groupActivities = _getGroupActivities(groupStudentsList);

        // Allow drag-and-drop interactions using DragTarget
        return DragTarget<Set<int>>(
          // Allow drag data only if it is not empty
          onWillAcceptWithDetails: (details) {
            final data = details.data;
            return data.isNotEmpty;
          },
          // Handle the drop action for student IDs
          onAcceptWithDetails: (details) {
            final studentIds = details.data;
            _handleMultiDrop(context, studentIds);
          },
          // Tambahkan hit test behavior
          hitTestBehavior: HitTestBehavior.translucent,
          builder: (context, candidateData, rejectedData) {
            // Highlight the card when a drag operation is active
            final isDragging = candidateData.isNotEmpty;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: isDragging
                  ? Theme.of(context).colorScheme.primary.withAlpha((0.1*255).round())
                  : null,
              child: InkWell(
                onTap: () {
                  // Handle navigation to the GroupPage with relevant data
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
                    // Refresh lecturer data after returning from GroupPage
                    lecturerCubit.displayLecturer();
                  });
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Use the color from the group model
                          Icon(
                            group.icon, 
                            size: 40, 
                            color: group.iconColor
                          ),
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
                                  '${groupStudentsList.length} Mahasiswa',
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
                        borderColor: Theme.of(context).colorScheme.surfaceContainer,
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