import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/section/tab_guidance/lecturer_guidance_tab.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/section/tab_logbook/lecturer_log_book_tab.dart';

class TabSection extends StatefulWidget {
  final List<GuidanceEntity> guidances;
  final List<LogBookEntity> logBooks;
  final int studentId;

  const TabSection({
    super.key,
    required this.guidances,
    required this.logBooks,
    required this.studentId,
  });

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasUnreadLogBooks = false;
  
  // Helper class untuk mengelola notifikasi
  late final NotificationManager _notificationManager;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _notificationManager = NotificationManager();
    _checkUnreadLogBooks();

    _tabController.addListener(() {
      if (_tabController.index == 1 && _hasUnreadLogBooks) {
        setState(() {
          _hasUnreadLogBooks = false;
        });
        _updateLastReadTime();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkUnreadLogBooks() async {
    if (widget.logBooks.isEmpty) return;

    final hasUnread = await _notificationManager.hasUnreadLogBooks(
      studentId: widget.studentId,
      logBooks: widget.logBooks,
    );

    setState(() => _hasUnreadLogBooks = hasUnread);
  }

  Future<void> _updateLastReadTime() async {
    await _notificationManager.markLogBooksAsRead(
      studentId: widget.studentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              tabs: [
                const Tab(text: 'Bimbingan'),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Log Book'),
                      if (_hasUnreadLogBooks) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.lightWarning,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              labelColor: AppColors.lightPrimary,
              unselectedLabelColor: AppColors.lightGray,
              indicatorColor: AppColors.lightPrimary,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: TabBarView(
              controller: _tabController,
              children: [
                LecturerGuidanceTab(
                  guidances: widget.guidances,
                  student_id: widget.studentId,
                ),
                LecturerLogBookTab(
                  logBooks: widget.logBooks,
                  student_id: widget.studentId,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Kelas terpisah untuk mengelola notifikasi
class NotificationManager {
  static const String _keyPrefix = 'logbook_last_read';
  
  // Mendapatkan key yang unik untuk setiap mahasiswa
  String _getKey(int studentId) => '${_keyPrefix}_$studentId';

  // Mengecek apakah ada logbook yang belum dibaca
  Future<bool> hasUnreadLogBooks({
    required int studentId,
    required List<LogBookEntity> logBooks,
  }) async {
    if (logBooks.isEmpty) return false;

    final prefs = await SharedPreferences.getInstance();
    final key = _getKey(studentId);
    final lastReadTime = prefs.getString(key);

    if (lastReadTime == null) return true;

    final lastRead = DateTime.parse(lastReadTime);
    return logBooks.any((logBook) => logBook.date.isAfter(lastRead));
  }

  // Menandai semua logbook sebagai sudah dibaca
  Future<void> markLogBooksAsRead({
    required int studentId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getKey(studentId);
    await prefs.setString(key, DateTime.now().toIso8601String());
  }

  // Method untuk membersihkan data (optional, bisa digunakan untuk testing atau logout)
  Future<void> clearAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_keyPrefix)) {
        await prefs.remove(key);
      }
    }
  }
}

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorView({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}