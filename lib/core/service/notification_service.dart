import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enum untuk role user
enum UserRole {
  mahasiswa,
  dosen,
}

// Class untuk menyimpan settings notifikasi
class NotificationSettings {
  final bool isEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool showPreview;
  
  // Role-specific settings
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
    // Mahasiswa settings
    this.guidanceApprovalNotifications,
    this.guidanceRejectionNotifications,
    this.logbookCommentNotifications,
    this.announcementNotifications,
    // Dosen settings
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

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<bool> requestPermissions() async {
    final androidPermissions = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    final iosPermissions = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return (androidPermissions ?? false) || (iosPermissions ?? false);
  }

  Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
    required NotificationSettings settings,
  }) async {
    if (!settings.isEnabled) return;

    final androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.high,
      priority: Priority.high,
      playSound: settings.soundEnabled,
      enableVibration: settings.vibrationEnabled,
      styleInformation: settings.showPreview
          ? BigTextStyleInformation(body)
          : const DefaultStyleInformation(false, false),
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: settings.soundEnabled,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  // Method untuk update settings
  Future<void> updateSettings(NotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_settings', jsonEncode(settings.toJson()));
  }

  // Method untuk mendapatkan current settings
  Future<NotificationSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('notification_settings');
    if (settingsJson != null) {
      return NotificationSettings.fromJson(jsonDecode(settingsJson));
    }
    return NotificationSettings();
  }
   // Helper method untuk mengirim notifikasi mahasiswa
  Future<void> sendMahasiswaNotification({
    required String title,
    required String body,
    required String type, // 'announcement', 'guidance_approval', 'guidance_rejection', 'logbook_comment'
    String? payload,
  }) async {
    final settings = await getSettings();
    
    // Cek apakah notifikasi tipe ini diaktifkan
    bool shouldSend = false;
    switch (type) {
      case 'announcement':
        shouldSend = settings.announcementNotifications ?? false;
        break;
      case 'guidance_approval':
        shouldSend = settings.guidanceApprovalNotifications ?? false;
        break;
      case 'guidance_rejection':
        shouldSend = settings.guidanceRejectionNotifications ?? false;
        break;
      case 'logbook_comment':
        shouldSend = settings.logbookCommentNotifications ?? false;
        break;
    }

    if (shouldSend && settings.isEnabled) {
      await showNotification(
        title: title,
        body: body,
        payload: payload ?? '',
        settings: settings,
      );
    }
  }

  // Helper method untuk mengirim notifikasi dosen
  Future<void> sendDosenNotification({
    required String title,
    required String body,
    required String type, // 'new_guidance', 'revised_guidance', 'new_logbook', 'student_progress'
    String? payload,
  }) async {
    final settings = await getSettings();
    
    // Cek apakah notifikasi tipe ini diaktifkan
    bool shouldSend = false;
    switch (type) {
      case 'new_guidance':
        shouldSend = settings.newGuidanceNotifications ?? false;
        break;
      case 'revised_guidance':
        shouldSend = settings.revisedGuidanceNotifications ?? false;
        break;
      case 'new_logbook':
        shouldSend = settings.newLogbookNotifications ?? false;
        break;
      case 'student_progress':
        shouldSend = settings.studentProgressAlerts ?? false;
        break;
    }

    if (shouldSend && settings.isEnabled) {
      await showNotification(
        title: title,
        body: body,
        payload: payload ?? '',
        settings: settings,
      );
    }
  }

  void handleNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      print('Notification payload: ${response.payload}');
      // Add logic to handle payload, such as navigation
    }
  }

  // Method untuk handle notification tap
  Future<void> setupNotificationActions() async {
  final details = await _notifications.getNotificationAppLaunchDetails();

  if (details != null && details.didNotificationLaunchApp) {
    // Check if notificationResponse is present in details
    if (details.notificationResponse != null) {
      handleNotificationResponse(details.notificationResponse!);
    } else {
      print('No notification response data found');
    }
  }

  // Check if `onDidReceiveNotificationResponse` is available in the latest version
  // _notifications.onDidReceiveNotificationResponse?.listen((response) {
  //   if (response != null) {
  //     handleNotificationResponse(response);
  //   } 
  // });
}

}