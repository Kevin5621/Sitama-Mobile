import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sistem_magang/common/widgets/custom_snackbar.dart';
import 'package:sistem_magang/data/models/notification.dart';
import 'package:sistem_magang/domain/usecases/student/notification/get_notification.dart';
import 'package:sistem_magang/domain/usecases/student/notification/mark_all_notifications.dart';
import 'package:sistem_magang/service_locator.dart';
import 'package:sistem_magang/presenstation/student/home/widgets/notification_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final RefreshController _refreshController = RefreshController();
  final markAllNotificationsReadUseCase = sl<MarkAllNotificationsReadUseCase>();
  final _getNotificationsUseCase = sl<GetNotificationsUseCase>();
  List<NotificationItemEntity> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _getNotificationsUseCase.call();

      result.fold(
        (error) {
          setState(() {
            _error = error.toString();
            _isLoading = false;
          });
          _refreshController.refreshFailed();
        },
        (notificationEntity) {
          setState(() {
            _notifications = notificationEntity.notifications;
            _isLoading = false;
          });
          _refreshController.refreshCompleted();
        },
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      _refreshController.refreshFailed();
    }
  }

  void _onRefresh() async {
    await _fetchNotifications();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () {
              _markAllNotificationsAsRead();
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Notifikasi',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Notifikasi',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$_error'),
              ElevatedButton(
                onPressed: _fetchNotifications,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            _markAllNotificationsAsRead();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Notifikasi',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          if (_notifications.any((n) => n.isRead == 0))
            TextButton(
              onPressed: _markAllNotificationsAsRead,
              child: Text(
                'Tandai Semua Dibaca',
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(
          waterDropColor: colorScheme.primary,
        ),
        child: _notifications.isEmpty
            ? const Center(
                child: Text('Tidak ada notifikasi'),
              )
            : ListView.builder(
                itemCount: _notifications.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return NotificationCard(
                    notification: notification,
                    onTap: () {
                      (notification);
                    },
                  );
                },
              ),
      ),
    );
  }

  Future<void> _markAllNotificationsAsRead() async {
    try {
      // Ambil ID dari semua notifikasi yang belum dibaca
      final unreadNotificationIds = _notifications
          .where((n) => n.isRead == 0)
          .map((n) => n.id)
          .toList();

      // Panggil use case untuk menandai notifikasi sebagai dibaca di server
      final result = await markAllNotificationsReadUseCase.call(
        param: MarkAllReqParams(
          notificationIds: unreadNotificationIds, 
          isRead: 1        
        )
      );

      result.fold(
        (error) {
          // Tangani kesalahan jika gagal memperbarui di server
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              message: 'Gagal menandai semua notifikasi :(',
              icon: Icons.error_outline,  
              backgroundColor: Colors.red.shade800,  
            ),
          );
        },
        (_) {
          // Perbarui status lokal setelah berhasil di server
          setState(() {
            _notifications = _notifications.map((n) => n.copyWith(isRead: 1)).toList();
          });
        }
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Terjadi kesalahan',
          icon: Icons.error_outline,  
          backgroundColor: Colors.red.shade800,  
        ),
      );
    }
  }
}
