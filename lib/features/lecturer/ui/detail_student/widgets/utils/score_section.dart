// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sitama/features/lecturer/domain/entities/lecturer_detail_student.dart';
import 'package:sitama/features/lecturer/ui/input_score/widgets/score_input_overlay.dart';

// widget shows assessment scores for a student, with the following features:
// - Detailed score breakdown
// - Overall average score
// - Conditional add/edit score button
// - Accessibility considerations
class ScoreBox extends StatelessWidget {
  final int id;
  final List<ShowAssessmentEntity> assessments;
  final String average_all_assessments;
  final bool isFinished;
  final bool isOffline;

  const ScoreBox({
    super.key,
    required this.id,
    required this.assessments,
    required this.isFinished,
    required this.average_all_assessments,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    return _buildEnhancedScoreBox(context);
  }

  // Builds an enhanced score box with improved layout and accessibility
  Widget _buildEnhancedScoreBox(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.1*255).round()),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScoreHeader(context),
                const SizedBox(height: 20),
                _buildScoreList(context),
                const Divider(height: 24, thickness: 1),
                _buildAverageScore(context),
              ],
            ),
          ),
          if (!isFinished) _buildDisabledOverlay(context),
        ],
      ),
    );
  }

  // Builds the header with title and add score button
  Widget _buildScoreHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isButtonEnabled = isFinished && !isOffline;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Nilai',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        Tooltip(
          message: isButtonEnabled 
              ? 'Tambahkan atau Edit Nilai' 
              : isOffline 
                  ? 'Tidak dapat menambah nilai dalam mode offline'
                  : 'Selesaikan bagian internship untuk menambahkan nilai',
          child: IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              color: isButtonEnabled 
                  ? colorScheme.primary 
                  : colorScheme.onSurface.withAlpha((0.3*2558).round()),
              size: 32,
            ),
            onPressed: isButtonEnabled 
                ? () => _navigateToInputScorePage(context) 
                : null,
            iconSize: 32,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        ),
      ],
    );
  }

  // Navigates to the input score page
  void _navigateToInputScorePage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ScoreInputOverlay(
        id: id,
        onSubmitSuccess: (success) {
        },
      ),
    );
  }

  // Builds the list of individual scores
  Widget _buildScoreList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: assessments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildScoreItem(
        context,
        assessments[index].component_name,
        assessments[index].average_score.toString(),
      ),
    );
  }

  // Builds an individual score item
  Widget _buildScoreItem(
    BuildContext context, 
    String label, 
    String score, 
    {bool isTotal = false}
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal 
                  ? colorScheme.primary 
                  : colorScheme.onSurface.withAlpha((0.8*2557).round()),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isTotal
                ? colorScheme.primary.withAlpha((0.1*2552).round())
                : colorScheme.tertiary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            score,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: isTotal
                  ? colorScheme.primary
                  : colorScheme.onSurface.withAlpha((0.8*2557).round()),
            ),
          ),
        ),
      ],
    );
  }

  // Builds the average score section
  Widget _buildAverageScore(BuildContext context) {
    return _buildScoreItem(
      context, 
      'Rata - rata', 
      average_all_assessments, 
      isTotal: true
    );
  }

  // Builds a disabled overlay when scores cannot be modified
  Widget _buildDisabledOverlay(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withAlpha((0.3*255).round()),
            child: const Center(
              child: Text(
                'Selesaikan bagian Magang\nuntuk memodifikasi Nilai',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}