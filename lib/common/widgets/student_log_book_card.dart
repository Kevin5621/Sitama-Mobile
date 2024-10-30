import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/presenstation/student/logbook/widgets/delete_log_book.dart';
import 'package:sistem_magang/presenstation/student/logbook/widgets/edit_log_book.dart';

import '../../core/config/themes/app_color.dart';

class LogBookItem {
  final int id;
  final String title;
  final DateTime date;
  final String description;
  final int curentPage;

  LogBookItem({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.curentPage,
  });
}

class LogBookCard extends StatelessWidget {
  final LogBookItem item;

  const LogBookCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppColors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(item.title),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(item.date)),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.description),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return EditLogBook(
                                id: item.id,
                                title: item.title,
                                date: item.date,
                                description: item.description,
                                curentPage: item.curentPage,
                              );
                            },
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: AppColors.info,
                              size: 18,
                            ),
                            SizedBox(width: 2),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: AppColors.info,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DeleteLogBook(
                                id: item.id,
                                title: item.title,
                                curentPage: item.curentPage,
                              );
                            },
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: AppColors.danger,
                              size: 18,
                            ),
                            SizedBox(width: 2),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: AppColors.danger,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}