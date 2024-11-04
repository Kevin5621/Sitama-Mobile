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
}
