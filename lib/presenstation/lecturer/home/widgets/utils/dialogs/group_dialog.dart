import 'package:flutter/material.dart';
import 'package:sistem_magang/data/models/group.dart';

class GroupDialogForm extends StatefulWidget {
  final String? initialTitle;
  final IconData? initialIcon;
  final Color? initialIconColor;
  final String title;
  final VoidCallback? onCancel;
  final void Function(String title, IconData icon, Color iconColor) onSubmit;

  const GroupDialogForm({
    super.key,
    this.initialTitle,
    this.initialIcon,
    this.initialIconColor,
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
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    selectedIcon = widget.initialIcon ?? Icons.group;
    selectedColor = widget.initialIconColor ?? Colors.blue;
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
          const SizedBox(height: 16),
          const Text('Pilih Warna'),
          const SizedBox(height: 8),
          _buildColorSelector(),
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
            widget.onSubmit(titleController.text, selectedIcon, selectedColor);
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
        alignment: WrapAlignment.center,
        children: [
          for (final icon in GroupModel.availableIcons.values)
            Material(
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(() => selectedIcon = icon),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selectedIcon == icon
                        ? selectedColor.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedIcon == icon
                          ? selectedColor
                          : Colors.transparent,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: selectedIcon == icon
                        ? selectedColor
                        : colorScheme.onSurface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    return Center(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          for (final color in GroupModel.colorPalette)
            GestureDetector(
              onTap: () => setState(() => selectedColor = color),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: selectedColor == color
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                    )
                  ],
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
  Color? initialIconColor,
  required String title,
}) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => GroupDialogForm(
      initialTitle: initialTitle,
      initialIcon: initialIcon,
      initialIconColor: initialIconColor,
      title: title,
      onSubmit: (title, icon, color) {
        Navigator.of(context).pop({
          'title': title,
          'icon': icon,
          'color': color,
        });
      },
    ),
  );
}