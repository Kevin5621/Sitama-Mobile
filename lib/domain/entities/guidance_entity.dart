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

  factory GuidanceEntity.fromJson(Map<String, dynamic> json) {
    return GuidanceEntity(
      id: json['id'],
      title: json['title'],
      activity: json['activity'],
      date: DateTime.parse(json['date']),
      lecturer_note: json['lecturer_note'],
      name_file: json['name_file'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'activity': activity,
      'date': date.toIso8601String(),
      'lecturer_note': lecturer_note,
      'name_file': name_file,
      'status': status,
    };
  }
}