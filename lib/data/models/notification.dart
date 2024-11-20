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

class NotificationDataModel {
  final List<NotificationList> notifications;

  NotificationDataModel({
    required this.notifications,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    var notificationsList = json['notifications'];
    if (notificationsList == null) return NotificationDataModel(notifications: []);

    return NotificationDataModel(
      notifications: (notificationsList as List)
          .map((notification) => NotificationList.fromJson(notification))
          .toList(),
    );
  }
}

extension NotificationXModel on NotificationDataModel {
  NotificationDataEntity toEntity() {
    return NotificationDataEntity(
      notifications: notifications
          .map((data) => NotificationItemEntity(
                id: data.id,
                userId: data.userId,
                message: data.message,
                date: data.date,
                category: data.category,
                isRead: data.isRead,
                detailText: data.detailText,
                createdAt: data.createdAt,
                updatedAt: data.updatedAt,
              ))
          .toList(),
    );
  }
}

extension NotificationDataEntityX on NotificationDataEntity {
  NotificationItemEntity? getLatestGeneralNotification() {
    final filteredList = notifications
        .where((notification) =>
            notification.category.toLowerCase() == 'general' ||
            notification.category.toLowerCase() == 'generalannouncement')
        .toList();
    
    if (filteredList.isEmpty) return null;
    
    filteredList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filteredList.first;
  }
}

class NotificationResponseEntity {
  final String code;
  final String status;
  final NotificationDataEntity data;

  NotificationResponseEntity({
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