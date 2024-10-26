import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';

class StudentHomeEntity {
  final String name;
  final List<GuidanceEntity> latest_guidances;
  final List<LogBookEntity> latest_log_books;

  StudentHomeEntity({required this.name, required this.latest_guidances, required this.latest_log_books});

}

class StudentProfileEntity {
  final String name;
  final String username;
  final String email;
  final String photo_profile;
  final List<InternshipStudentEntity>? internship;

  StudentProfileEntity(
      {required this.name,
      required this.username,
      required this.email,
      required this.photo_profile,
      this.internship});
}



