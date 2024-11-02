import 'package:flutter/material.dart';
import 'package:sistem_magang/data/models/industry_box_student.dart';

class IndustryCard extends StatelessWidget {
  final InternshipModel? internship;

  const IndustryCard({
    Key? key,
    required this.internship,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (internship == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 2,
          )
        ],
        color: colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              internship!.name,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Industri 1',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Nama : ${internship!.companyName}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Tanggal Mulai : ${internship!.startDate}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Tanggal Selesai : ${internship!.endDate}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}