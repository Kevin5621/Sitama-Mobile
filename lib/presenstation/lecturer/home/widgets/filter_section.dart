import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/filter_jurusan.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/filter_tahun.dart';

class FilterSection extends StatelessWidget {
  final VoidCallback? onArchiveTap;

  const FilterSection({
    super.key,
    this.onArchiveTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Expanded(child: FilterJurusan()),
                const SizedBox(width: 16),
                Expanded(
                  child: state.isSelectionMode
                      ? _buildArchiveButton(context)
                      : const FilterTahun(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

Widget _buildArchiveButton(BuildContext context) {
  return ElevatedButton.icon(
    onPressed: () {
      if (onArchiveTap != null) {
        onArchiveTap!();
      } else {
        context.read<SelectionBloc>().add(ArchiveSelectedItems());
      }
    },
    icon: const Icon(Icons.archive),
    label: const Text('Archive'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      fixedSize: const Size(150, 40),
    ),
  );
}
}