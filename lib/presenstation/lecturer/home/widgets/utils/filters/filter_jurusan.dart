import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sitama/domain/entities/lecturer_home_entity.dart';

// A customizable dropdown widget for filtering students by their majors
// Includes search functionality and supports theming
class FilterJurusan extends StatefulWidget {
  // Required parameters for basic functionality
  final List<LecturerStudentsEntity> students;
  final Function(List<LecturerStudentsEntity>) onFilterChanged;
  
  // Optional parameters for customization
  final String? initialValue;
  final Color? primaryColor;
  final Color? backgroundColor;
  final TextStyle? hintStyle;
  final TextStyle? itemStyle;
  
  const FilterJurusan({
    super.key,
    required this.students,
    required this.onFilterChanged,
    this.initialValue,
    this.primaryColor,
    this.backgroundColor,
    this.hintStyle,
    this.itemStyle,
  });

  @override
  State<FilterJurusan> createState() => _FilterJurusanState();
}

class _FilterJurusanState extends State<FilterJurusan> {
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  late List<String> uniqueMajors;
  
  // Initialize state and prepare the list of unique majors
  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    // Extract and sort unique majors, adding "Semua Jurusan" as the first option
    uniqueMajors = ['Semua Jurusan', ...widget.students
          .map((student) => student.major)
          .toSet()
          .toList()
        ..sort()]
      ;
  }

  // Filter students based on selected major
  void _filterStudents(String? selectedMajor) {
    if (selectedMajor == null || selectedMajor == 'Semua Jurusan') {
      // If no major is selected or "Semua Jurusan" is selected, return all students
      widget.onFilterChanged(widget.students);
    } else {
      // Filter students by selected major
      final filteredStudents = widget.students
          .where((student) => student.major == selectedMajor)
          .toList();
      widget.onFilterChanged(filteredStudents);
    }
  }

  // Clean up resources when widget is disposed
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Main container with border and background
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (widget.primaryColor ?? colorScheme.primary).withAlpha((0.2*255).round())),
        color: widget.backgroundColor ?? colorScheme.surfaceContainer,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          // Dropdown hint displaying default text and icon
          hint: Row(
            children: [
              Icon(
                Icons.school_outlined,
                size: 16,
                color: widget.primaryColor ?? colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Jurusan',
                  style: widget.hintStyle ?? TextStyle(
                    fontSize: 14,
                    color: (widget.primaryColor ?? colorScheme.primary).withAlpha((0.7*255).round()),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Generate dropdown items with responsive text truncation
          items: uniqueMajors.map((major) => DropdownMenuItem(
            value: major,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Truncate text if width is constrained
                if (constraints.maxWidth < 150) {
                  return Text(
                    major.length > 12 ? '${major.substring(0, 12)}...' : major,
                    style: widget.itemStyle ?? TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  );
                } else {
                  return Text(
                    major,
                    style: widget.itemStyle ?? TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  );
                }
              },
            ),
          )).toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            _filterStudents(value);
          },
          // Customize button appearance
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.backgroundColor ?? colorScheme.surfaceContainer,
            ),
          ),
          // Customize dropdown appearance
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.backgroundColor ?? colorScheme.surfaceContainer,
            ),
            offset: const Offset(0, -4),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: WidgetStateProperty.all(6),
              thumbVisibility: WidgetStateProperty.all(true),
            ),
          ),
          // Customize menu item appearance
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 8),
          ),
          // Configure search functionality
          dropdownSearchData: DropdownSearchData(
            searchController: textEditingController,
            searchInnerWidgetHeight: 60,
            searchInnerWidget: Container(
              height: 60,
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  hintText: 'Cari jurusan...',
                  hintStyle: const TextStyle(fontSize: 12),
                  prefixIcon: Icon(
                    Icons.search,
                    color: widget.primaryColor ?? colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: (widget.primaryColor ?? colorScheme.primary).withAlpha((0.2*255).round()),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.primaryColor ?? colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            // Configure search matching logic
            searchMatchFn: (item, searchValue) {
              return item.value.toString().toLowerCase()
                  .contains(searchValue.toLowerCase());
            },
          ),
          // Clear search when dropdown is closed
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
          },
        ),
      ),
    );
  }
}