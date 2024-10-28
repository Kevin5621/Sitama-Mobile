import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sistem_magang/data/models/notification.dart';
import 'package:sistem_magang/presenstation/student/home/widgets/notification_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override

  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
    // TODO refresh logic 
    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // TODO pagination logic 
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

