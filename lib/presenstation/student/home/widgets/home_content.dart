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
import 'package:sistem_magang/presenstation/student/home/widgets/notification.dart';

class HomeContent extends StatelessWidget {
  final VoidCallback allGuidances;
  final VoidCallback allLogBooks;

  const HomeContent({
    super.key, 
    required this.allGuidances, 
    required this.allLogBooks
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentDisplayCubit()..displayStudent(),
      child: BlocBuilder<StudentDisplayCubit, StudentDisplayState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is StudentLoaded) {
            return CustomScrollView(
              slivers: [
                _header(state.studentHomeEntity),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Bimbingan Terbaru',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: allGuidances,
                          child: const Icon(Icons.arrow_forward_ios, size: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                _guidancesList(state.studentHomeEntity),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Log Book Terbaru',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: allLogBooks,
                          child: const Icon(Icons.arrow_forward_ios, size: 14),
                        ),
                      ],
                    ),
                  ),
                ),
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

  SliverList _guidancesList(StudentHomeEntity student) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => GuidanceCard(
          id: student.latest_guidances[index].id,
          title: student.latest_guidances[index].title,
          date: student.latest_guidances[index].date,
          status: student.latest_guidances[index].status == 'approved'
              ? GuidanceStatus.approved
              : student.latest_guidances[index].status == 'in-progress'
                  ? GuidanceStatus.inProgress
                  : student.latest_guidances[index].status == 'rejected'
                      ? GuidanceStatus.rejected
                      : GuidanceStatus.updated,
          description: student.latest_guidances[index].activity,
          lecturerNote: student.latest_guidances[index].lecturer_note,
          nameFile: student.latest_guidances[index].name_file,
          curentPage: 0,
        ),
        childCount: student.latest_guidances.length,
      ),
    );
  }

  SliverToBoxAdapter _header(StudentHomeEntity student) {
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
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
                        onPressed: () {
                          Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            color: Colors.white,
            child: LoadNotification(
              onClose: () {},
            ),
          ),
        ],
      ),
    );
  }

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
