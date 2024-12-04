import 'package:flutter/material.dart';

class SeminarMessageField extends StatelessWidget {
  final TextEditingController controller;

  const SeminarMessageField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.3),
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        style: TextStyle(
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: "Catatan tambahan untuk seminar (opsional)",
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
          filled: true,
          fillColor: colorScheme.surface,
        ),
      ),
    );
  }
}