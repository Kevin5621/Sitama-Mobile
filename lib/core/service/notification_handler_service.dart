import 'package:sistem_magang/core/service/notification_service.dart';
import 'package:sistem_magang/data/source/lecturer_api_service.dart';
import 'package:sistem_magang/data/source/student_api_service.dart';

class NotificationHandlerService {
  final NotificationService _notificationService;
  final StudentApiService _studentApiService;
  final LecturerApiService _lecturerApiService;

  NotificationHandlerService({
    required NotificationService notificationService,
    required StudentApiService studentApiService,
    required LecturerApiService lecturerApiService,
  }) : _notificationService = notificationService,
       _studentApiService = studentApiService,
       _lecturerApiService = lecturerApiService;

  // Initialize notification handling
  Future<void> initialize(UserRole role) async {
    await _notificationService.initialize();
    await _setupNotificationHandlers(role);
    await _notificationService.subscribeToTopics(role);
  }

  // Setup notification handlers based on user role
  Future<void> _setupNotificationHandlers(UserRole role) async {
    if (role == UserRole.mahasiswa) {
      _setupStudentNotificationHandlers();
    } else {
      _setupLecturerNotificationHandlers();
    }
  }

  void _setupStudentNotificationHandlers() {
    // Handle guidance status updates
    _notificationService.setNotificationHandler('guidance_approval', (data) async {
      // Refresh guidance data
      final result = await _studentApiService.getGuidances();
      result.fold(
        (error) => print('Error refreshing guidance data: $error'),
        (success) {
          // Handle successful data refresh
          // You might want to update your state management solution here
        }
      );
    });

    // Handle logbook comments
    _notificationService.setNotificationHandler('logbook_comment', (data) async {
      final result = await _studentApiService.getLogBook();
      result.fold(
        (error) => print('Error refreshing logbook data: $error'),
        (success) {
          // Handle successful data refresh
        }
      );
    });
  }

  void _setupLecturerNotificationHandlers() {
    // Handle new guidance requests
    _notificationService.setNotificationHandler('new_guidance', (data) async {
      if (data['student_id'] != null) {
        final studentId = int.parse(data['student_id']);
        final result = await _lecturerApiService.getDetailStudent(studentId);
        result.fold(
          (error) => print('Error fetching student details: $error'),
          (success) {
            // Handle successful data fetch
          }
        );
      }
    });

    // Handle new logbook entries
    _notificationService.setNotificationHandler('new_logbook', (data) async {
      if (data['student_id'] != null) {
        final studentId = int.parse(data['student_id']);
        final result = await _lecturerApiService.getDetailStudent(studentId);
        result.fold(
          (error) => print('Error fetching student details: $error'),
          (success) {
            // Handle successful data fetch
          }
        );
      }
    });
  }
}

// Extend NotificationService to include handler registration
extension NotificationServiceExtension on NotificationService {
  Map<String, Function(Map<String, dynamic>)> get _notificationHandlers => {};

  void setNotificationHandler(String type, Function(Map<String, dynamic>) handler) {
    _notificationHandlers[type] = handler;
  }

  Future<void> handleNotification(String type, Map<String, dynamic> data) async {
    final handler = _notificationHandlers[type];
    if (handler != null) {
      await handler(data);
    }
  }
}

// Example repository integration
class NotificationRepository {
  final NotificationHandlerService _notificationHandler;
  final NotificationService _notificationService;

  NotificationRepository({
    required NotificationHandlerService notificationHandler,
    required NotificationService notificationService,
  }) : _notificationHandler = notificationHandler,
       _notificationService = notificationService;

  Future<void> initializeNotifications(UserRole role) async {
    await _notificationHandler.initialize(role);
  }

  Future<void> updateNotificationSettings(NotificationSettings settings, UserRole role) async {
    await _notificationService.updateSettings(settings, role);
  }

  Future<NotificationSettings> getNotificationSettings() async {
    return await _notificationService.getSettings();
  }
}