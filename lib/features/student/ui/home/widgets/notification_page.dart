import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sitama/core/shared/widgets/alert/custom_snackbar.dart';
import 'package:sitama/features/student/data/models/notification.dart';
import 'package:sitama/features/student/domain/entities/notification_entity.dart';
import 'package:sitama/features/student/domain/usecases/notification/get_notification.dart';
import 'package:sitama/features/student/domain/usecases/notification/mark_all_notifications.dart';
import 'package:sitama/features/student/ui/home/widgets/notification_card.dart';
import 'package:sitama/service_locator.dart';

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
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  @override
  void dispose() {
    // Cancel any ongoing operation if necessary
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _getNotificationsUseCase.call();

      result.fold(
        (error) {
          setState(() {
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
        key: _scaffoldKey,
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surfaceContainer,
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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () async {
            final result = await markAllNotificationsReadUseCase.call();

            result.fold((error) {
              // Tangani kesalahan jika gagal memperbarui di server
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  message: 'Gagal menandai semua notifikasi :(',
                  icon: Icons.error_outline,
                  backgroundColor: Colors.red.shade800,
                ),
              );
            }, (_) {
              // Perbarui status lokal setelah berhasil di server
              Navigator.pop(context);
            });
            
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
            IconButton(
              icon: Icon(Icons.done_all, color: colorScheme.onSurface),
              onPressed: _markAllNotificationsAsRead,
              tooltip: 'Tandai Semua Dibaca',
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
                      // Automatically mark as read when expanded
                      _markNotificationAsRead(notification.id);
                    },
                  );
                },
              ),
      ),
    );
  }

  Future<void> _markNotificationAsRead(int notificationId) async {
    try {
      // Panggil use case atau logika untuk menandai notifikasi sebagai dibaca
      final result = await markAllNotificationsReadUseCase.call(
        param: MarkAllReqParams(
          notificationIds: [notificationId],
          isRead: 1,
        ),
      );

      if (!mounted) return;

      result.fold(
        (error) {
          // Tangani kesalahan jika gagal memperbarui di server
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              message: 'Gagal menandai notifikasi sebagai dibaca :(',
              icon: Icons.error_outline,
              backgroundColor: Colors.red.shade800,
            ),
          );
        },
        (_) {
          // Perbarui status lokal setelah berhasil di server
          setState(() {
            _notifications = _notifications.map((n) {
              return n.id == notificationId ? n.copyWith(isRead: 1) : n;
            }).toList();
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Terjadi kesalahan',
          icon: Icons.error_outline,
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  Future<void> _markAllNotificationsAsRead() async {
    try {
      // Panggil use case untuk menandai notifikasi sebagai dibaca di server
      final result = await markAllNotificationsReadUseCase.call();

      if (!mounted) return;  // Periksa mounted setelah operasi async

      result.fold((error) {
        // Tangani kesalahan jika gagal memperbarui di server
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'Gagal menandai semua notifikasi :(',
            icon: Icons.error_outline,
            backgroundColor: Colors.red.shade800,
          ),
        );
      }, (_) {
        // Perbarui status lokal setelah berhasil di server
        setState(() {
          _notifications = _notifications.map((n) => n.copyWith(isRead: 1)).toList();
        });
      });
    } catch (e) {
      if (!mounted) return;
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
