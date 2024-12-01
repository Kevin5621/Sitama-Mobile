import 'package:flutter/material.dart';

class GroupDialogForm extends StatefulWidget {
  final String? initialTitle;
  final IconData? initialIcon;
  final String title;
  final VoidCallback? onCancel;
  final void Function(String title, IconData icon) onSubmit;

  const GroupDialogForm({
    super.key,
    this.initialTitle,
    this.initialIcon,
    required this.title,
    this.onCancel,
    required this.onSubmit,
  });

  @override
  State<GroupDialogForm> createState() => _GroupDialogFormState();
}

class _GroupDialogFormState extends State<GroupDialogForm> {
  late final TextEditingController titleController;
  late IconData selectedIcon;

  static const List<IconData> availableIcons = [
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
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    selectedIcon = widget.initialIcon ?? Icons.group;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Nama Group',
              hintText: 'Masukkan nama group',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Nama group tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('Pilih Icon'),
          const SizedBox(height: 8),
          _buildIconSelector(colorScheme),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(titleController.text, selectedIcon);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            elevation: 0,
          ),
          child: Text(widget.initialTitle != null ? 'Simpan' : 'Buat'),
        ),
      ],
    );
  }

  Widget _buildIconSelector(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final icon in availableIcons)
            Material(
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(() => selectedIcon = icon),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selectedIcon == icon
                        ? colorScheme.primary.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedIcon == icon
                          ? colorScheme.primary
                          : Colors.transparent,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: selectedIcon == icon
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Utility function to show group dialog
Future<Map<String, dynamic>?> showGroupDialog({
  required BuildContext context,
  String? initialTitle,
  IconData? initialIcon,
  required String title,
}) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => GroupDialogForm(
      initialTitle: initialTitle,
      initialIcon: initialIcon,
      title: title,
      onSubmit: (title, icon) {
        Navigator.of(context).pop({
          'title': title,
          'icon': icon,
        });
      },
    ),
  );
}