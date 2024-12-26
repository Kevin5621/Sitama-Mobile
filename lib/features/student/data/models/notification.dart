// Models
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

  const NotificationList({
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'message': message,
    'date': date,
    'category': category,
    'is_read': isRead,
    'detail_text': detailText,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class NotificationDataModel {
  final List<NotificationList> notifications;

  const NotificationDataModel({
    required this.notifications,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    final notificationsList = json['notifications'] as List?;
    return NotificationDataModel(
      notifications: notificationsList
          ?.map((notification) => NotificationList.fromJson(notification))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'notifications': notifications.map((notification) => notification.toJson()).toList(),
  };
}

// Request Parameters
class MarkAllReqParams {
  final List<int> notificationIds;
  final int isRead;

  const MarkAllReqParams({
    required this.notificationIds,
    required this.isRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'notification_ids': notificationIds,
      'is_read': isRead == 1 
    };
  }
}

class AddNotificationReqParams {
  final int? userId;
  final String message;
  final String date;
  final String category;
  final String? detailText;

  static const List<String> validCategories = [
    'guidance',
    'log_book',
    'general',
    'revisi',
  ];

  AddNotificationReqParams({
    this.userId,
    required this.message,
    required this.date,
    required this.category,
    this.detailText,
  }) {
    // Validate kategori
    if (!validCategories.contains(category)) {
      throw ArgumentError('Invalid notification category: $category');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'message': message,
      'date': date,
      'category': category,
      'detail_text': detailText,
    };
  }
}