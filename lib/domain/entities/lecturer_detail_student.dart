// ignore_for_file: non_constant_identifier_names

import 'package:sitama/domain/entities/guidance_entity.dart';
import 'package:sitama/domain/entities/log_book_entity.dart';

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

  Map<String, dynamic> toJson() => {
    'student': student.toJson(),
    'username': username,
    'the_class': the_class,
    'major': major,
    'internships': internships.map((i) => i.toJson()).toList(),
    'guidances': guidances.map((g) => g.toJson()).toList(),
    'log_book': log_book.map((l) => l.toJson()).toList(),
    'assessments': assessments.map((a) => a.toJson()).toList(),
    'average_all_assessments': average_all_assessments,
  };

  factory DetailStudentEntity.fromJson(Map<String, dynamic> json) {
    return DetailStudentEntity(
      student: InfoStudentEntity.fromJson(json['student']),
      username: json['username'],
      the_class: json['the_class'],
      major: json['major'],
      internships: (json['internships'] as List)
          .map((i) => InternshipStudentEntity.fromJson(i))
          .toList(),
      guidances: (json['guidances'] as List)
          .map((g) => GuidanceEntity.fromJson(g))
          .toList(),
      log_book: (json['log_book'] as List)
          .map((l) => LogBookEntity.fromJson(l))
          .toList(),
      assessments: (json['assessments'] as List)
          .map((a) => ShowAssessmentEntity.fromJson(a))
          .toList(),
      average_all_assessments: json['average_all_assessments'],
    );
  }
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

  Map<String, dynamic> toJson() => {
    'name': name,
    'username': username,
    'email': email,
    'photo_profile': photo_profile,
    'isFinished': isFinished,
  };

  factory InfoStudentEntity.fromJson(Map<String, dynamic> json) {
    return InfoStudentEntity(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      photo_profile: json['photo_profile'],
      isFinished: json['isFinished'],
    );
  }
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

  Map<String, dynamic> toJson() => {
    'name': name,
    'start_date': start_date.toIso8601String(),
    'end_date': end_date?.toIso8601String(),
    'status': status,
    'isApproved': isApproved,
  };

  factory InternshipStudentEntity.fromJson(Map<String, dynamic> json) {
    return InternshipStudentEntity(
      name: json['name'],
      start_date: DateTime.parse(json['start_date']),
      end_date: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      status: json['status'],
      isApproved: json['isApproved'],
    );
  }
}

class ShowAssessmentEntity {
  final String component_name;
  final double average_score;

  ShowAssessmentEntity({
    required this.component_name,
    required this.average_score,
  });

  Map<String, dynamic> toJson() => {
    'component_name': component_name,
    'average_score': average_score,
  };

  factory ShowAssessmentEntity.fromJson(Map<String, dynamic> json) {
    return ShowAssessmentEntity(
      component_name: json['component_name'],
      average_score: json['average_score'],
    );
  }
}