// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'package:Sitama/domain/entities/log_book_entity.dart';

class ListLogBookModel {
  final List<LogBookModel> log_books;

  ListLogBookModel({required this.log_books});

  factory ListLogBookModel.fromMap(Map<String, dynamic> map) {
    return ListLogBookModel(
      log_books: List<LogBookModel>.from(
        (map['log_books'] as List<dynamic>).map<LogBookModel>(
          (x) => LogBookModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

extension ListLogBookXModel on ListLogBookModel {
  ListLogBookEntity toEntity() {
    return ListLogBookEntity(
        log_books: log_books
            .map<LogBookEntity>((data) => LogBookEntity(
                id: data.id,
                title: data.title,
                activity: data.activity,
                date: data.date, 
                lecturer_note: data.lecturer_note,
              ))
            .toList());
  }
}

class LogBookModel {
  final int id;
  final String title;
  final String activity;
  final String lecturer_note;
  final DateTime date;

  LogBookModel(
      {required this.id,
      required this.title,
      required this.activity,
      required this.lecturer_note,
      required this.date});

  factory LogBookModel.fromMap(Map<String, dynamic> map) {
    return LogBookModel(
      id: map['id'] as int,
      title: map['title'] as String,
      activity: map['activity'] as String,
      date: DateFormat('yyyy-MM-dd').parse(map['date'] as String),
      lecturer_note: map['lecturer_note'] ?? 'tidak ada catatan',
    );
  }
}

class AddLogBookReqParams {
  final String title;
  final String activity;
  final DateTime date;

  AddLogBookReqParams({required this.title, required this.activity, required this.date});

  Map<String, dynamic> toMap() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return <String, dynamic>{
      'title': title,
      'activity': activity,
      'date': formattedDate,
    };
  }
}

class EditLogBookReqParams {
  final int id;
  final String title;
  final String activity;
  final DateTime date;

  EditLogBookReqParams({
    required this.id, 
    required this.title, 
    required this.activity,    
    required this.date
  });

  // Converts request parameters to FormData for API submission
  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('title', title),
      MapEntry('activity', activity),
      MapEntry('date', DateFormat('yyyy-MM-dd').format(date)),
    ]);

    return formData;
  }
}

class UpdateLogBookReqParams {
  final int id;
  final String? lecturer_note;

  UpdateLogBookReqParams({
    required this.id,
    this.lecturer_note,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lecturer_note': lecturer_note,
    };
  }
}