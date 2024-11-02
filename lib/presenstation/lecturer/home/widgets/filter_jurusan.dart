import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterJurusan extends StatefulWidget {
  final Function(String?)? onProdiSelected;
  final String? initialValue;
  final List<String>? customProdiList;
  final Color? primaryColor;
  final Color? backgroundColor;
  final TextStyle? hintStyle;
  final TextStyle? itemStyle;
  
  const FilterJurusan({
    Key? key,
    this.onProdiSelected,
    this.initialValue,
    this.customProdiList,
    this.primaryColor,
    this.backgroundColor,
    this.hintStyle,
    this.itemStyle,
  }) : super(key: key);

  @override
  State<FilterJurusan> createState() => _FilterJurusanState();
}

class _FilterJurusanState extends State<FilterJurusan> {
  final List<String> defaultItems = [
    'D3 - Informatika',
    'D3 - Elektronika',
    'D3 - Telekomunikasi',
    'D3 - Listrik',
    'D4 - Telekomunikasi',
  ];
  
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
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
    final items = widget.customProdiList ?? defaultItems;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (widget.primaryColor ?? colorScheme.primary).withOpacity(0.2)),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Icon(
                Icons.school_outlined,
                size: 16,
                color: widget.primaryColor ?? colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Prodi',
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
                  Icons.school,
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
            if (widget.onProdiSelected != null) {
              widget.onProdiSelected!(value);
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
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 8),
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
                  hintText: 'Cari program studi...',
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