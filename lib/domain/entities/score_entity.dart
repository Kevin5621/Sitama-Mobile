class ScoreEntity {
  final int id;
  final String name;
  final double? score;

  ScoreEntity({
    required this.id, 
    required this.name, 
    this.score
    });
}
