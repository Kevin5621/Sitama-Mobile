import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/content.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/header.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/info_section.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/statistics.dart';

class DetailStudentPage extends StatelessWidget {
  final int id;
  const DetailStudentPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => DetailStudentDisplayCubit()..displayStudent(id),
        child:
            BlocBuilder<DetailStudentDisplayCubit, DetailStudentDisplayState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is DetailLoaded) {
              DetailStudentEntity detailStudent = state.detailStudentEntity;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250,
                    pinned: true,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ProfileHeader(detailStudent: detailStudent),
                    ),
                    actions: [
                      ActionButtons(state: state),
                    ],
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
                          InfoBoxes(internships: detailStudent.internships),
                          TabSection(
                            guidances: detailStudent.guidances,
                            logBooks: detailStudent.log_book,
                            studentId: id,
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
                  context.read<DetailStudentDisplayCubit>().displayStudent(id);
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
