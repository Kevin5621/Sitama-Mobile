// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/pages/input_score.dart';

/// A widget that displays a score box with score items and a button to navigate to the input score page.
class ScoreBox extends StatelessWidget {
  final int id;
  final List<ShowAssessmentEntity> assessments;
  final String average_all_assessments;
  final bool isFinished;

  const ScoreBox(
      {Key? key,
      required this.id,
      required this.assessments,
      required this.isFinished,
      required this.average_all_assessments})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return _buildScoreBox(context);
  }

  /// Builds the container that holds the entire score box UI.
  Widget _buildScoreBox(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    bool _isButtonDisabled = !isFinished; 
    
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
                  color: _isButtonDisabled
                      ? Colors.grey
                      : colorScheme.primary, // Ubah warna jika disable.
                ),
                onPressed: _isButtonDisabled
                    ? null // Tombol akan disable jika `null`.
                    : () {
                        // Navigasi ke InputScorePage jika tombol aktif.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputScorePage(
                              id: id,
                            ),
                          ),
                        );
                      },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Score items for various components.
          ListView.builder(
              shrinkWrap: true,
              itemCount: assessments.length,
              itemBuilder: (context, index) => _buildScoreItem(
                  context,
                  assessments[index].component_name,
                  assessments[index].average_score.toString())),
          // _buildScoreItem(context, 'Proposal', '-'),
          // _buildScoreItem(context, 'Laporan', '-'),
          // _buildScoreItem(context, 'Nilai Industri', '-'),
          const Divider(height: 24),

          // The total score with distinct styling.
          _buildScoreItem(
              context, 'Rata - rata', average_all_assessments,
              isTotal: true),
        ],
      ),
    );
  }

  /// Builds each score item row with label and score.
  /// [isTotal] applies specific styling if true, used for the final row.
  Widget _buildScoreItem(BuildContext context, String label, String score,
      {bool isTotal = false}) {
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
              color: isTotal
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.7),
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
                color: isTotal
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
