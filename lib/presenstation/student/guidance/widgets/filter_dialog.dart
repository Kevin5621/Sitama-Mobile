import 'package:flutter/material.dart';

class FilterDropdown extends StatefulWidget {
  final Function(String) onFilterChanged;

  const FilterDropdown({super.key, required this.onFilterChanged});

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  String _selectedFilter = 'All'; // Default value

  // Mapping between display labels and backend values replaced with Bing
  final Map<String, String> _filterOptions = {
    'Semua': 'All',
    'Disetujui': 'Approved',
    'Belum Diperiksa': 'InProgress',
    'Revisi': 'Rejected',
    'Diperbarui': 'Updated',
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.filter_list_outlined,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onSelected: (String displayLabel) {
        // Get the backend value based on the selected label
        String backendValue = _filterOptions[displayLabel]!;
        setState(() {
          _selectedFilter = backendValue;
        });
        // Send backend value to onFilterChanged function
        widget.onFilterChanged(backendValue);
      },
      itemBuilder: (BuildContext context) {
        return _filterOptions.keys.map((String displayLabel) {
          String backendValue = _filterOptions[displayLabel]!;
          return PopupMenuItem<String>(
            value: displayLabel,
            child: Row(
              children: [
                if (_selectedFilter == backendValue)
                  Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                    size: 18,
                  ),
                SizedBox(width: _selectedFilter == backendValue ? 8 : 28),
                Text(displayLabel),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}