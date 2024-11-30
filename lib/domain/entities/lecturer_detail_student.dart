// ignore_for_file: non_constant_identifier_names

import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';

class DetailStudentEntity {
  final InfoStudentEntity student;
  final String username;
  final String the_class;
  final String major;
  bool? is_finished;
  final List<InternshipStudentEntity> internships;
  final List<GuidanceEntity> guidances;
  final List<LogBookEntity> log_book;
  final List<ShowAssessmentEntity> assessments;
  final String average_all_assessments;

  DetailStudentEntity({
    required this.student,
    required this.username,
    required this.the_class,
    required this.major,
    this.is_finished,
    required this.internships,
    required this.guidances,
    required this.log_book,
    required this.assessments,
    required this.average_all_assessments,
  });

  DetailStudentEntity copyWith({
    InfoStudentEntity? student,
    String? username,
    String? the_class,
    String? major,
    bool? is_finished,
    List<InternshipStudentEntity>? internships,
    List<GuidanceEntity>? guidances,
    List<LogBookEntity>? log_book,
    List<ShowAssessmentEntity>? assessments,
    String? average_all_assessments,
  }) {
    return DetailStudentEntity(
      student: student ?? this.student,
      username: username ?? this.username,
      the_class: the_class ?? this.the_class,
      major: major ?? this.major,
      is_finished: is_finished ?? this.is_finished,
      internships: internships ?? this.internships,
      guidances: guidances ?? this.guidances,
      log_book: log_book ?? this.log_book,
      assessments: assessments ?? this.assessments,
      average_all_assessments: average_all_assessments ?? this.average_all_assessments,
    );
  }
}

class InfoStudentEntity {
  final String name;
  final String username;
  final String email;
  final String is_finished;
  final String? photo_profile;

  InfoStudentEntity({
    required this.name,
    required this.username,
    required this.email,
    required this.is_finished,
    this.photo_profile,
  });
}

class InternshipStudentEntity {
  final String name;
  final DateTime start_date;
  final DateTime? end_date;

  InternshipStudentEntity({
    required this.name,
    required this.start_date,
    this.end_date,
  });
}

class ShowAssessmentEntity {
  final String component_name;
  final double average_score;

  ShowAssessmentEntity({
    required this.component_name,
    required this.average_score,
  });
}