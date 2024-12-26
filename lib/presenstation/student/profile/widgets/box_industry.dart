import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sitama/domain/entities/lecturer_detail_student.dart';

class IndustryCard extends StatelessWidget {
  final List<InternshipStudentEntity>? internships;

  const IndustryCard({
    super.key,
    required this.internships,
  });

  Widget _buildInternshipInfo({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withAlpha((0.1*255).round()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurface.withAlpha((0.6*255).round()),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width > 400 ? 380.0 : size.width * 0.9;

    if (internships == null || internships!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha((0.08*255).round()),
              offset: const Offset(0, 4),
              blurRadius: 12,
            )
          ],
          color: colorScheme.surfaceContainer,
        ),
        child: Center(
          child: Text(
            'Tempat magang anda belum terdaftar !',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: internships!.length,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha((0.08*255).round()),
              offset: const Offset(0, 4),
              blurRadius: 12,
            )
          ],
          color: colorScheme.surfaceContainer,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 16),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Industri',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (internships!.length > 1)
              TabBar(
                isScrollable: true,
                dividerColor: Colors.transparent,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurface.withAlpha((0.5*255).round()),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                indicatorColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                tabAlignment: TabAlignment.center,
                labelPadding: const EdgeInsets.only(right: 24),
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                tabs: List.generate(
                  internships!.length,
                  (index) => Tab(
                    text: 'Industri ${index + 1}',
                  ),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: TabBarView(
                children: internships!.map((internship) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildInternshipInfo(
                          context: context,
                          icon: Icons.business_rounded,
                          label: 'Nama Perusahaan',
                          value: internship.name,
                        ),
                        const SizedBox(height: 16),
                        _buildInternshipInfo(
                          context: context,
                          icon: Icons.calendar_today_rounded,
                          label: 'Tanggal Mulai',
                          value: DateFormat('dd MMMM yyyy').format(internship.start_date),
                        ),
                        const SizedBox(height: 16),
                        _buildInternshipInfo(
                          context: context,
                          icon: Icons.event_rounded,
                          label: 'Tanggal Selesai',
                          value: internship.end_date != null
                              ? DateFormat('dd MMMM yyyy').format(internship.end_date!)
                              : "Belum selesai",
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
