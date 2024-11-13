class NotificationList {
  final int id;
  final int userId;
  final String message;
  final String date;
  final String category;
  final int isRead;
  final String? detailText;
  final String createdAt;
  final String updatedAt;

  NotificationList({
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

  // Factory constructor untuk mengkonversi JSON ke objek Notification
  factory NotificationList.fromJson(Map<String, dynamic> json) {
  return NotificationList(
    id: json['id'] ?? 0,
    userId: json['user_id'] ?? 0,
    message: json['message'] ?? '',
    date: json['date'] ?? '',
    category: json['category'] ?? '',
    isRead: json['is_read'] ?? 0,
    detailText: json['detail_text'], 
    createdAt: json['created_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
  );
}
}

// Response wrapper untuk list notifikasi
class NotificationModel {
  final String code;
  final String status;
  final NotificationData data;

  NotificationModel({
    required this.code,
    required this.status,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
  return NotificationModel(
    code: json['code'] ?? '',
    status: json['status'] ?? '',
    data: NotificationData.fromJson(json['data'] ?? {'notifications': []}),
  );
}
}

// Data class untuk menampung list notifikasi
class NotificationData {
  final List<NotificationList> notifications;

  NotificationData({
    required this.notifications,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    var notificationsList = json['notifications'];
    if (notificationsList == null) return NotificationData(notifications: []);
    
    return NotificationData(
      notifications: (notificationsList as List)
          .map((notification) => NotificationList.fromJson(notification))
          .toList(),
    );
  }
}

extension NotificationXModel on NotificationModel {
  NotificationResponseEntity toEntity() {
    return NotificationResponseEntity(
      code: code,
      status: status,
      data: NotificationDataEntity(
        notifications: data.notifications
            .map((notification) => NotificationItemEntity(
                  id: notification.id,
                  userId: notification.userId,
                  message: notification.message,
                  date: notification.date,
                  category: notification.category,
                  isRead: notification.isRead,
                  detailText: notification.detailText,
                  createdAt: notification.createdAt,
                  updatedAt: notification.updatedAt,
                ))
            .toList(),
      ),
    );
  }
}

// Entity classes to maintain consistency with the pattern
class NotificationResponseEntity  {
  final String code;
  final String status;
  final NotificationDataEntity data;

  NotificationResponseEntity ({
    required this.code,
    required this.status,
    required this.data,
  });
}

class NotificationDataEntity {
  final List<NotificationItemEntity> notifications;

  NotificationDataEntity({
    required this.notifications,
  });
}

class NotificationItemEntity {
  final int id;
  final int userId;
  final String message;
  final String date;
  final String category;
  final int isRead;
  final String? detailText;
  final String createdAt;
  final String updatedAt;

  NotificationItemEntity({
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