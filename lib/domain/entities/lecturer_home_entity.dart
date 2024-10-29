class LecturerHomeEntity {
  final String name;
  final List<LecturerStudentsEntity> ? students;

  LecturerHomeEntity({required this.name, required this.students});

}

class LecturerStudentsEntity {
  final int id;
  final String name;
  final String username;
  final String the_class;
  final String study_program;
  final String major;
  final String academic_year;
  //menambahkan atribut notifikasi
  final int notificationStatus;

  LecturerStudentsEntity(
      {required this.id,
      required this.name,
      required this.username,
      required this.the_class,
      required this.study_program,
      required this.major,
      required this.academic_year,
      this.notificationStatus = 0,
    });
}
