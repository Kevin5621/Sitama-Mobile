import 'package:flutter/material.dart';

class StatisticsSection extends StatelessWidget {
  final int guidanceLength;
  final int logBookLength;
  const StatisticsSection(
      {super.key, required this.guidanceLength, required this.logBookLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatItem(
            label: 'Bimbingan',
            value: guidanceLength.toString(),
            icon: Icons.school,
            color: Colors.green,
          ),
          StatItem(
            label: 'Total Log',
            value: logBookLength.toString(),
            icon: Icons.book,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

// widgets/stat_item.dart
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha((0.1*255).round()),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
