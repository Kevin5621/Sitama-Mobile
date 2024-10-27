// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';

class LecturerHomeModel {
  final String name;
  final List<LecturerStudentsModel> ? students;

  LecturerHomeModel({required this.name, required this.students});

  factory LecturerHomeModel.fromMap(Map<String, dynamic> map) {
    return LecturerHomeModel(
      name: map['name'] as String,
      students: List<LecturerStudentsModel>.from(
        (map['students'] as List<dynamic>).map<LecturerStudentsModel>(
          (x) => LecturerStudentsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
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
              the_class: data.the_class,
              study_program: data.study_program,
              major: data.major,
              academic_year: data.academic_year))
          .toList(),
    );
  }
}

class LecturerStudentsModel {
  final int id;
  final String name;
  final String username;
  final String the_class;
  final String study_program;
  final String major;
  final String academic_year;

  LecturerStudentsModel(
      {required this.id,
      required this.name,
      required this.username,
      required this.the_class,
      required this.study_program,
      required this.major,
      required this.academic_year});

  factory LecturerStudentsModel.fromMap(Map<String, dynamic> map) {
    return LecturerStudentsModel(
      id: map['id'] as int,
      name: map['name'] as String,
      username: map['username'] as String,
      the_class: map['class'] as String,
      study_program: map['study_program'] as String,
      major: map['major'] as String,
      academic_year: map['academic_year'] as String,
    );
  }
}