// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  DetailStudentModel(
      {required this.student,
      required this.internships,
      required this.guidances,
      required this.log_book});

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
    );
  }
}

extension DetailStudentXModel on DetailStudentModel {
  DetailStudentEntity toEntity() {
    return DetailStudentEntity(
        student: InfoStudentEntity(
            name: student.name,
            email: student.email,
            username: student.username),
        internships: internships
            .map<InternshipStudentEntity>((data) => InternshipStudentEntity(
                name: data.name,
                start_date: data.start_date,
                end_date: data.end_date))
            .toList(),
        guidances: guidances
            .map<GuidanceEntity>((guidance) => GuidanceEntity(
                id: guidance.id,
                title: guidance.title,
                activity: guidance.activity,
                date: guidance.date,
                lecturer_note: guidance.lecturer_note,
                name_file: guidance.name_file,
                status: guidance.status))
            .toList(),
        log_book: log_book
            .map<LogBookEntity>((data) => LogBookEntity(
                id: data.id,
                title: data.title,
                activity: data.activity, 
                date: data.date, 
                lecturer_note: ''))
            .toList());
  }
}

class InfoStudentModel {
  final String name;
  final String username;
  final String email;

  InfoStudentModel(
      {required this.name, required this.username, required this.email});

  factory InfoStudentModel.fromMap(Map<String, dynamic> map) {
    return InfoStudentModel(
      name: map['name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }
}

class InternshipStudentModel {
  final String name;
  final DateTime start_date;
  final DateTime ? end_date;

  InternshipStudentModel(
      {required this.name, required this.start_date, required this.end_date});

  factory InternshipStudentModel.fromMap(Map<String, dynamic> map) {
    return InternshipStudentModel(
      name: map['name'] as String,
      start_date: DateFormat('yyyy-MM-dd').parse(map['start_date'] as String),
      end_date: map['end_date'] != null ? DateFormat('yyyy-MM-dd').parse(map['end_date'] as String) : null ,
    );
  }
}