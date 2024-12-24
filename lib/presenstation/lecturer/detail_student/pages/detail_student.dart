import 'package:Sitama/core/config/themes/app_color.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/widgets/section/tab_guidance/lecturer_guidance_tab.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/widgets/section/tab_logbook/lecturer_log_book_tab.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/widgets/section/tab_logbook/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/bloc/detail_student_display_cubit.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/widgets/common/header.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/widgets/section/info_section.dart';
import 'package:Sitama/presenstation/lecturer/detail_student/widgets/utils/statistics.dart';

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

class DetailStudentPage extends StatefulWidget {
  final int id;

  const DetailStudentPage({super.key, required this.id});

  @override
  _DetailStudentPageState createState() => _DetailStudentPageState();
}

class _DetailStudentPageState extends State<DetailStudentPage> with SingleTickerProviderStateMixin {
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
    // Replace 600.0 with the actual offset where TabSection starts
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
        create: (context) => DetailStudentDisplayCubit()..displayStudent(widget.id),
        child: BlocBuilder<DetailStudentDisplayCubit, DetailStudentDisplayState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DetailLoaded) {
              final detailStudent = state.detailStudentEntity;
              return NestedScrollView(
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
              );
            }
            if (state is DetailFailure) {
              return ErrorView(
                errorMessage: state.errorMessage,
                onRetry: () {
                  context.read<DetailStudentDisplayCubit>().displayStudent(widget.id);
                },
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