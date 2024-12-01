// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';

class LecturerHomeModel {
  final String name;
  final List<LecturerStudentsModel> ? students;

  LecturerHomeModel({
    required this.name, 
    this.students
    });

  factory LecturerHomeModel.fromMap(Map<String, dynamic> map) {
    return LecturerHomeModel(
      name: map['name'] as String,
      students: map['students'] != null 
        ? List<LecturerStudentsModel>.from(
            (map['students'] as List<dynamic>).map<LecturerStudentsModel>(
              (x) => LecturerStudentsModel.fromMap(x as Map<String, dynamic>),
            ),
          )
        : null,
    );
  }
}

extension LecturerHomeXModel on LecturerHomeModel {
  LecturerHomeEntity toEntity() {
    return LecturerHomeEntity(
      name: name,
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
        is_finished: _convertToBool(data.is_finished),
      )).toList() ?? [], 
      activities: {}, 
    );
  }
  bool _convertToBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
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
  final bool is_finished; 
  final Map<String, bool> activities;

  LecturerStudentsModel({
    required this.id,
    required this.name,
    required this.username,
    this.photo_profile,
    required this.the_class,
    required this.study_program,
    required this.major,
    required this.academic_year,
    this.is_finished = false,
    this.activities = const {},
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
      is_finished: _convertToBool(map['is_finished']),
      activities: map['activities'] != null 
        ? Map<String, bool>.from(map['activities'] as Map) 
        : {},
    );
  }

  static bool _convertToBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }
}