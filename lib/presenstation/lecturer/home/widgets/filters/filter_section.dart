import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/filters/filter_jurusan.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/filters/filter_tahun.dart';

class FilterSection extends StatelessWidget {
  final VoidCallback? onArchiveTap;
  final VoidCallback? onGroupTap;

  const FilterSection({
    super.key,
    this.onArchiveTap,
    this.onGroupTap,
  });

  Widget _buildSelectionModeButtons(BuildContext context, SelectionState state) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onGroupTap,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Create Group'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onArchiveTap,
            icon: const Icon(Icons.archive),
            label: const Text('Archive'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalModeButtons(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: FilterJurusan()),
        const SizedBox(width: 16),
        const Expanded(child: FilterTahun()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
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
          child: state.isSelectionMode
              ? _buildSelectionModeButtons(context, state)
              : _buildNormalModeButtons(context),
        );
      },
    );
  }
}
