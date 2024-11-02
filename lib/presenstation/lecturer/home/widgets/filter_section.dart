import 'package:flutter/material.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/filter_jurusan.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/filter_tahun.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(child: FilterJurusan()),
            SizedBox(width: 16),
            Expanded(child: FilterTahun()),
          ],
        ),
      ),
    );
  }
}
