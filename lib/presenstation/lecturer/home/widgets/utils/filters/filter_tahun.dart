import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:Sitama/domain/entities/lecturer_home_entity.dart';

// A customizable dropdown widget for filtering students by academic year
// Provides search functionality and supports theming
class FilterTahun extends StatefulWidget {
  // Required parameters for core functionality
  final List<LecturerStudentsEntity> students;
  final Function(List<LecturerStudentsEntity>) onFilterChanged;
  
  // Optional parameters for visual customization
  final String? initialValue;
  final Color? primaryColor;
  final Color? backgroundColor;
  final TextStyle? hintStyle;
  final TextStyle? itemStyle;
  
  const FilterTahun({
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
  State<FilterTahun> createState() => _FilterTahunState();
}

class _FilterTahunState extends State<FilterTahun> {
  late List<String> uniqueYears;
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  
  // Initialize state and prepare the sorted list of unique years
  @override
  void initState() {
    super.initState();
    // Extract unique years and sort them in descending order (newest first)
    // Add "Semua Tahun" as the first option
    uniqueYears = ['Semua Tahun', ...widget.students
          .map((student) => student.academic_year)
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a))]
      ; // Sort in descending order
    
    selectedValue = widget.initialValue;
  }

  // Filter students based on selected academic year
  void _filterStudents(String? selectedYear) {
    if (selectedYear == null || selectedYear == 'Semua Tahun') {
      // If no year is selected or "Semua Tahun" is selected, return all students
      widget.onFilterChanged(widget.students);
    } else {
      // Filter students by selected academic year
      final filteredStudents = widget.students
          .where((student) => student.academic_year == selectedYear)
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
        border: Border.all(color: (widget.primaryColor ?? colorScheme.primary).withOpacity(0.2)),
        color: widget.backgroundColor ?? colorScheme.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          // Dropdown hint displaying calendar icon and default text
          hint: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: widget.primaryColor ?? colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Tahun',
                style: widget.hintStyle ?? TextStyle(
                  fontSize: 14,
                  color: (widget.primaryColor ?? colorScheme.primary).withOpacity(0.7),
                ),
              ),
            ],
          ),
          // Generate dropdown items with responsive text truncation
          items: uniqueYears.map((year) => DropdownMenuItem(
            value: year,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Truncate text if width is constrained
                if (constraints.maxWidth < 150) {
                  return Center(
                    child: Text(
                      year.length > 12 ? '${year.substring(0, 12)}...' : year,
                      style: widget.itemStyle ?? TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      year,
                      style: widget.itemStyle ?? TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
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
              color: widget.backgroundColor ?? colorScheme.surface,
            ),
          ),
          // Customize dropdown appearance
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.backgroundColor ?? colorScheme.surface,
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
                  hintText: 'Cari tahun...',
                  hintStyle: const TextStyle(fontSize: 12),
                  prefixIcon: Icon(
                    Icons.search,
                    color: widget.primaryColor ?? colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: (widget.primaryColor ?? colorScheme.primary).withOpacity(0.2),
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