// ignore_for_file: non_constant_identifier_names

class LecturerProfileEntity {
  final String name;
  final String username;
  final String? photo_profile;

  factory LecturerProfileEntity.fromJson(Map<String, dynamic> json) {
    return LecturerProfileEntity(
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      photo_profile: json['photo_profile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'photo_profile': photo_profile,
    };
  }

  LecturerProfileEntity({
    required this.name,
    required this.username,
    this.photo_profile,
  });
}