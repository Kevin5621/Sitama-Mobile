// ignore_for_file: non_constant_identifier_names

import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';

class DetailStudentEntity {
  final InfoStudentEntity student;
  final String username;
  final String the_class;
  final String major;
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
    required this.internships,
    required this.guidances,
    required this.log_book,
    required this.assessments,
    required this.average_all_assessments,
  });
}

class InfoStudentEntity {
  final String name;
  final String username;
  final String email;
  final String? photo_profile;
  final bool isFinished;

  InfoStudentEntity({
    required this.name, 
    required this.username, 
    required this.email,
    this.photo_profile,
    required this.isFinished,
  });
}

class InternshipStudentEntity {
  final String name;
  final DateTime start_date;
  final DateTime? end_date;
  final String status; 
  final bool isApproved; 

  InternshipStudentEntity({
    required this.name,
    required this.start_date,
    required this.end_date,
    this.status = 'Magang', 
    this.isApproved = false, 
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
