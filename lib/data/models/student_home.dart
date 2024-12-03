// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/data/models/lecturer_detail_student.dart';
import 'package:sistem_magang/data/models/log_book.dart';
import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/domain/entities/student_home_entity.dart';

class StudentHomeModel {
  final String name;
  final List<GuidanceModel> latest_guidances;
  final List<LogBookModel> latest_log_books;

  StudentHomeModel({
    required this.name,
    required this.latest_guidances,
    required this.latest_log_books,
  });

  factory StudentHomeModel.fromMap(Map<String, dynamic> map) {
    return StudentHomeModel(
      name: map['name'] as String,
      latest_guidances: List<GuidanceModel>.from(
        (map['latest_guidances'] as List<dynamic>).map<GuidanceModel>(
          (x) => GuidanceModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      latest_log_books: List<LogBookModel>.from(
        (map['latest_log_books'] as List<dynamic>).map<LogBookModel>(
          (x) => LogBookModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

extension StudentHomeXModel on StudentHomeModel {
  StudentHomeEntity toEntity() {
    return StudentHomeEntity(
      name: name,
      latest_guidances: latest_guidances
          .map<GuidanceEntity>((data) => GuidanceEntity(
                id: data.id,
                title: data.title,
                activity: data.activity,
                date: data.date,
                lecturer_note: data.lecturer_note,
                name_file: data.name_file,
                status: data.status,
              ))
          .toList(),
      latest_log_books: latest_log_books
          .map<LogBookEntity>((data) => LogBookEntity(
              id: data.id,
              title: data.title,
              activity: data.activity,
              date: data.date, 
              lecturer_note: data.lecturer_note,))
          .toList(),
    );
  }
}

class StudentProfileModel {
  final String name;
  final String username;
  final String email;
  final String? photo_profile;
  final List<InternshipStudentModel>? internships;

  StudentProfileModel({
    required this.name,
    required this.username,
    required this.email,
    this.photo_profile,
    this.internships,
  });

  factory StudentProfileModel.fromMap(Map<String, dynamic> map) {
    return StudentProfileModel(
      name: map['name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      photo_profile:
          map['photo_profile'] != null ? map['photo_profile'] as String : null,
      internships: map['internships'] != null
          ? List<InternshipStudentModel>.from(
              (map['internships'] as List<dynamic>).map<InternshipStudentModel?>(
                (x) =>
                    InternshipStudentModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }
}

extension StudentProfileXModel on StudentProfileModel {
  StudentProfileEntity toEntity() {
    return StudentProfileEntity(
      name: name,
      username: username,
      email: email,
      photo_profile: photo_profile,
      internships: internships
          ?.map<InternshipStudentEntity>((data) => InternshipStudentEntity(
              name: data.name,
              start_date: data.start_date,
              end_date: data.end_date))
          .toList(),
    );
  }
}
