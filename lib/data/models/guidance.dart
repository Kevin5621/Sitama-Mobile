// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

import 'package:sistem_magang/domain/entities/guidance_entity.dart';

class ListGuidanceModel {
  final List<GuidanceModel> guidances;

  ListGuidanceModel({required this.guidances});

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

extension ListGuidanceXModel on ListGuidanceModel {
  ListGuidanceEntity toEntity() {
    return ListGuidanceEntity(
        guidances: guidances
            .map<GuidanceEntity>((data) => GuidanceEntity(
                  id: data.id,
                  title: data.title,
                  activity: data.activity,
                  date: data.date,
                  lecturer_note: data.lecturer_note,
                  name_file: data.name_file,
                  status: data.status,
                ))
            .toList());
  }
}

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

  factory GuidanceModel.fromMap(Map<String, dynamic> map) {
    return GuidanceModel(
      id: map['id'] as int,
      title: map['title'] as String,
      activity: map['activity'] as String,
      date: DateFormat('yyyy-MM-dd').parse(map['date'] as String),
      lecturer_note: map['lecturer_note'] != null
          ? map['lecturer_note'] as String
          : 'tidak ada catatan',
      name_file: map['name_file'] != null
          ? map['name_file'] as String
          : 'tidak ada file',
      status: map['status'] as String,
    );
  }
}

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

  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('title', title),
      MapEntry('activity', activity),
      MapEntry('date', DateFormat('yyyy-MM-dd').format(date)),
    ]);

    if (file != null) {
      if (kIsWeb) {
        formData.files.add(
          MapEntry(
            'name_file',
            MultipartFile.fromBytes(file!.bytes!, filename: file!.name),
          ),
        );
      } else {
        formData.files.add(
          MapEntry(
            'name_file',
            await MultipartFile.fromFile(file!.path!, filename: file!.name),
          ),
        );
      }
    }
    return formData;
  }
}

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

  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('title', title),
      MapEntry('activity', activity),
      MapEntry('date', DateFormat('yyyy-MM-dd').format(date)),
    ]);

    if (file != null) {
      if (kIsWeb) {
        formData.files.add(
          MapEntry(
            'name_file',
            MultipartFile.fromBytes(file!.bytes!, filename: file!.name),
          ),
        );
      } else {
        formData.files.add(
          MapEntry(
            'name_file',
            await MultipartFile.fromFile(file!.path!, filename: file!.name),
          ),
        );
      }
    }

    return formData;
  }
}

class UpdateStatusGuidanceReqParams {
  final int id;
  final String status;
  final String? lecturer_note;

  UpdateStatusGuidanceReqParams({
    required this.id,
    required this.status,
    this.lecturer_note,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'lecturer_note': lecturer_note,
    };
  }
}