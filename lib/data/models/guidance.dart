// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

import 'package:Sitama/domain/entities/guidance_entity.dart';

// Model for a list of guidances
class ListGuidanceModel {
  final List<GuidanceModel> guidances;

  ListGuidanceModel({required this.guidances});

  // Factory method to convert a map into a ListGuidanceModel
  factory ListGuidanceModel.fromMap(Map<String, dynamic> map) {
    return ListGuidanceModel(
      guidances: List<GuidanceModel>.from(
        (map['guidances'] as List<dynamic>).map<GuidanceModel>(
          (x) => GuidanceModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

// Extension to convert ListGuidanceModel into ListGuidanceEntity
extension ListGuidanceXModel on ListGuidanceModel {
  ListGuidanceEntity toEntity() {
    return ListGuidanceEntity(
      guidances: guidances
          .map<GuidanceEntity>(
            (data) => GuidanceEntity(
              id: data.id,
              title: data.title,
              activity: data.activity,
              date: data.date,
              lecturer_note: data.lecturer_note,
              name_file: data.name_file,
              status: data.status,
            ),
          )
          .toList(),
    );
  }
}

// Model for individual guidance
class GuidanceModel {
  final int id;
  final String title;
  final String activity;
  final DateTime date;
  final String lecturer_note;
  final String name_file;
  final String status;

  GuidanceModel({
    required this.id,
    required this.title,
    required this.activity,
    required this.date,
    required this.lecturer_note,
    required this.name_file,
    required this.status,
  });

  // Factory method to convert a map into a GuidanceModel
  factory GuidanceModel.fromMap(Map<String, dynamic> map) {
    return GuidanceModel(
      id: map['id'] as int,
      title: map['title'] as String,
      activity: map['activity'] as String,
      date: DateFormat('yyyy-MM-dd').parse(map['date'] as String),
      lecturer_note: map['lecturer_note'] ?? 'tidak ada catatan',
      name_file: map['name_file'] ?? 'tidak ada file',
      status: map['status'] as String,
    );
  }
}

// Request parameters for adding a new guidance
class AddGuidanceReqParams {
  final String title;
  final String activity;
  final DateTime date;
  final PlatformFile? file;

  AddGuidanceReqParams({
    required this.title,
    required this.activity,
    required this.date,
    this.file,
  });

  // Converts request parameters to FormData for API submission
  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('title', title),
      MapEntry('activity', activity),
      MapEntry('date', DateFormat('yyyy-MM-dd').format(date)),
    ]);

    if (file != null) {
      final fileEntry = kIsWeb
          ? MultipartFile.fromBytes(file!.bytes!, filename: file!.name)
          : await MultipartFile.fromFile(file!.path!, filename: file!.name);
      formData.files.add(MapEntry('name_file', fileEntry));
    }

    return formData;
  }
}

// Request parameters for editing an existing guidance
class EditGuidanceReqParams {
  final int id;
  final String title;
  final String activity;
  final DateTime date;
  final PlatformFile? file;

  EditGuidanceReqParams({
    required this.id,
    required this.title,
    required this.activity,
    required this.date,
    this.file,
  });

  // Converts request parameters to FormData for API submission
  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('title', title),
      MapEntry('activity', activity),
      MapEntry('date', DateFormat('yyyy-MM-dd').format(date)),
    ]);

    if (file != null) {
      final fileEntry = kIsWeb
          ? MultipartFile.fromBytes(file!.bytes!, filename: file!.name)
          : await MultipartFile.fromFile(file!.path!, filename: file!.name);
      formData.files.add(MapEntry('name_file', fileEntry));
    }

    return formData;
  }
}

// Request parameters for updating guidance status
class UpdateStatusGuidanceReqParams {
  final int id;
  final String status;
  final String? lecturer_note;

  UpdateStatusGuidanceReqParams({
    required this.id,
    required this.status,
    this.lecturer_note,
  });

  // Converts parameters to a map for API submission
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'lecturer_note': lecturer_note,
    };
  }
}

// Request parameters for marking a student as finished
class UpdateFinishedStudentReqParams {
  final int id;
  final bool isFinished;

  UpdateFinishedStudentReqParams({
    required this.id,
    required this.isFinished,
  });

  // Converts parameters to a map for API submission
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'is_finished': isFinished,
    };
  }
}
