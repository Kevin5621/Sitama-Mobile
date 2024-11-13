import 'package:flutter/material.dart';
<<<<<<< HEAD

class GroupCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int memberCount;
  final VoidCallback? onTap;

  const GroupCard({
    super.key,
    required this.icon,
    required this.title,
    required this.memberCount,
    this.onTap,
=======
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/lecturer_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/group.dart';

class GroupCard extends StatelessWidget {
  final List<LecturerStudentsEntity> groupStudents;

  const GroupCard({
    super.key,
    required this.groupStudents,
>>>>>>> 6a345e1 (test)
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '$memberCount members',
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
  }
}
=======
    if (groupStudents.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              onTap: () {
                // Modifikasi cara navigasi
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
                        groupStudents: groupStudents,
                      ),
                    ),
                  ),
                ).then((_) {
                  // Refresh data setelah kembali
                  lecturerCubit.displayLecturer();
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.group),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Groupd Students',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${groupStudents.length} students',
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
          ),
        );
      },
    );
  }
}
>>>>>>> 6a345e1 (test)
