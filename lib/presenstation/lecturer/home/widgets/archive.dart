// archive_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/student_card.dart';

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
  late TextEditingController _searchController;
  List<LecturerStudentsEntity> _filteredStudents = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  Future<bool> _onWillPop() async {
    final selectionState = context.read<SelectionBloc>().state;
    if (selectionState.isSelectionMode) {
      context.read<SelectionBloc>().add(ToggleSelectionMode());
      return false;
    }
    return true;
  }

  Future<void> _showUnarchiveConfirmation(
      BuildContext context, Set<int> selectedIds) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Unarchive'),
          content: Text(
              'Are you sure you want to unarchive ${selectedIds.length} item(s)?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Unarchive'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      final selectionBloc = context.read<SelectionBloc>();
      
      // Perform unarchive
      selectionBloc.add(UnarchiveItems(selectedIds));
      
      // Wait for a short moment to ensure the bloc state is updated
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Synchronize with current bloc state
      _synchronizeArchivedStudents();
      
      // Exit selection mode
      selectionBloc.add(ToggleSelectionMode());
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${selectedIds.length} items unarchived'),
            duration: const Duration(seconds: 2),
          ),
        );
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
          return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
        appBar: AppBar(
          leading: BlocBuilder<SelectionBloc, SelectionState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isSelectionMode ? Icons.close : Icons.arrow_back,
                ),
                onPressed: () {
                  if (state.isSelectionMode) {
                    context.read<SelectionBloc>().add(ToggleSelectionMode());
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
          title: const Text('Archived Students'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterStudents,
                decoration: InputDecoration(
                  hintText: 'Search archived students...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          actions: [
            BlocBuilder<SelectionBloc, SelectionState>(
              builder: (context, state) {
                if (state.isSelectionMode && state.selectedIds.isNotEmpty) {
                  return TextButton.icon(
                    onPressed: () =>
                        _showUnarchiveConfirmation(context, state.selectedIds),
                    icon: const Icon(Icons.unarchive, color: Colors.white),
                    label: const Text(
                      'Unarchive',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
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
                    children: [
                      const Icon(
                        Icons.archive_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty
                            ? 'No archived students'
                            : 'No results found',
                        style: const TextStyle(
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
        List<String> activitiesList = [];
        if (student.activities['is_in_progress'] == true) {
          activitiesList.add('in-progress');
        }
        if (student.activities['is_updated'] == true) {
          activitiesList.add('updated');
        }
        if (student.activities['is_rejected'] == true) {
          activitiesList.add('rejected');
        }

        return StudentCard(
          id: student.id,
          imageUrl: student.photo_profile ?? AppImages.defaultProfile,
          name: student.name,
          jurusan: student.major,
          kelas: student.the_class,
          nim: student.username,
          isSelected: state.selectedIds.contains(student.id),
          activities: activitiesList,
          onTap: () => _handleStudentTap(context, student),
          onLongPress: () => _handleStudentLongPress(context, student),
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
