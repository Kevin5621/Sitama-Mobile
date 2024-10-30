class NotificationModel {
  final String id;
  final String message;
  final String date;
  final String type;
  bool isRead;
  final String? actionData;
  final String? detailText; 

  NotificationModel({
    required this.id,
    required this.message,
    required this.date,
    required this.type,
    this.isRead = false,
    this.actionData,
    this.detailText,
  });
}