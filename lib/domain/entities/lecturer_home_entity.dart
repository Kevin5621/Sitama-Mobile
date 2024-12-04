// ignore_for_file: non_constant_identifier_names
class LecturerHomeEntity {
  final String name;
  final int id;
  final Set<LecturerStudentsEntity> ? students;
  final Map<String, bool>? activities;

  LecturerHomeEntity({
    required this.name, 
    required this.id, 
    required this.students,
    required this.activities,
    });
}

class LecturerStudentsEntity {
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

  LecturerStudentsEntity({
    required this.id,
    required this.name,
    required this.username,
    this.photo_profile,
    required this.the_class,
    required this.study_program,
    required this.major,
    required this.academic_year,
    required this.isFinished,
    required this.activities,
    });
}
