// internship_model.dart
class InternshipModel {
  final String name;
  final String companyName;
  final String startDate;
  final String endDate;

  InternshipModel({
    required this.name,
    required this.companyName,
    required this.startDate,
    required this.endDate,
  });

  factory InternshipModel.fromJson(Map<String, dynamic> json) {
    return InternshipModel(
      name: json['name'] ?? '',
      companyName: json['company_name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }
}


