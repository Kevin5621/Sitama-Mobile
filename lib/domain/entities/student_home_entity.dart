// ignore_for_file: non_constant_identifier_names

import 'package:sitama/domain/entities/guidance_entity.dart';
import 'package:sitama/domain/entities/lecturer_detail_student.dart';
import 'package:sitama/domain/entities/log_book_entity.dart';

class StudentHomeEntity {
  final String name;
  final List<GuidanceEntity> latest_guidances;
  final List<LogBookEntity> latest_log_books;

  StudentHomeEntity(
      {required this.name,
      required this.latest_guidances,
      required this.latest_log_books});
}

class StudentProfileEntity {
  final String name;
  final String username;
  final String email;
  final String ? photo_profile;
  final List<InternshipStudentEntity> ? internships;

  factory StudentProfileEntity.fromJson(Map<String, dynamic> json) {
    return StudentProfileEntity(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      photo_profile: json['photo_profile'],
      internships: json['internships'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'photo_profile': photo_profile,
      'internships': internships,
    };
  }

  StudentProfileEntity({
    required this.name,
    required this.username,
    required this.email,
    required this.photo_profile,
    this.internships,
  });
}
