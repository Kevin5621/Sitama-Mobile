import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum BimbinganStatus { revisi, pending, approved }

class BimbinganItem extends StatelessWidget {
  final String title;
  final DateTime date;
  final BimbinganStatus status;
  final String description;

  const BimbinganItem({
    Key? key,
    required this.title,
    required this.date,
    required this.status,
    required this.description,
    String? fileUrl,
    String? fileSize,
  }) : super(key: key);

  String? get fileUrl => null;

  String? get fileSize => null;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: status == BimbinganStatus.revisi ? Colors.orange[100] : null,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: _getStatusIcon(),
          title: Text(title),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(date)),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(description, textAlign: TextAlign.left),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStatusIcon() {
    switch (status) {
      case BimbinganStatus.revisi:
        return const Icon(Icons.error, color: Colors.orange);
      case BimbinganStatus.pending:
        return const Icon(Icons.remove_circle, color: Colors.grey);
      case BimbinganStatus.approved:
        return const Icon(Icons.check_circle, color: Colors.green);
    }
  }
}