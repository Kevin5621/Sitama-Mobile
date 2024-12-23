class ScoreRequest {
  final int detailedAssessmentComponentsId;
  final double score;

  ScoreRequest({
    required this.detailedAssessmentComponentsId, 
    required this.score
  });

  Map<String, dynamic> toMap() {
    return {
      'detailed_assessment_components_id': detailedAssessmentComponentsId,
      'score': score,
    };
  }
}
