import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole {
  mahasiswa,
  dosen,
}

class NotificationSettings {
  final bool isEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool showPreview;
  
  // Mahasiswa settings
  final bool? guidanceApprovalNotifications;
  final bool? guidanceRejectionNotifications;
  final bool? logbookCommentNotifications;
  final bool? announcementNotifications;
  
  // Dosen settings
  final bool? newGuidanceNotifications;
  final bool? revisedGuidanceNotifications;
  final bool? newLogbookNotifications;
  final bool? studentProgressAlerts;

  NotificationSettings({
    this.isEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.showPreview = true,
    this.guidanceApprovalNotifications,
    this.guidanceRejectionNotifications,
    this.logbookCommentNotifications,
    this.announcementNotifications,
    this.newGuidanceNotifications,
    this.revisedGuidanceNotifications,
    this.newLogbookNotifications,
    this.studentProgressAlerts,
  });

  Map<String, dynamic> toJson() => {
        'isEnabled': isEnabled,
        'soundEnabled': soundEnabled,
        'vibrationEnabled': vibrationEnabled,
        'showPreview': showPreview,
        'guidanceApprovalNotifications': guidanceApprovalNotifications,
        'guidanceRejectionNotifications': guidanceRejectionNotifications,
        'logbookCommentNotifications': logbookCommentNotifications,
        'announcementNotifications': announcementNotifications,
        'newGuidanceNotifications': newGuidanceNotifications,
        'revisedGuidanceNotifications': revisedGuidanceNotifications,
        'newLogbookNotifications': newLogbookNotifications,
        'studentProgressAlerts': studentProgressAlerts,
      };

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      isEnabled: json['isEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      showPreview: json['showPreview'] ?? true,
      guidanceApprovalNotifications: json['guidanceApprovalNotifications'],
      guidanceRejectionNotifications: json['guidanceRejectionNotifications'],
      logbookCommentNotifications: json['logbookCommentNotifications'],
      announcementNotifications: json['announcementNotifications'],
      newGuidanceNotifications: json['newGuidanceNotifications'],
      revisedGuidanceNotifications: json['revisedGuidanceNotifications'],
      newLogbookNotifications: json['newLogbookNotifications'],
      studentProgressAlerts: json['studentProgressAlerts'],
    );
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  /// Initialize Firebase Cloud Messaging and Local Notifications
  Future<void> initialize() async {
    // Request permission for iOS
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitialize = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle when notification is tapped and app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTapped);

    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token'); // Save this token to your backend
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      // Handle notification tap
      final Map<String, dynamic> data = json.decode(response.payload!);
      _handleNotificationNavigation(data);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final settings = await getSettings();
    if (!settings.isEnabled) return;

    // Check if notification type is enabled in settings
    if (!_isNotificationTypeEnabled(message.data['type'], settings)) return;

    // Show local notification
    await _showLocalNotification(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      payload: json.encode(message.data),
    );
  }

  void _handleNotificationTapped(RemoteMessage message) {
    _handleNotificationNavigation(message.data);
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    // Implement your navigation logic here based on the notification data
    // Example:
    switch (data['route']) {
      case 'guidance':
        // Navigate to guidance page
        break;
      case 'logbook':
        // Navigate to logbook page
        break;
      // Add more cases as needed
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  bool _isNotificationTypeEnabled(String? type, NotificationSettings settings) {
    if (type == null) return false;

    switch (type) {
      // Mahasiswa notifications
      case 'announcement':
        return settings.announcementNotifications ?? false;
      case 'guidance_approval':
        return settings.guidanceApprovalNotifications ?? false;
      case 'guidance_rejection':
        return settings.guidanceRejectionNotifications ?? false;
      case 'logbook_comment':
        return settings.logbookCommentNotifications ?? false;

      // Dosen notifications
      case 'new_guidance':
        return settings.newGuidanceNotifications ?? false;
      case 'revised_guidance':
        return settings.revisedGuidanceNotifications ?? false;
      case 'new_logbook':
        return settings.newLogbookNotifications ?? false;
      case 'student_progress':
        return settings.studentProgressAlerts ?? false;
      
      default:
        return false;
    }
  }

  /// Subscribe to topics based on user role and settings
  Future<void> subscribeToTopics(UserRole role) async {
    final settings = await getSettings();
    if (!settings.isEnabled) return;

    if (role == UserRole.mahasiswa) {
      if (settings.guidanceApprovalNotifications ?? false) {
        await _firebaseMessaging.subscribeToTopic('guidance_approval');
      }
      if (settings.guidanceRejectionNotifications ?? false) {
        await _firebaseMessaging.subscribeToTopic('guidance_rejection');
      }
      // Add more topic subscriptions
    } else if (role == UserRole.dosen) {
      if (settings.newGuidanceNotifications ?? false) {
        await _firebaseMessaging.subscribeToTopic('new_guidance');
      }
      if (settings.newLogbookNotifications ?? false) {
        await _firebaseMessaging.subscribeToTopic('new_logbook');
      }
      // Add more topic subscriptions
    }
  }

  /// Update notification settings and resubscribe to topics
  Future<void> updateSettings(NotificationSettings settings, UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_settings', jsonEncode(settings.toJson()));
    
    // Unsubscribe from all topics first
    await _unsubscribeFromAllTopics();
    
    // Resubscribe based on new settings
    if (settings.isEnabled) {
      await subscribeToTopics(role);
    }
  }

  Future<void> _unsubscribeFromAllTopics() async {
    final topics = [
      'guidance_approval',
      'guidance_rejection',
      'logbook_comment',
      'announcement',
      'new_guidance',
      'revised_guidance',
      'new_logbook',
      'student_progress',
    ];

    for (final topic in topics) {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    }
  }

  Future<NotificationSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('notification_settings');
    if (settingsJson != null) {
      return NotificationSettings.fromJson(jsonDecode(settingsJson));
    }
    return NotificationSettings();
  }
}

// Background message handler - must be top-level function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
  print('Handling background message: ${message.messageId}');
}