import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/features/lecturer/domain/entities/lecturer_home_entity.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_bloc.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_state.dart';
import 'package:sitama/features/lecturer/ui/home/widgets/section/group/group_content.dart';
import 'package:sitama/features/lecturer/ui/home/widgets/utils/helper/group_app_bar.dart';
import 'package:sitama/features/lecturer/ui/home/widgets/utils/helper/group_fab.dart';

// Page representing a student group with detailed view and interactions
class GroupPage extends StatefulWidget {
  // List of students in the group and group identifier
  final List<LecturerStudentsEntity> groupStudents;
  final String groupId;

  const GroupPage({
    super.key,
    required this.groupStudents,
    required this.groupId,
  });

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  // List to store filtered students based on group and search
  List<LecturerStudentsEntity> _filteredStudents = [];
  
  // Refresh indicator key for pull-to-refresh functionality
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Synchronize students when page is first loaded
    _synchronizeGroupStudents();
  }

  // Synchronize students based on current group selection
  void _synchronizeGroupStudents() {
    final selectionBloc = context.read<SelectionBloc>();
    final group = selectionBloc.state.groups[widget.groupId];
    
    // Filter students based on group membership
    setState(() {
      _filteredStudents = widget.groupStudents
          .where((student) => group!.studentIds.contains(student.user_id))
          .toList();
    });
  }

  @override
  void didUpdateWidget(GroupPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Resynthesize students if group students change
    if (widget.groupStudents != oldWidget.groupStudents) {
      _synchronizeGroupStudents();
    }
  }

  // Filter students based on search query
  void _filterStudents(String query) {
    final selectionBloc = context.read<SelectionBloc>();
    final groupIds = selectionBloc.state.groupIds;
    
    if (query.isEmpty) {
      setState(() {
        _filteredStudents = widget.groupStudents
            .where((student) => groupIds.contains(student.id))
            .toList();
      });
      return;
    }

    setState(() {
      _filteredStudents = widget.groupStudents
          .where((student) => 
              groupIds.contains(student.id) &&
              (student.name.toLowerCase().contains(query.toLowerCase()) ||
              student.username.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  // Refresh group list
  Future<void> _refreshGroupList() async {
    if (!mounted) return;
    _synchronizeGroupStudents();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectionBloc, SelectionState>(
      // Listen for changes in group student composition
      listenWhen: (previous, current) => 
          previous.groups[widget.groupId]?.studentIds != 
          current.groups[widget.groupId]?.studentIds,
      listener: (context, state) {
        _synchronizeGroupStudents();
      },
      child: BlocBuilder<SelectionBloc, SelectionState>(
        builder: (context, selectionState) {
          final group = selectionState.groups[widget.groupId];

          return PopScope(
            child: Scaffold(
              appBar: GroupAppBar(
                group: group!,
                groupId: widget.groupId,
                selectionState: selectionState,
                onFilterChanged: _filterStudents,
                filteredStudents: _filteredStudents,
              ),
              body: GroupContent(
                refreshIndicatorKey: _refreshIndicatorKey,
                onRefresh: _refreshGroupList,
                filteredStudents: _filteredStudents,
              ),
              floatingActionButton: selectionState.isSelectionMode && 
                                    selectionState.selectedIds.isNotEmpty
                  ? const GroupFAB()
                  : null,
            ),
          );
        },
      ),
    );
  }
}