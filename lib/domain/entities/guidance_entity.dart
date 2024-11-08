// ignore_for_file: non_constant_identifier_names

class ListGuidanceEntity {
  final List<GuidanceEntity> guidances;

  ListGuidanceEntity({required this.guidances});
}


class GuidanceEntity {
  final int id;
  final String title;
  final String activity;
  final DateTime date;
  final String lecturer_note;
  final String name_file;
  final String status;

  GuidanceEntity({
    required this.id,
    required this.title,
    required this.activity,
    required this.date,
    required this.lecturer_note,
    required this.name_file,
    required this.status,
  });
}
