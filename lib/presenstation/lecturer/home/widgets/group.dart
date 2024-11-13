<<<<<<< HEAD
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sistem_magang/common/widgets/alert.dart';
// import 'package:sistem_magang/core/config/assets/app_images.dart';
// import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
// import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
// import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
// import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
// import 'package:sistem_magang/presenstation/lecturer/home/widgets/student_card.dart';

// class GroupPage extends StatefulWidget {
//   final String groupId;
//   final List<LecturerStudentsEntity> students;

//   const GroupPage({
//     super.key,
//     required this.groupId,
//     required this.students,
//   });

//   @override
//   State<GroupPage> createState() => _GroupPageState();
// }

// class _GroupPageState extends State<GroupPage> {
//   late GroupModel _group;
//   late String _newGroupTitle;
//   late IconData _newGroupIcon;
//   bool _isEditingGroup = false;

//   @override
//   void initState() {
//     super.initState();
//     _group = context.read<SelectionBloc>().state.groups.firstWhere((g) => g.id == widget.groupId);
//     _newGroupTitle = _group.title;
//     _newGroupIcon = _group.icon;
//   }

//   void _handleSaveGroup() {
//     context.read<SelectionBloc>().add(
//           UpdateGroup(
//             groupId: _group.id,
//             title: _newGroupTitle,
//             icon: _newGroupIcon,
//           ),
//         );
//     setState(() {
//       _isEditingGroup = false;
//     });
//   }

//   void _handleDeleteGroup() {
//     showDialog(
//       context: context,
//       builder: (context) => CustomAlertDialog(
//         title: 'Delete Group',
//         message: 'Are you sure you want to delete this group?',
//         onConfirm: () {
//           context.read<SelectionBloc>().add(DeleteGroup(groupId: _group.id));
//           Navigator.of(context).pop();
//           Navigator.of(context).pop();
//         },
//       ),
//     );
//   }

//   void _handleAddToGroup() {
//     // Implement logic to add students to the group
//   }

