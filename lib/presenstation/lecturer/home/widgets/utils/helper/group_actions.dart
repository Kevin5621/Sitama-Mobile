import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/common/widgets/custom_snackbar.dart';
import 'package:sistem_magang/data/models/group.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/utils/dialogs/group_dialog.dart';

class GroupActions {
  static Future<void> showUngroupConfirmation(
    BuildContext context, 
    Set<int> selectedIds,
    int totalMembers,
  ) async {
    final remainingMembers = totalMembers - selectedIds.length;
    
    if (remainingMembers < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: ('Group harus memiliki minimal 1 anggota'),
            icon: Icons.warning_outlined,  
            backgroundColor: Colors.orange.shade800,  
          ),
        );
      return;
    }

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

    if (result == true) {
      final selectionBloc = context.read<SelectionBloc>();
      
      // Perform ungroup
      selectionBloc.add(UnGroupItems(selectedIds));
      
      // Wait for state update
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Clear selection mode
      selectionBloc.add(ClearSelectionMode());
      
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: '${selectedIds.length} item berhasil dikeluarkan dari Group',
          icon: Icons.check_circle_outline,  
          backgroundColor: Colors.green.shade800,  
        ),
      );
    }
  }

  static Future<void> showEditDialog(
    BuildContext context, 
    GroupModel group,
    String groupId,
  ) async {
    final result = await showGroupDialog(
      context: context,
      initialTitle: group.title,
      initialIcon: group.icon,
      title: 'Edit Group',
    );

    if (result != null) {
      context.read<SelectionBloc>().add(
        UpdateGroup(
          groupId: groupId,
          title: result['title'],
          icon: result['icon'],
          color: result['color'],
        ),
      );
    }
  }

  static Future<void> showDeleteConfirmation(
    BuildContext context, 
    GroupModel group,
    String groupId,
  ) async {
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

    if (result == true) {
      // Keluarkan semua mahasiswa dari group terlebih dahulu
      if (group.studentIds.isNotEmpty) {
        context.read<SelectionBloc>().add(UnGroupItems(Set.from(group.studentIds)));
      }
      // Kemudian hapus group
      context.read<SelectionBloc>().add(DeleteGroup(groupId));
      Navigator.pop(context); 
    }
  }
}