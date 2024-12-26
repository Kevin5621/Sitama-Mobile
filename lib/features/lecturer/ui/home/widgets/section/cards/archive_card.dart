import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/features/lecturer/domain/entities/lecturer_home_entity.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/display/lecturer_display_cubit.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_bloc.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_state.dart';
import 'package:sitama/features/lecturer/ui/home/widgets/section/archive.dart';

class ArchiveCard extends StatelessWidget {
  final List<LecturerStudentsEntity> archivedStudents;

  const ArchiveCard({
    super.key,
    required this.archivedStudents,
  });

  @override
  Widget build(BuildContext context) {
    if (archivedStudents.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
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
                    child: ArchivePage(
                      archivedStudents: archivedStudents,
                    ),
                  ),
                ),
              ).then((_) {
                lecturerCubit.displayLecturer();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.archive),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Siswa yang Diarsipkan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${archivedStudents.length} students',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}