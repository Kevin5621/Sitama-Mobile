// ignore_for_file: non_constant_identifier_names

import 'package:sistem_magang/domain/entities/lecturer_profile_entity.dart';

class LecturerProfileModel {
  final String name;
  final String username;
  final String? photo_profile;

  LecturerProfileModel({
    required this.name,
    required this.username,
    this.photo_profile,
  });

  factory LecturerProfileModel.fromMap(Map<String, dynamic> map) {
    return LecturerProfileModel(
      name: map['name'] as String,
      username: map['username'] as String,
      photo_profile:
          map['photo_profile'] != null ? map['photo_profile'] as String : null,
    );
  }
}

  extension LecturerProfileXModel on LecturerProfileModel {
  LecturerProfileEntity toEntity() {
    return LecturerProfileEntity(
      name: name,
      username: username,
      photo_profile: photo_profile,
    );
  }
}