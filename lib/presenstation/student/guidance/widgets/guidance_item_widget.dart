import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/guidace_item.dart';


class BimbinganItemWidget extends StatelessWidget {
  final BimbinganItem item;
  final VoidCallback onEdit;

  const BimbinganItemWidget({
    Key? key,
    required this.item,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: item.status == BimbinganStatus.revisi ? Colors.orange[100] : null,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Stack(
          children: [
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Center(child: Text(item.title)),
              subtitle: Center(
                  child: Text(DateFormat('dd/MM/yyyy').format(item.date))),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.description, textAlign: TextAlign.left),
                      if (item.fileUrl != null)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.file_present),
                          title: Text(item.fileUrl!),
                          trailing: Text(item.fileSize ?? ''),
                        ),
                      if (item.status != BimbinganStatus.approved)
                        ElevatedButton(
                          onPressed: onEdit,
                          child: const Text('Edit'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (item.status == BimbinganStatus.revisi)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '!',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}