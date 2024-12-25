// ignore_for_file: non_constant_identifier_names

class ListLogBookEntity {
  final List<LogBookEntity> log_books;

  ListLogBookEntity({required this.log_books});
}

class LogBookEntity {
  final int id;
  final String title;
  final String activity;
  final DateTime date;
  final String lecturer_note;

  LogBookEntity({
    required this.id,
    required this.title,
    required this.activity,
    required this.date,
    required this.lecturer_note,
  });

  factory LogBookEntity.fromJson(Map<String, dynamic> json) {
    return LogBookEntity(
      id: json['id'],
      title: json['title'],
      activity: json['activity'],
      date: DateTime.parse(json['date']),
      lecturer_note: json['lecturer_note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'activity': activity,
      'date': date.toIso8601String(),
      'lecturer_note': lecturer_note,
    };
  }
}
