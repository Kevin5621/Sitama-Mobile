import 'package:flutter/material.dart';
import 'guidace_item.dart';

class FilterDialog extends StatelessWidget {
  final BimbinganStatus? currentFilter;
  final ValueChanged<BimbinganStatus?> onFilterChanged;

  const FilterDialog({
    Key? key,
    required this.currentFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter by Status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('All'),
            leading: Radio<BimbinganStatus?>(
              value: null,
              groupValue: currentFilter,
              onChanged: (BimbinganStatus? value) {
                onFilterChanged(value);
                Navigator.of(context).pop();
              },
            ),
          ),
          ...BimbinganStatus.values.map((status) {
            return ListTile(
              title: Text(status.toString().split('.').last),
              leading: Radio<BimbinganStatus?>(
                value: status,
                groupValue: currentFilter,
                onChanged: (BimbinganStatus? value) {
                  onFilterChanged(value);
                  Navigator.of(context).pop();
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}