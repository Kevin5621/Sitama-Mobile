import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/content.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/header.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/info_section.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/statistics.dart';

class DetailStudentPage extends StatefulWidget {
  final int id;

  const DetailStudentPage({super.key, required this.id});

  @override
  _DetailStudentPageState createState() => _DetailStudentPageState();
}

class _DetailStudentPageState extends State<DetailStudentPage> {
  late ScrollController _scrollController;
  bool _isButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
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
    _scrollController.animateTo(
      _scrollController
          .position.maxScrollExtent, // Adjust this offset as needed.
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            DetailStudentDisplayCubit()..displayStudent(widget.id),
        child:
            BlocBuilder<DetailStudentDisplayCubit, DetailStudentDisplayState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is DetailLoaded) {
              final detailStudent = state.detailStudentEntity;
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250,
                    pinned: true,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ProfileHeader(detailStudent: detailStudent),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
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
                          TabSection(
                            guidances: detailStudent.guidances,
                            logBooks: detailStudent.log_book,
                            studentId: widget.id,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            if (state is DetailFailure) {
              return ErrorView(
                errorMessage: state.errorMessage,
                onRetry: () {
                  context
                      .read<DetailStudentDisplayCubit>()
                      .displayStudent(widget.id);
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
              tooltip: 'Scroll to Tab Section',
              child: const Icon(Icons.arrow_downward),
            )
          : null,
    );
  }
}
