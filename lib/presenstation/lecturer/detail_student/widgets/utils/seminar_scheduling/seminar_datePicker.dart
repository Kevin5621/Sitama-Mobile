import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeminarDatePicker extends StatelessWidget {
  final ValueNotifier<DateTime?> selectedDateNotifier;

  const SeminarDatePicker({
    super.key,
    required this.selectedDateNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<DateTime?>(
      valueListenable: selectedDateNotifier,
      builder: (context, selectedDate, child) {
        return GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (pickedDate != null) {
              selectedDateNotifier.value = pickedDate;
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: selectedDate != null 
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
                Text(
                  selectedDate != null
                    ? DateFormat('dd MMMM yyyy').format(selectedDate)
                    : 'Pilih Tanggal Seminar',
                  style: TextStyle(
                    color: selectedDate != null
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}