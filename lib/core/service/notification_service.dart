import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';

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

  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null, // null = use default app icon
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Channel for basic notifications',
          defaultColor: AppColors.lightPrimary,
          ledColor: AppColors.lightWhite,
          importance: NotificationImportance.High,
        ),
      ],
    );
  }

  Future<bool> requestPermissions() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      return await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
    required NotificationSettings settings,
  }) async {
    if (!settings.isEnabled) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecond,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        payload: {'data': payload},
        notificationLayout: settings.showPreview 
            ? NotificationLayout.BigText 
            : NotificationLayout.Default,
        category: NotificationCategory.Message,
      ),
    );
  }

  Future<void> cancelAll() async {
    await AwesomeNotifications().cancelAll();
  }

  Future<void> updateSettings(NotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_settings', jsonEncode(settings.toJson()));
  }

  Future<NotificationSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('notification_settings');
    if (settingsJson != null) {
      return NotificationSettings.fromJson(jsonDecode(settingsJson));
    }
    return NotificationSettings();
  }

  Future<void> sendMahasiswaNotification({
    required String title,
    required String body,
    required String type,
    String? payload,
  }) async {
    final settings = await getSettings();
    
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

  Future<void> sendDosenNotification({
    required String title,
    required String body,
    required String type,
    String? payload,
  }) async {
    final settings = await getSettings();
    
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

  // Setup notification tap handling
  void setupNotificationActions() {
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      if (receivedNotification.payload != null) {
        print('Notification payload: ${receivedNotification.payload}');
        // Add navigation logic here
      }
    });
  }

  // Method to be called in your app's dispose/deactivate
  void dispose() {
    AwesomeNotifications().actionStream.close();
  }
}