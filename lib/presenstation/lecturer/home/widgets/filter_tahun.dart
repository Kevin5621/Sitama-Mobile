import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class FilterTahun extends StatefulWidget {
  final Function(String?)? onYearSelected;
  final String? initialValue;
  final int startYear;
  final int endYear;
  final Color? primaryColor;
  final Color? backgroundColor;
  final TextStyle? hintStyle;
  final TextStyle? itemStyle;
  
  const FilterTahun({
    Key? key,
    this.onYearSelected,
    this.initialValue,
    this.startYear = 2020,
    this.endYear = 2024,
    this.primaryColor,
    this.backgroundColor,
    this.hintStyle,
    this.itemStyle,
  }) : super(key: key);

  @override
  State<FilterTahun> createState() => _FilterTahunState();
}

class _FilterTahunState extends State<FilterTahun> {
  late List<String> items;
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Generate years list dynamically
    items = List.generate(
      widget.endYear - widget.startYear + 1,
      (index) => (widget.endYear - index).toString(),
    );
    selectedValue = widget.initialValue;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (widget.primaryColor ?? colorScheme.primary).withOpacity(0.2)),
        color: widget.backgroundColor ?? colorScheme.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
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
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 16,
                  color: widget.primaryColor ?? colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  item,
                  style: widget.itemStyle ?? TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          )).toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            if (widget.onYearSelected != null) {
              widget.onYearSelected!(value);
            }
          },
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.backgroundColor ?? colorScheme.surface,
            ),
          ),
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
          menuItemStyleData: MenuItemStyleData(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
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
            searchMatchFn: (item, searchValue) {
              return item.value.toString().toLowerCase()
                  .contains(searchValue.toLowerCase());
            },
          ),
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
