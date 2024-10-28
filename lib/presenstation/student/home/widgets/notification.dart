// notification_model.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// notification_model.dart
class NotificationModel {
  final String id;
  final String message;
  final String date;
  final String type;
  bool isRead;
  final String? actionData;
  final String? detailText; 

  NotificationModel({
    required this.id,
    required this.message,
    required this.date,
    required this.type,
    this.isRead = false,
    this.actionData,
    this.detailText,
  });
}

// notification_screen.dart
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final RefreshController _refreshController = RefreshController();
  late List<NotificationModel> _notifications;

@override
  void initState() {
    super.initState();
    _notifications = [
      NotificationModel(
        id: '1',
        message: 'Anda telah dijadwalkan bimbingan 1 yang dilaksanakan pada Kamis, 17 Oktober 2024.',
        date: '20-12-2024',
        type: 'guidance',
        isRead: false,
        detailText: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      ),
      NotificationModel(
        id: '2',
        message: 'Anda belum mengisi logbook minggu ini. Harap segera mengisi logbook untuk memantau progress kegiatan Anda.',
        date: '19-12-2024',
        type: 'logbook',
        isRead: false,
        detailText: 'Untuk mengisi logbook, silakan kunjungi halaman logbook dan isi sesuai dengan kegiatan yang telah Anda lakukan selama seminggu terakhir.',
      ),
      NotificationModel(
        id: '3',
        message: 'Anda belum mengisi logbook minggu ini. Harap segera mengisi logbook untuk memantau progress kegiatan Anda.',
        date: '19-12-2024',
        type: 'revision',
        isRead: false,
        detailText: 'Untuk mengisi logbook, silakan kunjungi halaman logbook dan isi sesuai dengan kegiatan yang telah Anda lakukan selama seminggu terakhir.',
      ),NotificationModel(
        id: '4',
        message: 'Anda belum mengisi logbook minggu ini. Harap segera mengisi logbook untuk memantau progress kegiatan Anda.',
        date: '19-12-2024',
        type: 'General',
        isRead: false,
        detailText: 'Untuk mengisi logbook, silakan kunjungi halaman logbook dan isi sesuai dengan kegiatan yang telah Anda lakukan selama seminggu terakhir.',
      ),
    ];
  }


  void _onRefresh() async {
    // Implement refresh logic here
    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // Implement pagination logic here
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.loadComplete();
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((notification) => notification.id == id);
      if (index != -1) {
        _notifications[index].isRead = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  int get _unreadCount => _notifications.where((notification) => !notification.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          if (_unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all, color: Colors.blue),
              onPressed: _markAllAsRead,
            ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        child: ListView.builder(
          itemCount: _notifications.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            return NotificationCard(
              notification: notification,
              onTap: () {
                _markAsRead(notification.id);
              },
            );
          },
        ),
      ),
    );
  }
}

// notification_card.dart
class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isExpanded = false;

  IconData _getNotificationIcon() {
    switch (widget.notification.type) {
      case 'guidance':
        return Icons.school;
      case 'logbook':
        return Icons.book;
      case 'revision':
        return Icons.edit_document;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor() {
    switch (widget.notification.type) {
      case 'guidance':
        return Colors.blue;
      case 'logbook':
        return Colors.orange;
      case 'revision':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _truncateText(String text) {
    List<String> words = text.split(' ');
    if (words.length <= 10) return text;
    return '${words.take(10).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          widget.onTap();
          setState(() {
            isExpanded = !isExpanded;
          });
        },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: widget.notification.isRead ? Colors.white : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.notification.isRead 
                    ? Colors.grey[100] 
                    : Colors.blue.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: _getNotificationColor(),
                    child: Icon(
                      _getNotificationIcon(),
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.notification.type.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.notification.date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isExpanded 
                              ? widget.notification.message
                              : _truncateText(widget.notification.message),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.3,
                            fontWeight: widget.notification.isRead 
                                ? FontWeight.normal 
                                : FontWeight.w500,
                          ),
                        ),
                        if (isExpanded && widget.notification.detailText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.notification.detailText!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Expand/Collapse button
                  if (widget.notification.message.split(' ').length > 10 || 
                      widget.notification.detailText != null)
                    InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isExpanded ? 'Show Less' : 'Read More',
                              style: TextStyle(
                                color: _getNotificationColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              isExpanded 
                                  ? Icons.keyboard_arrow_up 
                                  : Icons.keyboard_arrow_down,
                              color: _getNotificationColor(),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// notification_badge.dart
class NotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;

  const NotificationBadge({
    Key? key,
    required this.count,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
