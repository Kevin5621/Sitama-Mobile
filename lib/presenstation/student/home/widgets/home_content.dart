import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/student_guidance_card.dart';
import 'package:sistem_magang/common/widgets/student_log_book_card.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/student_home_entity.dart';
import 'package:sistem_magang/presenstation/student/home/bloc/student_display_cubit.dart';
import 'package:sistem_magang/presenstation/student/home/bloc/student_display_state.dart';
import 'package:sistem_magang/presenstation/student/home/widgets/load_notification.dart';
import 'package:sistem_magang/presenstation/student/home/widgets/notification_badge.dart';
import 'package:sistem_magang/presenstation/student/home/widgets/notification_page.dart';

/// HomeContent is the main content widget for the student's home screen.
/// It displays recent guidance sessions, logbooks, and notifications in a scrollable layout.
/// Uses BLoC pattern for state management to handle student data loading and display.
class HomeContent extends StatelessWidget {
  /// Callback function to navigate to all guidances view
  final VoidCallback allGuidances;
  
  /// Callback function to navigate to all logbooks view
  final VoidCallback allLogBooks;

  const HomeContent({
    super.key, 
    required this.allGuidances, 
    required this.allLogBooks
  });

  @override
  Widget build(BuildContext context) {
    // Initialize and provide StudentDisplayCubit for state management
    return BlocProvider(
      create: (context) => StudentDisplayCubit()..displayStudent(),
      child: BlocBuilder<StudentDisplayCubit, StudentDisplayState>(
        builder: (context, state) {
          // Handle different states of student data loading
          if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is StudentLoaded) {
            return CustomScrollView(
              slivers: [
                _header(state.studentHomeEntity),
                // Section header for Recent Guidance
                _buildSectionHeader('Bimbingan Terbaru', allGuidances),
                _guidancesList(state.studentHomeEntity),
                // Section header for Recent Logbooks
                _buildSectionHeader('Log Book Terbaru', allLogBooks),
                _logBooksList(state.studentHomeEntity),
              ],
            );
          }
          if (state is LoadStudentFailure) {
            return Text(state.errorMessage);
          }
          return Container();
        },
      ),
    );
  }

  /// Builds a section header with title and forward arrow
  SliverToBoxAdapter _buildSectionHeader(String title, VoidCallback onTap) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: const Icon(Icons.arrow_forward_ios, size: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a scrollable list of recent guidance sessions
  /// Converts the guidance status string to corresponding enum value
  SliverList _guidancesList(StudentHomeEntity student) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => GuidanceCard(
          id: student.latest_guidances[index].id,
          title: student.latest_guidances[index].title,
          date: student.latest_guidances[index].date,
          // Map status string to GuidanceStatus enum
          status: _mapGuidanceStatus(student.latest_guidances[index].status),
          description: student.latest_guidances[index].activity,
          lecturerNote: student.latest_guidances[index].lecturer_note,
          nameFile: student.latest_guidances[index].name_file,
          curentPage: 0,
        ),
        childCount: student.latest_guidances.length,
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
  SliverToBoxAdapter _header(StudentHomeEntity student) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header container with background pattern
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
                // Student greeting section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'HELLO,',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      student.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Notification button with badge
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: NotificationBadge(
                    count: 3,
                    child: Builder(
                      builder: (BuildContext ctx) => IconButton(
                        icon: const Icon(Icons.notifications, color: AppColors.white),
                        onPressed: () => _navigateToNotifications(ctx),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Notification loading widget
          Container(
            color: Colors.white,
            child: LoadNotification(onClose: () {}),
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
            curentPage: 0,
          ),
        ),
        childCount: student.latest_log_books.length,
      ),
    );
  }
}