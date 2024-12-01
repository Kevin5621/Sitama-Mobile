import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/section/group/group_app_bar.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/section/group/group_body.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/section/group/group_fab.dart';

class GroupPage extends StatefulWidget {
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
  List<LecturerStudentsEntity> _filteredStudents = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _synchronizeGroupdStudents();
  }

  void _synchronizeGroupdStudents() {
    final group = context.read<SelectionBloc>().state.groups[widget.groupId];
    
    if (group == null) {
      setState(() {
        _filteredStudents = [];
      });
      return;
    }
    
    setState(() {
      _filteredStudents = widget.groupStudents
          .where((student) => group.studentIds.contains(student.id))
          .toList();
    });
  }

  @override
  void didUpdateWidget(GroupPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.groupStudents != oldWidget.groupStudents) {
      _synchronizeGroupdStudents();
    }
  }

  void _filterStudents(String query) {
    final groupIds = context.read<SelectionBloc>().state.groupIds;
    
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

  Future<void> _refreshGroupList() async {
    if (!mounted) return;
    _synchronizeGroupdStudents();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectionBloc, SelectionState>(
      listenWhen: (previous, current) => 
          previous.groups[widget.groupId]?.studentIds != 
          current.groups[widget.groupId]?.studentIds,
      listener: (context, state) {
        _synchronizeGroupdStudents();
      },
      child: BlocBuilder<SelectionBloc, SelectionState>(
        builder: (context, selectionState) {
          final group = selectionState.groups[widget.groupId];
          
          if (group == null) {
            return const Scaffold(
              body: Center(
                child: Text('Group not found'),
              ),
            );
          }

          return PopScope(
            child: Scaffold(
              appBar: GroupAppBar(
                group: group,
                groupId: widget.groupId,
                selectionState: selectionState,
                onFilterChanged: _filterStudents,
                filteredStudents: _filteredStudents,
              ),
              body: GroupBody(
                refreshIndicatorKey: _refreshIndicatorKey,
                onRefresh: _refreshGroupList,
                filteredStudents: _filteredStudents,
              ),
              floatingActionButton: selectionState.isSelectionMode && 
                                  selectionState.selectedIds.isNotEmpty
                  ? GroupFAB()
                  : null,
            ),
          );
        },
      ),
    );
  }
}