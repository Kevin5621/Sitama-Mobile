import 'dart:async';
import 'package:sitama/common/widgets/error_content.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/common/widgets/student_guidance_card.dart';
import 'package:sitama/common/widgets/student_log_book_card.dart';
import 'package:sitama/core/config/assets/app_images.dart';
import 'package:sitama/data/models/notification.dart';
import 'package:sitama/domain/entities/student_home_entity.dart';
import 'package:sitama/presenstation/student/home/bloc/student_display_cubit.dart';
import 'package:sitama/presenstation/student/home/bloc/student_display_state.dart';
import 'package:sitama/presenstation/student/home/widgets/load_notification.dart';
import 'package:sitama/presenstation/student/home/widgets/notification_badge.dart';
import 'package:sitama/presenstation/student/home/widgets/notification_page.dart';

class HomeContent extends StatefulWidget {
  final VoidCallback allGuidances;
  final VoidCallback allLogBooks;

  const HomeContent({
    super.key,
    required this.allGuidances,
    required this.allLogBooks,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with AutomaticKeepAliveClientMixin {
  late final StudentDisplayCubit _studentCubit;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _wasError = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _studentCubit = StudentDisplayCubit()..displayStudent();
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool hasConnection = results.contains(ConnectivityResult.wifi) || 
                          results.contains(ConnectivityResult.mobile);
      if (_wasError && hasConnection) {
        _studentCubit.displayStudent();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _studentCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (context) => _studentCubit,
      child: BlocBuilder<StudentDisplayCubit, StudentDisplayState>(
        builder: (context, state) {
          // Update _wasError berdasarkan state
          if (state is LoadStudentFailure) {
            _wasError = true;
          } else if (state is StudentLoaded) {
            _wasError = false;
          }

          return RepaintBoundary(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildContent(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, StudentDisplayState state) {
    return switch (state) {
      StudentLoading() => const Center(child: CircularProgressIndicator()),
      StudentLoaded() => _buildLoadedContent(state),
      LoadStudentFailure() => ErrorContent(
          errorMessage: state.errorMessage,
          onRetry: () => _studentCubit.displayStudent(),
          wasError: _wasError,
        ),
      _ => Container(),
    };
  }

  Widget _buildLoadedContent(StudentLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        _studentCubit.displayStudent();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _header(context, state),
          _buildSectionHeader(context, 'Bimbingan Terbaru', widget.allGuidances),
          _guidancesList(state.studentHomeEntity),
          _buildSectionHeader(context, 'Log Book Terbaru', widget.allLogBooks),
          _logBooksList(state.studentHomeEntity),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  /// Builds a section header with title and forward arrow
  SliverToBoxAdapter _buildSectionHeader(BuildContext context, String title, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            InkWell(
              onTap: onTap,
              child: Icon(
                Icons.arrow_forward_ios, 
                size: 14,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a scrollable list of recent guidance sessions
  /// Converts the guidance status string to corresponding enum value
  SliverList _guidancesList(StudentHomeEntity student) {
    // Filter guidance list to show only rejected and updated ones
    final filteredGuidances = student.latest_guidances;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => GuidanceCard(
          id: filteredGuidances[index].id,
          title: filteredGuidances[index].title,
          date: filteredGuidances[index].date,
          status: _mapGuidanceStatus(filteredGuidances[index].status),
          description: filteredGuidances[index].activity,
          lecturerNote: filteredGuidances[index].lecturer_note,
          nameFile: filteredGuidances[index].name_file,
          curentPage: 0,
        ),
        childCount: filteredGuidances.length,
      ),
    );
  }

  /// Maps string status to GuidanceStatus enum
  GuidanceStatus _mapGuidanceStatus(String status) {
    switch (status) {
      case 'approved':
        return GuidanceStatus.approved;
      case 'in-progress':
        return GuidanceStatus.inProgress;
      case 'rejected':
        return GuidanceStatus.rejected;
      default:
        return GuidanceStatus.updated;
    }
  }

  /// Builds the header section containing:
  /// - Student greeting
  /// - Notification button with badge
  /// - Background pattern
  /// - Notification loading widget
  SliverToBoxAdapter _header(BuildContext context, StudentDisplayState state) {
    final colorScheme = Theme.of(context).colorScheme;
    
    NotificationItemEntity? latestNotification;
    if (state is StudentLoaded) {
      latestNotification = state.notifications?.getLatestGeneralNotification();
    }
    
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 160,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.homePattern),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'HELLO,',
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (state is StudentLoaded)
                      Text(
                        state.studentHomeEntity.name,
                        style: const TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: BlocBuilder<StudentDisplayCubit, StudentDisplayState>(
                    builder: (context, state) {
                      int unreadCount = 0;
                      
                      if (state is StudentLoaded && state.notifications != null) {
                        unreadCount = state.notifications!.getUnreadCount();
                      }

                      return NotificationBadge(
                        count: unreadCount,  
                        child: Builder(
                          builder: (BuildContext context) => IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: colorScheme.onPrimary,
                            ),
                            onPressed: () => _navigateToNotifications(context),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            color: colorScheme.surface,
            child: LoadNotification(
              onClose: () {},
              notification: latestNotification,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigation helper for notifications page
  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationPage(),
      ),
    );
  }

  /// Creates a scrollable list of recent logbook entries
  SliverList _logBooksList(StudentHomeEntity student) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => LogBookCard(
          item: LogBookItem(
            id: student.latest_log_books[index].id,
            title: student.latest_log_books[index].title,
            date: student.latest_log_books[index].date,
            description: student.latest_log_books[index].activity,
            lecturerNote: student.latest_log_books[index].lecturer_note,
            curentPage: 0,
          ),
        ),
        childCount: student.latest_log_books.length,
      ),
    );
  }
}
