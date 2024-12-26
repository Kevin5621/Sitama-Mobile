// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/common/widgets/alert.dart';
import 'package:sitama/common/widgets/custom_snackbar.dart';
import 'package:sitama/common/widgets/search_field.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/domain/entities/lecturer_home_entity.dart';
import 'package:sitama/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sitama/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sitama/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sitama/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sitama/presenstation/lecturer/home/widgets/utils/dialogs/send_message_bottom.dart';
import 'package:sitama/presenstation/lecturer/home/widgets/section/cards/student_card.dart';

class ArchivePage extends StatefulWidget {
  final List<LecturerStudentsEntity> archivedStudents;

  const ArchivePage({
    super.key,
    required this.archivedStudents,
  });

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  List<LecturerStudentsEntity> _filteredStudents = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _synchronizeArchivedStudents();
  }

  void _synchronizeArchivedStudents() {
    // Get current archived IDs from bloc
    final archivedIds = context.read<SelectionBloc>().state.archivedIds;
    
    // Filter students based on current archived IDs
    setState(() {
      _filteredStudents = widget.archivedStudents
          .where((student) => archivedIds.contains(student.id))
          .toList();
    });
  }

  @override
  void didUpdateWidget(ArchivePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.archivedStudents != oldWidget.archivedStudents) {
      _synchronizeArchivedStudents();
    }
  }

  void _filterStudents(String query) {
    final archivedIds = context.read<SelectionBloc>().state.archivedIds;
    
    if (query.isEmpty) {
      setState(() {
        _filteredStudents = widget.archivedStudents
            .where((student) => archivedIds.contains(student.id))
            .toList();
      });
      return;
    }

    setState(() {
      _filteredStudents = widget.archivedStudents
          .where((student) => 
              archivedIds.contains(student.id) &&
              (student.name.toLowerCase().contains(query.toLowerCase()) ||
              student.username.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }
  
  Future<void> _showUnarchiveConfirmation(
    BuildContext context, Set<int> selectedIds) async {
    final colorScheme = Theme.of(context).colorScheme;
    final result = await CustomAlertDialog.show(
      context: context,
      title: 'Konfirmasi Batal Arsip',
      message: 'Apakah Anda yakin ingin membatalkan arsip ${selectedIds.length} item?',
      cancelText: 'Batal',
      confirmText: 'Batal Arsip',
      confirmColor: colorScheme.primary,
      icon: Icons.unarchive_outlined,
      iconColor: colorScheme.primary,
    );

    if (result == true && mounted) {
      final selectionBloc = context.read<SelectionBloc>();
      
      // Perform unarchive
      selectionBloc.add(UnarchiveItems(selectedIds));
      
      // Wait for a short moment to ensure the bloc state is updated
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Synchronize with current bloc state
      _synchronizeArchivedStudents();
      
      // Clear selection mode
      if (mounted) {
        selectionBloc.add(ClearSelectionMode());
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: ('${selectedIds.length} item berhasil dibatalkan arsip'),
            icon: Icons.check_circle_outline,  
            backgroundColor: Colors.green.shade800,  
          ),
        );

        // Check if no items left, then pop the page
        if (_filteredStudents.isEmpty) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<void> _refreshArchiveList() async {
    if (!mounted) return;
    _synchronizeArchivedStudents();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectionBloc, SelectionState>(
      listenWhen: (previous, current) => 
          previous.archivedIds.length != current.archivedIds.length,
      listener: (context, state) {
        _synchronizeArchivedStudents();
      },
      child: BlocBuilder<SelectionBloc, SelectionState>(
        builder: (context, selectionState) {
          return PopScope(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    selectionState.isSelectionMode ? Icons.close : Icons.arrow_back,
                  ),
                  onPressed: () {
                    if (selectionState.isSelectionMode) {
                      context.read<SelectionBloc>().add(ClearSelectionMode());
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                title: const Text('Arsip Mahasiswa'),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchField(
                      onChanged: _filterStudents,
                      onFilterPressed: () {},
                    ),
                  ),
                ),
                actions: [
                  if (selectionState.isSelectionMode && selectionState.selectedIds.isNotEmpty)
                    TextButton.icon(
                      onPressed: () =>
                          _showUnarchiveConfirmation(context, selectionState.selectedIds),
                      icon: const Icon(Icons.unarchive, color: Colors.white),
                      label: const Text(
                        'Batal Arsip',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
              body: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refreshArchiveList,
                child: _filteredStudents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.archive_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Tidak ada mahasiswa yang diarsipkan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredStudents.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final student = _filteredStudents[index];
                          return _buildStudentCard(student);
                        },
                      ),
              ),
              floatingActionButton: selectionState.isSelectionMode &&
                      selectionState.selectedIds.isNotEmpty
                  ? _buildFloatingActionButton(context, selectionState.selectedIds)
                  : null,
            ),
          );
        },
      ),
    );
  }
}

  Widget _buildStudentCard(LecturerStudentsEntity student) {
    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {

        return StudentCard(
          student: student,
          isSelected: state.selectedIds.contains(student.id),
          isFinished: student.isFinished,
          onTap: () => _handleStudentTap(context, student),
          onLongPress: () => _handleStudentLongPress(context, student),
        );
      },
    );
  }

Widget _buildFloatingActionButton(BuildContext context, Set<int> selectedIds) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 300),
    builder: (context, value, child) {
      return Transform.scale(
        scale: value,
        child: FloatingActionButton(
          onPressed: () => showSendMessageBottomSheet(context, selectedIds),
          backgroundColor: AppColors.lightPrimary,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.message,
            color: AppColors.lightWhite,
            size: 24,
          ),
        ),
      );
    },
  );
}


  void _handleStudentTap(BuildContext context, LecturerStudentsEntity student) {
    final state = context.read<SelectionBloc>().state;
    if (state.isSelectionMode) {
      context.read<SelectionBloc>().add(ToggleItemSelection(student.id));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailStudentPage(id: student.id),
        ),
      );
    }
  }

  void _handleStudentLongPress(
      BuildContext context, LecturerStudentsEntity student) {
    final state = context.read<SelectionBloc>().state;
    if (!state.isSelectionMode) {
      context.read<SelectionBloc>().add(ToggleSelectionMode());
      context.read<SelectionBloc>().add(ToggleItemSelection(student.id));
    }
  }
