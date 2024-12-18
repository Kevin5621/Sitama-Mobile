import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Sitama/domain/entities/score_entity.dart';

class ExpandableSection extends StatelessWidget {
  final String title;
  final List<ScoreEntity> scores;
  final Map<int, TextEditingController> controllers;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.scores,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          expansionTileTheme: ExpansionTileThemeData(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            iconColor: theme.colorScheme.primary,
            textColor: theme.colorScheme.onSurface,
          ),
        ),
        child: ExpansionTile(
          // Tambahkan ini untuk menghilangkan garis
          shape: Border.all(color: Colors.transparent),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForTitle(title),
              color: theme.colorScheme.primary,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: scores.map((score) {
                  final controller = controllers[score.id] ??
                      TextEditingController(text: score.score?.toString() ?? '');
                  controllers[score.id] = controller;

                  return InputField(
                    score: score,
                    controller: controller,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Proposal':
        return Icons.description_rounded;
      case 'Laporan':
        return Icons.insert_drive_file_rounded;
      case 'Industri':
        return Icons.factory_rounded;
      default:
        return Icons.article_rounded;
    }
  }
}

class InputField extends StatelessWidget {
  final ScoreEntity score;
  final TextEditingController? controller;

  const InputField({super.key, required this.score, this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    controller?.text = score.score != null ? score.score.toString() : '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              score.name,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}