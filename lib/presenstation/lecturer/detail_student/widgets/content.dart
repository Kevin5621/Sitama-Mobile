import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/lecturer_guidance_tab.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/lecturer_log_book_tab.dart';

class ActionButtons extends StatelessWidget {
  final DetailLoaded state;

  const ActionButtons({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              state.isChecked ? Icons.check_circle : Icons.check_circle_outline,
              color: state.isChecked ? Colors.green : Colors.white,
              weight: 12,
            ),
            onPressed: () {
              context.read<DetailStudentDisplayCubit>().toggleCheck();
            },
          ),
        ],
      ),
    );
  }
}

class TabSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Bimbingan'),
              Tab(text: 'Log Book'),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.gray,
            indicatorColor: AppColors.primary,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: TabBarView(
              children: [
                LecturerGuidanceTab(
                  guidances: guidances,
                  student_id: studentId,
                ),
                LecturerLogBookTab(
                  logBooks: logBooks,
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