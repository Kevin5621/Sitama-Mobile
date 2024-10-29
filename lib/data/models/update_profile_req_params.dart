import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class UpdateProfileReqParams {
  final PlatformFile photo_profile;

  UpdateProfileReqParams({required this.photo_profile});

  Future<FormData> toFormData() async {
    final formData = FormData();

    if (kIsWeb) {
      // Untuk aplikasi web, gunakan bytes
      formData.files.add(
        MapEntry(
          'photo_profile',
          MultipartFile.fromBytes(photo_profile.bytes!,
              filename: photo_profile.name),
        ),
      );
    } else {
      // Untuk mobile, gunakan path
      formData.files.add(
        MapEntry(
          'photo_profile',
          await MultipartFile.fromFile(photo_profile.path!,
              filename: photo_profile.name),
        ),
      );
    }

    return formData;
  }
}
