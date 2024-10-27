class ListLogBookEntity {
  final List<LogBookEntity> log_books;

  ListLogBookEntity({required this.log_books});
}

class LogBookEntity {
  final int id;
  final String title;
  final String activity;
  final DateTime date;

  LogBookEntity(
      {required this.id, required this.title, required this.activity, required this.date});
}