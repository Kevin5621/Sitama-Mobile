// notification_screen.dart
import 'package:flutter/material.dart';
import 'package:sistem_magang/presenstation/student/home/widgets/test/notification_entity.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _notifications = [
        NotificationItem(
          title: "Pengumuman Jadwal UAS",
          message: "Jadwal UAS semester genap 2023/2024 telah dirilis",
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: NotificationType.generalAnnouncement,
          senderName: "Admin Fakultas",
        ),
        NotificationItem(
          title: "Bimbingan Disetujui",
          message: "Bimbingan skripsi Bab 2 telah disetujui",
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          type: NotificationType.guidanceApproved,
          senderName: "Dr. Budi Santoso",
          avatarUrl: "https://example.com/avatar.jpg",
        ),
        // Add more sample notifications
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Belum Dibaca'),
            Tab(text: 'Semua'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadNotifications,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNotificationList(unreadOnly: true),
                  _buildNotificationList(unreadOnly: false),
                ],
              ),
            ),
    );
  }

  Widget _buildNotificationList({required bool unreadOnly}) {
    final filteredNotifications = unreadOnly
        ? _notifications.where((n) => !n.isRead).toList()
        : _notifications;

    if (filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              unreadOnly
                  ? 'Tidak ada notifikasi baru'
                  : 'Tidak ada notifikasi',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return NotificationListItem(
          notification: notification,
          onTap: () => _handleNotificationTap(notification),
          onMarkAsRead: () => _markAsRead(notification),
        );
      },
    );
  }

  void _handleNotificationTap(NotificationItem notification) {
    // Handle notification tap based on type
    switch (notification.type) {
      case NotificationType.generalAnnouncement:
        // Navigate to announcement detail
        break;
      case NotificationType.guidanceApproved:
      case NotificationType.guidanceRejected:
        // Navigate to guidance detail
        break;
      case NotificationType.logbookComment:
        // Navigate to logbook detail
        break;
      case NotificationType.newGuidance:
      case NotificationType.revisedGuidance:
        // Navigate to new guidance detail
        break;
    }
  }

  void _markAsRead(NotificationItem notification) {
    // Update notification read status
    setState(() {
      final index = _notifications.indexOf(notification);
      if (index != -1) {
        _notifications[index] = NotificationItem(
          title: notification.title,
          message: notification.message,
          timestamp: notification.timestamp,
          type: notification.type,
          isRead: true,
          senderName: notification.senderName,
          avatarUrl: notification.avatarUrl,
        );
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Notifikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Pengumuman'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Bimbingan'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Logbook'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Apply filters
            },
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}