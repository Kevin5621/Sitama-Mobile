import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/student_guidance_card.dart';
import 'package:sistem_magang/common/widgets/student_log_book_card.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/student_home_entity.dart';
import 'package:sistem_magang/presenstation/student/guidance/pages/guidance.dart';
import 'package:sistem_magang/presenstation/student/home/bloc/student_display_cubit.dart';
import 'package:sistem_magang/presenstation/student/home/bloc/student_display_state.dart';
import 'package:sistem_magang/presenstation/student/home/widgets/notification.dart';
import 'package:sistem_magang/presenstation/student/logbook/pages/logbook.dart';
import 'package:sistem_magang/presenstation/student/profile/pages/profile.dart';

class HomePage extends StatefulWidget {
  final int currentIndex;

  const HomePage({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const GuidancePage(),
      const LogBookPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body:
          _currentIndex == 0 ? _buildHomeContent() : _pages[_currentIndex - 1],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Bimbingan'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Log book'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return _HomeContent(
      allGuidances: () {
        setState(() {
          _currentIndex = 1; // Navigate to the 'Guidance' page
        });
      },
      allLogBooks: () {
        setState(() {
          _currentIndex = 2; // Navigate to the 'Logbook' page
        });
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  final VoidCallback allGuidances;
  final VoidCallback allLogBooks;

  const _HomeContent(
      {super.key, required this.allGuidances, required this.allLogBooks});
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 28),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 28),
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
                    child: Builder(  // Tambahkan Builder untuk mendapatkan context yang benar
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

class NotificationWidget extends StatelessWidget {
  final VoidCallback onClose;

  const NotificationWidget({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info,
              color: AppColors.white,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Anda belum dijadwalkan seminar',
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: AppColors.white,
              ),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
class LoadNotification extends StatelessWidget {
  final VoidCallback onClose;

  const LoadNotification({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      color: AppColors.warning,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: const ExpansionTile(
          leading: Icon(Icons.info_rounded, color: AppColors.white,),
          title: Text("Informasi Baru !", style: TextStyle(color: AppColors.white),),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: AppColors.white,),
                  Text("21/11/2024", style: TextStyle(color: AppColors.gray)), 
                  Text("Anda telah dijadwalkan bimbingan 3 yang dilaksanakan pada Kamis, 17 Oktober 2024.", textAlign: TextAlign.left, style: TextStyle(color: AppColors.white)),                   SizedBox(height: 10),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
