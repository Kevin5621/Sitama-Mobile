import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
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

  Future<void> _showDeleteConfirmation(BuildContext context, GroupModel group) async {
    final result = await CustomAlertDialog.show(
      context: context,
      title: 'Konfirmasi Hapus Grup',
      message: group.studentIds.isEmpty 
          ? 'Apakah Anda yakin ingin menghapus grup ini?'
          : 'Grup masih memiliki ${group.studentIds.length} mahasiswa. Menghapus grup akan mengeluarkan semua mahasiswa. Lanjutkan?',
      cancelText: 'Batal',
      confirmText: 'Hapus',
      confirmColor: AppColors.lightDanger,
      icon: Icons.delete_outline,
      iconColor: AppColors.lightDanger,
    );

    if (result == true) {
      // Keluarkan semua mahasiswa dari group terlebih dahulu
      if (group.studentIds.isNotEmpty) {
        context.read<SelectionBloc>().add(UnGroupItems(Set.from(group.studentIds)));
      }
      // Kemudian hapus group
      context.read<SelectionBloc>().add(DeleteGroup(groupId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        final group = state.groups[groupId];
        if (group == null) return const SizedBox.shrink();

        // Hitung jumlah students yang ada di group
        final groupStudentsList = groupStudents
            .where((student) => group.studentIds.contains(student.id))
            .toList();

        // Jangan tampilkan card jika tidak ada students
        if (groupStudentsList.isEmpty) {
          // Optional: Tambahkan auto-delete untuk group kosong
          Future.microtask(() {
            context.read<SelectionBloc>().add(DeleteGroup(groupId));
          });
          return const SizedBox.shrink();
        }

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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(group.icon),
                    const SizedBox(width: 12),
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
                          Text(
                            '${groupStudentsList.length} students',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _showDeleteConfirmation(context, group),
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