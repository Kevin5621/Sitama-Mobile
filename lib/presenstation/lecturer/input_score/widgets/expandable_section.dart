import 'package:flutter/material.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/widgets/input_field.dart';

class ExpandableSection extends StatelessWidget {
  final String title;
  final List<String> fields;

  const ExpandableSection({Key? key, required this.title, required this.fields})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      child: ExpansionTile(
        title: Text(title),
        leading: Icon(_getIconForTitle(title)),
        children: [
          Divider(thickness: 1, height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  fields.map((field) => InputField(label: field)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Proposal':
        return Icons.description;
      case 'Laporan':
        return Icons.insert_drive_file;
      default:
        return Icons.article;
    }
  }
}