//   void _handleRemoveFromGroup(int studentId) {
//     context.read<SelectionBloc>().add(
//           RemoveFromGroup(
//             groupId: _group.id,
//             studentIds: {studentId},
//           ),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Group Details'),
//         actions: [
//           if (_isEditingGroup)
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: _handleSaveGroup,
//             ),
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () => setState(() {
//               _isEditingGroup = true;
//             }),
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: _handleDeleteGroup,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_isEditingGroup)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormField(
//                     initialValue: _newGroupTitle,
//                     onChanged: (value) => _newGroupTitle = value,
//                     decoration: const InputDecoration(
//                       labelText: 'Group Name',
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   IconPicker(
//                     initialIcon: _newGroupIcon,
//                     onIconPicked: (icon) => _newGroupIcon = icon,
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         onPressed: () => setState(() {
//                           _isEditingGroup = false;
//                         }),
//                         child: const Text('Cancel'),
//                       ),
//                       const SizedBox(width: 8),
//                       ElevatedButton(
//                         onPressed: _handleSaveGroup,
//                         child: const Text('Save'),
//                       ),
//                     ],
//                   ),
//                 ],
//               )
//             else
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(_group.icon),
//                       const SizedBox(width: 8),
//                       Text(
//                         _group.title,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Text('Members (${_group.studentIds.length})'),
//                   const SizedBox(height: 8),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: _group.studentIds.length,
//                       itemBuilder: (context, index) {
//                         final studentId = _group.studentIds[index];
//                         final student = widget.students.firstWhere((s) => s.id == studentId);
//                         return _buildStudentCard(student, studentId);
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton.icon(
//                     onPressed: _handleAddToGroup,
//                     icon: const Icon(Icons.add),
//                     label: const Text('Add Students'),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget _buildStudentCard(LecturerStudentsEntity student, int id) {
//     return BlocBuilder<SelectionBloc, SelectionState>(
//       builder: (context, state) {
//         List<String> activitiesList = [];
//         if (student.activities['is_in_progress'] == true) {
//           activitiesList.add('in-progress');
//         }
//         if (student.activities['is_updated'] == true) {
//           activitiesList.add('updated');
//         }
//         if (student.activities['is_rejected'] == true) {
//           activitiesList.add('rejected');
//         }

//         return StudentCard(
//           id: id,
//           student: student,
//           imageUrl: student.photo_profile ?? AppImages.defaultProfile,
//           name: student.name,
//           jurusan: student.major,
//           kelas: student.the_class,
//           nim: student.username,
//           isSelected: state.selectedIds.contains(id),
//           activities: activitiesList,
//           onTap: () => _handleStudentTap(context, student),
//           onLongPress: () => _handleStudentLongPress(context, student),
//           onRemove: () => _handleRemoveFromGroup(id),
//         );
//       },
//     );
//   }

//   void _handleStudentTap(BuildContext context, LecturerStudentsEntity student) {
//     final state = context.read<SelectionBloc>().state;
//     if (state.isSelectionMode) {
//       context.read<SelectionBloc>().add(ToggleItemSelection(student.id));
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DetailStudentPage(id: student.id),
//         ),
//       );
//     }
//   }

//   void _handleStudentLongPress(
//       BuildContext context, LecturerStudentsEntity student) {
//     final state = context.read<SelectionBloc>().state;
//     if (!state.isSelectionMode) {
//       context.read<SelectionBloc>().add(ToggleSelectionMode());
//       context.read<SelectionBloc>().add(ToggleItemSelection(student.id));
//     }
//   }
=======
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/common/widgets/search_field.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/student_card.dart';

class GroupPage extends StatefulWidget {
  final List<LecturerStudentsEntity> groupStudents;

  const GroupPage({
    super.key,
    required this.groupStudents,
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
    // Get current group IDs from bloc
    final groupIds = context.read<SelectionBloc>().state.groupIds;
    
    // Filter students based on current group IDs
    setState(() {
      _filteredStudents = widget.groupStudents
          .where((student) => groupIds.contains(student.id))
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

  Future<bool> _onWillPop() async {
    final selectionState = context.read<SelectionBloc>().state;
    if (selectionState.isSelectionMode) {
      context.read<SelectionBloc>().add(ToggleSelectionMode());
      return false;
    }
    return true;
  }
  
  Future<void> _showUngroupConfirmation(
    BuildContext context, Set<int> selectedIds) async {
    final colorScheme = Theme.of(context).colorScheme;
    final result = await CustomAlertDialog.show(
      context: context,
      title: 'Konfirmasi Batal Arsip',
      message: 'Apakah Anda yakin ingin membatalkan arsip ${selectedIds.length} item?',
      cancelText: 'Batal',
      confirmText: 'Batal Arsip',
      confirmColor: colorScheme.primary,
      icon: Icons.group_outlined,
      iconColor: colorScheme.primary,
    );

    if (result == true && mounted) {
      final selectionBloc = context.read<SelectionBloc>();
      
      // Perform ungroup
      selectionBloc.add(UnGroupItems(selectedIds));
      
      // Wait for a short moment to ensure the bloc state is updated
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Synchronize with current bloc state
      _synchronizeGroupdStudents();
      
      // Clear selection mode
      if (mounted) {
        selectionBloc.add(ClearSelectionMode());
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${selectedIds.length} item berhasil dibatalkan arsip'),
            duration: const Duration(seconds: 2),
          ),
        );

        // Check if no items left, then pop the page
        if (_filteredStudents.isEmpty) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<void> _refreshGroupList() async {
    if (!mounted) return;
    _synchronizeGroupdStudents();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectionBloc, SelectionState>(
      listenWhen: (previous, current) => 
          previous.groupIds.length != current.groupIds.length,
      listener: (context, state) {
        _synchronizeGroupdStudents();
      },
      child: BlocBuilder<SelectionBloc, SelectionState>(
        builder: (context, selectionState) {
          return WillPopScope(
            onWillPop: _onWillPop,
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
                      onFilterPressed: () {}, // Bisa diimplementasikan jika diperlukan
                    ),
                  ),
                ),
                actions: [
                  if (selectionState.isSelectionMode && selectionState.selectedIds.isNotEmpty)
                    TextButton.icon(
                      onPressed: () =>
                          _showUngroupConfirmation(context, selectionState.selectedIds),
                      icon: const Icon(Icons.group, color: Colors.white),
                      label: const Text(
                        'Batal Arsip',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
              body: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refreshGroupList,
                child: _filteredStudents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.group_outlined,
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
            ),
          );
        },
      ),
    );
  }

  // ... rest of the methods remain the same ...
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
>>>>>>> 6a345e1 (test)
