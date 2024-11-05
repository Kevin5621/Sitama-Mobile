import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:sistem_magang/service_locator.dart';

class NotificationController {
  static void onActionReceivedMethod(ReceivedAction action) {
    if (action.channelKey == 'basic_channel') {
      final target = action.payload?['target'];
      if (target == 'student') {
        locator<NavigationService>().navigateTo('/studentPage');
      } else if (target == 'lecturer') {
        locator<NavigationService>().navigateTo('/lecturerPage');
      }
    }
  }

  static void onNotificationCreatedMethod(ReceivedNotification receivedNotification) {
    // Tambahkan logika tambahan jika diperlukan
  }

  static void onNotificationDisplayedMethod(ReceivedNotification receivedNotification) {
    // Tambahkan logika tambahan jika diperlukan
  }

  static void onDismissActionReceivedMethod(ReceivedAction action) {
    // Tambahkan logika tambahan jika diperlukan
  }
}
