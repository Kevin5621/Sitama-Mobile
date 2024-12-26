
import 'package:sitama/features/student/data/models/notification.dart';

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

  const NotificationItemEntity({
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

  NotificationItemEntity copyWith({
    int? id,
    int? userId,
    String? message,
    String? date,
    String? category,
    int? isRead,
    String? detailText,
    String? createdAt,
    String? updatedAt,
  }) {
    return NotificationItemEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      date: date ?? this.date,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
      detailText: detailText ?? this.detailText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Extensions
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


// Data class untuk menampung list notifikasi
class NotificationDataEntity {
  final List<NotificationItemEntity> notifications;

  const NotificationDataEntity({
    required this.notifications,
  });

  // Helper methods
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

  int getUnreadCount() {
    return notifications.where((notification) => notification.isRead == 0).length;
  }
}