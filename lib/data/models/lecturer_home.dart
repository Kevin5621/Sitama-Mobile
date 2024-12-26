// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:sitama/domain/entities/lecturer_home_entity.dart';

class LecturerHomeModel {
  final String name;
  final int id;
  final Set<LecturerStudentsModel>? students;

  LecturerHomeModel({
    required this.name, 
    required this.id, 
    this.students
  });

  factory LecturerHomeModel.fromMap(Map<String, dynamic> map) {
    return LecturerHomeModel(
      name: map['name'] as String,
      id: map['userId'] as int,
      students: map['students'] != null 
        ? (map['students'] as List<dynamic>)
            .map<LecturerStudentsModel>(
              (x) => LecturerStudentsModel.fromMap(x as Map<String, dynamic>),
            )
            .toSet()
        : null,
    );
  }
}

extension LecturerHomeXModel on LecturerHomeModel {
  LecturerHomeEntity toEntity() {
    return LecturerHomeEntity(
      name: name,
      id: id,
      students: students?.map<LecturerStudentsEntity>((data) => LecturerStudentsEntity(
        id: data.id,
        name: data.name,
        username: data.username,
        photo_profile: data.photo_profile,
        the_class: data.the_class,
        study_program: data.study_program,
        major: data.major,
        academic_year: data.academic_year,
        activities: data.activities,
        isFinished: data.isFinished,
        hasNewLogbook: data.hasNewLogbook,
        lastUpdated: data.lastUpdated,
      )).toSet() ?? {},
      activities: {}, 
    );
  }
}

class LecturerStudentsModel {
  final int id;
  final String name;
  final String username;
  final String? photo_profile;
  final String the_class;
  final String study_program;
  final String major;
  final String academic_year;
  final bool isFinished;
  final Map<String, bool> activities;
  final bool hasNewLogbook;
  final DateTime? lastUpdated;

  LecturerStudentsModel({
    required this.id,
    required this.name,
    required this.username,
    this.photo_profile,
    required this.the_class,
    required this.study_program,
    required this.major,
    required this.academic_year,
    required this.isFinished,
    this.activities = const {},
    required this.hasNewLogbook,
    this.lastUpdated,
  });

  factory LecturerStudentsModel.fromMap(Map<String, dynamic> map) {
    return LecturerStudentsModel(
      id: map['id'] as int,
      name: map['name'] as String,
      username: map['username'] as String,
      photo_profile: map['photo_profile'] as String?,
      the_class: map['class'] as String,
      study_program: map['study_program'] as String,
      major: map['major'] as String,
      academic_year: map['academic_year'] as String,
      isFinished: (map['is_finished'] as bool?) ?? false,
      activities: map['activities'] != null 
        ? Map<String, bool>.from(map['activities'] as Map) 
        : {},
      hasNewLogbook: (map['hasNewLogbook'] as bool?) ?? false,
      lastUpdated: map['lastUpdated'] != null 
        ? DateTime.parse(map['lastUpdated'] as String)
        : null,
    );
  }
}