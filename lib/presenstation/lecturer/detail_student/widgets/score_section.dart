import 'package:flutter/material.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/pages/input_score.dart';

/// A widget that displays a score box with score items and a button to navigate to the input score page.
class ScoreBox extends StatelessWidget {
  const ScoreBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildScoreBox(context);
  }

  /// Builds the container that holds the entire score box UI.
  Widget _buildScoreBox(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with the title "Nilai" and an add button to open InputScorePage.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nilai',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: colorScheme.primary,
                ),
                onPressed: () {
                  // Navigate to the InputScorePage on add button press.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InputScorePage(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Score items for various components.
          _buildScoreItem(context, 'Proposal', '-'),
          _buildScoreItem(context, 'Laporan', '-'),
          _buildScoreItem(context, 'Nilai Industri', '-'),
          const Divider(height: 24),
          
          // The total score with distinct styling.
          _buildScoreItem(context, 'Rata - rata', '-', isTotal: true),
        ],
      ),
    );
  }

  /// Builds each score item row with label and score.
  /// [isTotal] applies specific styling if true, used for the final row.
  Widget _buildScoreItem(BuildContext context, String label, String score, {bool isTotal = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isTotal
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              score,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                color: isTotal ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
