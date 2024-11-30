// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:intl/intl.dart';
import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/data/models/log_book.dart';
import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';

class DetailStudentModel {
  final InfoStudentModel student;
  final List<InternshipStudentModel> internships;
  final List<GuidanceModel> guidances;
  final List<LogBookModel> log_book;
  final List<ShowAssessmentModel> assessments;
  final double average_all_assessments;
  final bool is_finished;

  DetailStudentModel({
    required this.student,
    required this.internships,
    required this.guidances,
    required this.log_book,
    required this.assessments,
    required this.average_all_assessments,
    required this.is_finished,
  });

  factory DetailStudentModel.fromMap(Map<String, dynamic> map) {
    return DetailStudentModel(
      student: InfoStudentModel.fromMap(map['student'] as Map<String, dynamic>),
      internships: List<InternshipStudentModel>.from(
        (map['internships'] as List<dynamic>).map<InternshipStudentModel>(
          (x) => InternshipStudentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      guidances: List<GuidanceModel>.from(
        (map['guidances'] as List<dynamic>).map<GuidanceModel>(
          (x) => GuidanceModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      log_book: List<LogBookModel>.from(
        (map['log_book'] as List<dynamic>).map<LogBookModel>(
          (x) => LogBookModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      assessments: List<ShowAssessmentModel>.from(
        (map['assessments'] as List<dynamic>).map<ShowAssessmentModel>(
          (x) => ShowAssessmentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      average_all_assessments: map['average_all_assessments'] as double,
      is_finished: _convertToBool(map['student']['is_finished']),
    );
  }
  static bool _convertToBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) return value.toLowerCase() == 'true';
  return false;
}
}

extension DetailStudentXModel on DetailStudentModel {
  DetailStudentEntity toEntity() {
    return DetailStudentEntity(
      student: InfoStudentEntity(
        name: student.name,
        email: student.email,
        username: student.username,
        photo_profile: student.photo_profile, 
        is_finished: '',
      ),
      username: student.username,
      the_class: student.the_class,
      major: student.major,
      internships: internships
          .map((data) => InternshipStudentEntity(
              name: data.name,
              start_date: data.start_date,
              end_date: data.end_date))
          .toList(),
      guidances: guidances
          .map((guidance) => GuidanceEntity(
              id: guidance.id,
              title: guidance.title,
              activity: guidance.activity,
              date: guidance.date,
              lecturer_note: guidance.lecturer_note,
              name_file: guidance.name_file,
              status: guidance.status))
          .toList(),
      log_book: log_book
          .map((data) => LogBookEntity(
              id: data.id,
              title: data.title,
              activity: data.activity,
              date: data.date,
              lecturer_note: ''))
          .toList(),
      assessments: assessments
          .map((assessment) => ShowAssessmentEntity(
                component_name: assessment.component_name,
                average_score: assessment.average_score,
              ))
          .toList(),
      average_all_assessments:  average_all_assessments.toString(),
      is_finished: is_finished,
    );
  }
}

class InfoStudentModel {
  final String name;
  final String username;
  final String email;
  final String the_class;
  final String major;
  final bool is_finished;
  final String? photo_profile;

  InfoStudentModel({
    required this.name,
    required this.username,
    required this.email,
    required this.the_class,
    required this.major,
    required this.is_finished,
    this.photo_profile,
  });

  factory InfoStudentModel.fromMap(Map<String, dynamic> map) {
    return InfoStudentModel(
      name: map['name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      the_class: map['class'] as String,
      major: map['major'] as String,
      is_finished: map['is_finished'] as bool,
      photo_profile: map['photo_profile'] as String?,
    );
  }
}

class InternshipStudentModel {
  final String name;
  final DateTime start_date;
  final DateTime? end_date;

  InternshipStudentModel(
      {required this.name, required this.start_date, required this.end_date});

  factory InternshipStudentModel.fromMap(Map<String, dynamic> map) {
    return InternshipStudentModel(
      name: map['name'] as String,
      start_date: DateFormat('yyyy-MM-dd').parse(map['start_date'] as String),
      end_date: map['end_date'] != null
          ? DateFormat('yyyy-MM-dd').parse(map['end_date'] as String)
          : null,
    );
  }
}

class ShowAssessmentModel {
  final String component_name;
  final double average_score;

  ShowAssessmentModel({
    required this.component_name,
    required this.average_score,
  });

  factory ShowAssessmentModel.fromMap(Map<String, dynamic> map) {
    return ShowAssessmentModel(
      component_name: map['component_name'] as String,
      average_score:
          (map['average_score'] as num).toDouble(), // Convert to double
    );
  }
}
