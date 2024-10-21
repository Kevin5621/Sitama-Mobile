import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/domain/entities/student_home_entity.dart';

class LecturerLogBookTab extends StatelessWidget {
  final List<LogBookEntity> logBooks;
  
  const LecturerLogBookTab({super.key, required this.logBooks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: logBooks.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8),
          color: AppColors.white,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(logBooks[index].title),
              subtitle: Text(
                  'Date: ${logBooks[index].date}'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      '${logBooks[index].activity}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
