import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/features/lecturer/domain/entities/lecturer_detail_student.dart';
import 'package:sitama/features/lecturer/ui/detail_student/bloc/detail_student_display_cubit.dart';
import 'package:sitama/features/lecturer/ui/detail_student/bloc/detail_student_display_state.dart';
import 'package:sitama/features/lecturer/ui/detail_student/widgets/common/header.dart';
import 'package:sitama/features/lecturer/ui/detail_student/widgets/section/info_section.dart';
import 'package:sitama/features/lecturer/ui/detail_student/widgets/section/tab_guidance/lecturer_guidance_tab.dart';
import 'package:sitama/features/lecturer/ui/detail_student/widgets/section/tab_logbook/lecturer_log_book_tab.dart';
import 'package:sitama/features/lecturer/ui/detail_student/widgets/section/tab_logbook/notification_manager.dart';
import 'package:sitama/features/lecturer/ui/detail_student/widgets/utils/statistics.dart';
import 'package:sitama/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Key Features :
// Captures student and industry internship details
// Manages internship status approval

// Performance Evaluation:
// Restricts evaluation access
// Enables metrics view after internship completion

// Guidance and Supervision:
// Faculty actions:
// - Approve progress
// - Request revisions
// - Add notes
// - Export PDF guidance

// Logbook Tracking:
// Faculty capabilities:
// - View student activity logs
// - Comment on log entries
import 'package:shared_preferences/shared_preferences.dart';

class DetailStudentPage extends StatefulWidget {
  final int id;

  const DetailStudentPage({super.key, required this.id});

  @override
  _DetailStudentPageState createState() => _DetailStudentPageState();
}

class _DetailStudentPageState extends State<DetailStudentPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  bool _isButtonVisible = true;
  final GlobalKey _tabSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= 600.0 && _isButtonVisible) {
      setState(() {
        _isButtonVisible = false;
      });
    } else if (_scrollController.position.pixels < 600.0 && !_isButtonVisible) {
      setState(() {
        _isButtonVisible = true;
      });
    }
  }

  void _scrollToTabSection() {
    final RenderBox renderBox =
        _tabSectionKey.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _scrollController.animateTo(
      position.dy,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => DetailStudentDisplayCubit(
          prefs: sl<SharedPreferences>(),
        )..displayStudent(widget.id),
        child: BlocBuilder<DetailStudentDisplayCubit, DetailStudentDisplayState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            // Handle failure state with cached data
            if (state is DetailFailure) {
              if (state.isOffline && state.cachedData != null) {
                return _buildMainContent(
                  context,
                  state.cachedData!,
                  isOffline: true,
                );
              }
              return ErrorView(
                errorMessage: state.errorMessage,
                onRetry: () {
                  context.read<DetailStudentDisplayCubit>().displayStudent(widget.id);
                },
              );
            }

            // Handle loaded state
            if (state is DetailLoaded) {
              return _buildMainContent(
                context,
                state.detailStudentEntity,
                isOffline: state.isOffline,
              );
            }

            return Container();
          },
        ),
      ),
      floatingActionButton: _isButtonVisible
          ? FloatingActionButton(
              onPressed: _scrollToTabSection,
              child: const Icon(Icons.arrow_downward),
            )
          : null,
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    DetailStudentEntity detailStudent, {
    bool isOffline = false,
  }) {
    return Column(
      children: [
        if (isOffline)
          Container(
            width: double.infinity,
            color: AppColors.lightGray,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Menggunakan data tersimpan Anda sedang offline',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        Expanded(
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ProfileHeader(detailStudent: detailStudent),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      StatisticsSection(
                        guidanceLength: detailStudent.guidances.length,
                        logBookLength: detailStudent.log_book.length,
                      ),
                      InfoBoxes(
                        internships: detailStudent.internships,
                        students: detailStudent,
                        id: widget.id,
                      ),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Bimbingan'),
                        Tab(text: 'Log Book'),
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
                ),
              ];
            },
            body: Container(
              key: _tabSectionKey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  LecturerGuidanceTab(
                    guidances: detailStudent.guidances,
                    student_id: widget.id,
                  ),
                  LecturerLogBookTab(
                    logBooks: detailStudent.log_book,
                    student_id: widget.id,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}