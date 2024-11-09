import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/lecturer_guidance_tab.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/lecturer_log_book_tab.dart';

class TabSection extends StatefulWidget {
  final List<GuidanceEntity> guidances;
  final List<LogBookEntity> logBooks;
  final int studentId;

  const TabSection({
    Key? key,
    required this.guidances,
    required this.logBooks,
    required this.studentId,
  }) : super(key: key);

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasUnreadLogBooks = false;
  final String _lastReadKey = 'last_read_logbook_time';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkUnreadLogBooks();

    // Listen to tab changes
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

    // Mendapatkan waktu terakhir kali tab LogBook dibuka
    final prefs = await SharedPreferences.getInstance();
    final lastReadTime = prefs.getString(_lastReadKey);

    if (lastReadTime == null) {
      setState(() => _hasUnreadLogBooks = true);
      return;
    }

    // Mengecek apakah ada LogBook yang lebih baru dari waktu terakhir dibaca
    final lastRead = DateTime.parse(lastReadTime);
    final hasNewLogBooks = widget.logBooks.any((logBook) {
      return logBook.date.isAfter(lastRead);
    });

    setState(() => _hasUnreadLogBooks = hasNewLogBooks);
  }

  Future<void> _updateLastReadTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastReadKey, DateTime.now().toIso8601String());
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
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