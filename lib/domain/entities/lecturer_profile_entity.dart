// ignore_for_file: non_constant_identifier_names

class LecturerProfileEntity {
  final String name;
  final String username;
  final String? photo_profile;

  LecturerProfileEntity({
    required this.name,
    required this.username,
    this.photo_profile,
  });
}