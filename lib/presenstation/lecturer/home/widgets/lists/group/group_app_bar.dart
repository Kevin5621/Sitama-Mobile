import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/search_field.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/lists/group/group_actions.dart';

class GroupAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GroupModel group;
  final String groupId;
  final SelectionState selectionState;
  final Function(String) onFilterChanged;
  final List<LecturerStudentsEntity> filteredStudents;

  const GroupAppBar({
    super.key,
    required this.group,
    required this.groupId,
    required this.selectionState,
    required this.onFilterChanged,
    required this.filteredStudents,
  });

  @override
  Size get preferredSize => const Size.fromHeight(120); 

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
            onChanged: onFilterChanged,
            onFilterPressed: () {},
          ),
        ),
      ),
      actions: [
        if (selectionState.isSelectionMode && selectionState.selectedIds.isNotEmpty)
          TextButton.icon(
            onPressed: () => GroupActions.showUngroupConfirmation(
              context, 
              selectionState.selectedIds,
              filteredStudents.length,
            ),
            icon: const Icon(Icons.group, color: Colors.white),
            label: const Text(
              'Keluarkan',
              style: TextStyle(color: Colors.white),
            ),
          )
        else
          _buildMoreMenu(context),
      ],
    );
  }

  Widget _buildMoreMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            GroupActions.showEditDialog(context, group, groupId);
            break;
          case 'delete':
            GroupActions.showDeleteConfirmation(context, group, groupId);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: AppColors.lightPrimary,),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: AppColors.lightDanger,),
              SizedBox(width: 8),
              Text('Hapus', style: TextStyle(color: AppColors.lightDanger)),
            ],
          ),
        ),
      ],
    );
  }
}