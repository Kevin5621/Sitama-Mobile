import 'package:Sitama/domain/entities/score_entity.dart';

class ScoreModel {
  final int id;
  final String name;
  final int? score;

  ScoreModel({required this.id, required this.name, this.score});

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      id: map['id'] as int,
      name: map['name'] as String,
      score: map['score'] != null ? map['score'] as int : null,
    );
  }

  ScoreEntity toEntity() {
    return ScoreEntity(
      id: id,
      name: name,
      score: score,
    );
  }
}
