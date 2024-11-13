
class NotificationItemEntity  {
  final int id;
  final int userId;
  final String message;
  final String date;
  final String category;
  final int isRead;
  final String? detailText;
  final String createdAt;
  final String updatedAt;

  NotificationItemEntity ({
    required this.id,
    required this.userId,
    required this.message,
    required this.date,
    required this.category,
    required this.isRead,
    this.detailText,
    required this.createdAt,
    required this.updatedAt,
  });
}


// Data class untuk menampung list notifikasi
class NotificationDataEntity {
  final List<NotificationItemEntity> notifications;

  NotificationDataEntity({
    required this.notifications,
  });
}