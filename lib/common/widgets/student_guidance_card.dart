import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/presenstation/student/guidance/widgets/delete_guidance.dart';
import 'package:sistem_magang/presenstation/student/guidance/widgets/edit_guidance.dart';

enum GuidanceStatus { approved, rejected, inProgress, updated }

class GuidanceCard extends StatelessWidget {
  final int id;
  final String title;
  final DateTime date;
  final GuidanceStatus status;
  final String description;
  final int curentPage;

  const GuidanceCard({
    Key? key,
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.description,
    required this.curentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      color: status == GuidanceStatus.rejected
          ? AppColors.danger500
          : AppColors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: _getStatusIcon(),
          title: Text(title),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(date)),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(description, textAlign: TextAlign.left),
                  if(status != GuidanceStatus.approved) ...[
                    SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return EditGuidance(
                                  id: id,
                                  title: title,
                                  date: date,
                                  description: description,
                                  curentPage: curentPage,
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
                                return DeleteGuidance(
                                  id: id,
                                  title: title,
                                  curentPage: curentPage,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStatusIcon() {
    switch (status) {
      case GuidanceStatus.approved:
        return const Icon(Icons.check_circle, color: AppColors.success);
      case GuidanceStatus.inProgress:
        return const Icon(Icons.remove_circle, color: AppColors.gray);
      case GuidanceStatus.rejected:
        return const Icon(Icons.warning, color: AppColors.danger);
      case GuidanceStatus.updated:
        return const Icon(Icons.help, color: AppColors.warning);
    }
  }
}
