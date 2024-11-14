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
    
    // Filter students berdasarkan studentIds yang ada di group
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

  Future<bool> _onWillPop() async {
    final selectionState = context.read<SelectionBloc>().state;
    if (selectionState.isSelectionMode) {
      context.read<SelectionBloc>().add(ToggleSelectionMode());
      return false;
    }
    return true;
  }
  
  Future<void> _showUngroupConfirmation(BuildContext context, Set<int> selectedIds) async {
    // Cek apakah setelah ungroup masih ada anggota tersisa
    final remainingMembers = _filteredStudents.length - selectedIds.length;
    
    if (remainingMembers < 1) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group harus memiliki minimal 1 anggota'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    // Lanjutkan dengan konfirmasi ungroup seperti sebelumnya
    final colorScheme = Theme.of(context).colorScheme;
    final result = await CustomAlertDialog.show(
      context: context,
      title: 'Konfirmasi Keluarkan Mahasiswa dari Group',
      message: 'Apakah Anda Mengeluarkan Mahasiswa dari Group ${selectedIds.length} item?',
      cancelText: 'Batal',
      confirmText: 'Ya',
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
            content: Text('${selectedIds.length} item berhasil dikeluarkan dari Group'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _refreshGroupList() async {
    if (!mounted) return;
    _synchronizeGroupdStudents();
  }

  Future<void> _showEditDialog(BuildContext context, GroupModel group) async {
    final TextEditingController titleController = TextEditingController(text: group.title);
    IconData selectedIcon = group.icon;

    final List<IconData> availableIcons = [
    Icons.group,
    Icons.school,
    Icons.work,
    Icons.star,
    Icons.favorite,
    Icons.rocket_launch,
    Icons.psychology,
    Icons.science,
    ];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Nama Group',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Pilih Icon:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableIcons.map((icon) {
                return InkWell(
                  onTap: () {
                    selectedIcon = icon;
                    Navigator.pop(context, {
                      'title': titleController.text,
                      'icon': icon,
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: icon == selectedIcon 
                            ? Theme.of(context).primaryColor 
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'title': titleController.text,
                'icon': selectedIcon,
              });
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    ).then((value) {
      if (value != null && mounted) {
        context.read<SelectionBloc>().add(
          UpdateGroup(
            groupId: widget.groupId,
            title: value['title'],
            icon: value['icon'],
          ),
        );
      }
    });
  }

  Future<void> _showDeleteConfirmation(BuildContext context, GroupModel group) async {
    final result = await CustomAlertDialog.show(
      context: context,
      title: 'Konfirmasi Hapus Grup',
      message: group.studentIds.isEmpty 
          ? 'Apakah Anda yakin ingin menghapus grup ini?'
          : 'Grup masih memiliki ${group.studentIds.length} mahasiswa. Menghapus grup akan mengeluarkan semua mahasiswa. Lanjutkan?',
      cancelText: 'Batal',
      confirmText: 'Hapus',
      confirmColor: Colors.red,
      icon: Icons.delete_outline,
      iconColor: Colors.red,
    );

    if (result == true && mounted) {
      // Keluarkan semua mahasiswa dari group terlebih dahulu
      if (group.studentIds.isNotEmpty) {
        context.read<SelectionBloc>().add(UnGroupItems(Set.from(group.studentIds)));
      }
      // Kemudian hapus group
      context.read<SelectionBloc>().add(DeleteGroup(widget.groupId));
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    }
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
                title: Text(group.title),
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
                          _showUngroupConfirmation(context, selectionState.selectedIds),
                      icon: const Icon(Icons.group, color: Colors.white),
                      label: const Text(
                        'Keluarkan',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showEditDialog(context, group);
                            break;
                          case 'delete':
                            _showDeleteConfirmation(context, group);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Hapus', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
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
}