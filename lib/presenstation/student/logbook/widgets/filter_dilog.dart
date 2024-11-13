// sort_filter_button.dart
import 'package:flutter/material.dart';

enum SortMode {
  newest,
  oldest
}

class SortFilterButton extends StatefulWidget {
  final Function(SortMode) onSortModeChanged;

  const SortFilterButton({
    Key? key,
    required this.onSortModeChanged,
  }) : super(key: key);

  @override
  State<SortFilterButton> createState() => _SortFilterButtonState();
}

class _SortFilterButtonState extends State<SortFilterButton> {
  SortMode _selectedMode = SortMode.newest; // Default value

  String _getSortModeName(SortMode mode) {
    switch (mode) {
      case SortMode.newest:
        return 'Terbaru';
      case SortMode.oldest:
        return 'Terlama';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortMode>(
      icon: Icon(
        Icons.filter_list_outlined,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onSelected: (SortMode value) {
        setState(() {
          _selectedMode = value;
        });
        widget.onSortModeChanged(value);
      },
      itemBuilder: (BuildContext context) {
        return SortMode.values.map((SortMode mode) {
          return PopupMenuItem<SortMode>(
            value: mode,
            child: Row(
              children: [
                if (_selectedMode == mode)
                  Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                    size: 18,
                  ),
                SizedBox(width: _selectedMode == mode ? 8 : 28),
                Text(_getSortModeName(mode)),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}