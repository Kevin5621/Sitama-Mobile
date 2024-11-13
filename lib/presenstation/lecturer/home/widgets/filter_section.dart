import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/filter_jurusan.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/filter_tahun.dart';

class FilterSection extends StatelessWidget {
  final VoidCallback? onArchiveTap;
  final VoidCallback? onGroupTap;

  const FilterSection({
    super.key,
    this.onArchiveTap,
    this.onGroupTap,
  });

  void _showCreateGroupDialog(BuildContext context, Set<int> selectedIds) {
    showDialog(
      context: context,
      builder: (context) => CreateGroupDialog(selectedIds: selectedIds),
    );
  }

  Widget _buildSelectionModeButtons(BuildContext context, SelectionState state) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: state.selectedIds.isEmpty
                ? null
                : () => _showCreateGroupDialog(context, state.selectedIds),
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

class CreateGroupDialog extends StatefulWidget {
  final Set<int> selectedIds;

  const CreateGroupDialog({
    Key? key,
    required this.selectedIds,
  }) : super(key: key);

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  IconData _selectedIcon = Icons.group;

  final List<IconData> _availableIcons = [
    Icons.group,
    Icons.school,
    Icons.work,
    Icons.star,
    Icons.favorite,
    Icons.rocket_launch,
    Icons.psychology,
    Icons.science,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Group'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                hintText: 'Enter group name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a group name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Select Icon'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableIcons.map((icon) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedIcon == icon
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     if (_formKey.currentState!.validate()) {
        //       context.read<SelectionBloc>().add(
        //             CreateGroup(
        //               title: _titleController.text,
        //               icon: _selectedIcon,
        //               studentIds: widget.selectedIds,
        //             ),
        //           );
        //       Navigator.of(context).pop();
        //     }
        //   },
        //   child: const Text('Create'),
        // ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}