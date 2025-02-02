import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/features/lecturer/domain/entities/lecturer_home_entity.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_bloc.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_state.dart';
import 'package:sitama/features/lecturer/ui/home/widgets/utils/filters/filter_jurusan.dart';
import 'package:sitama/features/lecturer/ui/home/widgets/utils/filters/filter_tahun.dart';

class FilterSection extends StatefulWidget {
  final VoidCallback? onArchiveTap;
  final VoidCallback? onGroupTap;
  final List<LecturerStudentsEntity> students;
  final Function(List<LecturerStudentsEntity>) onStudentsFiltered;

  const FilterSection({
    super.key,
    this.onArchiveTap,
    this.onGroupTap,
    required this.students,
    required this.onStudentsFiltered,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  List<LecturerStudentsEntity> _filteredByMajor = [];
  List<LecturerStudentsEntity> _filteredByYear = [];
  bool _majorFilterActive = false;
  bool _yearFilterActive = false;

  void _applyFilters() {
    List<LecturerStudentsEntity> result = [];
    
    if (!_majorFilterActive && !_yearFilterActive) {
      // No filters active, return all students
      result = widget.students;
    } else if (_majorFilterActive && !_yearFilterActive) {
      // Only major filter active
      result = _filteredByMajor;
    } else if (!_majorFilterActive && _yearFilterActive) {
      // Only year filter active
      result = _filteredByYear;
    } else {
      // Both filters active - find intersection
      result = _filteredByMajor.where((student) => 
        _filteredByYear.any((yearStudent) => yearStudent.id == student.id)
      ).toList();
    }

    widget.onStudentsFiltered(result);
  }

  Widget _buildSelectionModeButtons(BuildContext context, SelectionState state) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.onGroupTap,
            icon: Icon(Icons.add_circle_outline, 
              color: Theme.of(context).colorScheme.onSecondary),
            label: const Text('Buat Group'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.onArchiveTap,
            icon: Icon(Icons.archive,
              color: Theme.of(context).colorScheme.onPrimary),
            label: const Text('Arsip'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
        Expanded(
          child: FilterJurusan(
            students: widget.students,
            onFilterChanged: (filteredStudents) {
              setState(() {
                _filteredByMajor = filteredStudents;
                _majorFilterActive = filteredStudents.length != widget.students.length;
              });
              _applyFilters();
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilterTahun(
            students: widget.students,
            onFilterChanged: (filteredStudents) {
              setState(() {
                _filteredByYear = filteredStudents;
                _yearFilterActive = filteredStudents.length != widget.students.length;
              });
              _applyFilters();
            },
          ),
        ),
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
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.05*255).round()),
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