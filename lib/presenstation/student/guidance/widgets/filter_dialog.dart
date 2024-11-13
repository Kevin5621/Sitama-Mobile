import 'package:flutter/material.dart';

class FilterDropdown extends StatefulWidget {
  final Function(String) onFilterChanged;

  const FilterDropdown({Key? key, required this.onFilterChanged}) : super(key: key);

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  String _selectedFilter = 'All'; // Default value

  final List<String> _filterOptions = [
    'All',
    'Approved',
    'InProgress',
    'Rejected',
    'Updated',
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.filter_list_outlined,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onSelected: (String value) {
        setState(() {
          _selectedFilter = value;
        });
        widget.onFilterChanged(value);
      },
      itemBuilder: (BuildContext context) {
        return _filterOptions.map((String filter) {
          return PopupMenuItem<String>(
            value: filter,
            child: Row(
              children: [
                if (_selectedFilter == filter)
                  Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                    size: 18,
                  ),
                SizedBox(width: _selectedFilter == filter ? 8 : 28),
                Text(filter),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}