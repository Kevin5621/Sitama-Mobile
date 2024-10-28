import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/domain/entities/student_home_entity.dart';
import 'package:sistem_magang/domain/usecases/update_scores.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/bloc/detail_student_display_state.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/lecturer_guidance_tab.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/lecturer_log_book_tab.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/pages/input_score.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/widgets/checklist.dart'; // Ganti dengan path yang sesuai

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
            if (state is LecturerLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is LecturerLoaded) {
              DetailStudentEntity detailStudent = state.detailStudentEntity;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/home_pattern.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    'https://randomuser.me/api/portraits/men/1.jpg'),
                              ),
                              SizedBox(height: 8),
                              Text(
                                detailStudent.student.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                detailStudent.student.username,
                                style: TextStyle(color: AppColors.black),
                              ),
                              Text(
                                detailStudent.student.email,
                                style: TextStyle(color: AppColors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 16.0), // Jarak dari sisi kanan
                        child: CheckButton(
                          isChecked: state.isChecked,
                          isStarRounded: state
                              .isStarRounded, // Ambil status bintang dari state
                          onToggle: () {
                            context
                                .read<DetailStudentDisplayCubit>()
                                .toggleCheck(); // Panggil fungsi toggle untuk checkbox
                          },
                          onStarToggle: () {
                            context
                                .read<DetailStudentDisplayCubit>()
                                .toggleStar(); // Panggil fungsi toggle untuk bintang
                          },
                        ),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildInfoBoxes(context, detailStudent.internships),
                        _buildTabSection(
                          context,
                          detailStudent.guidances,
                          detailStudent.log_book,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            if (state is LoadLecturerFailure) {
              return Center(child: Text(state.errorMessage));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildInfoBoxes(
      BuildContext context, List<InternshipStudentEntity> internships) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 5),
            itemBuilder: (context, index) {
              return _buildInternshipBox(
                'Industri',
                [
                  'Industri ${index + 1}',
                  'Nama: ${internships[index].name}',
                  'Tanggal Mulai: ${DateFormat('yyyy-MM-dd').format(internships[index].start_date)}',
                  'Tanggal Selesai: ${internships[index].end_date != null ? DateFormat('yyyy-MM-dd').format(internships[index].end_date!) : "-"}',
                ],
              );
            },
            shrinkWrap: true,
            itemCount: internships.length,
          ),
          const SizedBox(height: 16),
          _buildInfoBox(
            'Nilai',
            [
              'Proposal: -',
              'Laporan: -',
              'Nilai Industri: -',
              'Rata - rata: -',
            ],
            showAddButton: true,
            context: context, // Pass context here
          ),
        ],
      ),
    );
  }

  Widget _buildInternshipBox(String title, List<String> content,
      {bool showAddButton = false, BuildContext? context}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...content.map((item) => Text(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String title, List<String> content,
      {bool showAddButton = false, BuildContext? context}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (showAddButton && context != null)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InputScorePage(
                          updateScoresUseCase: GetIt.I<UpdateScoresUseCase>(),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          ...content.map((item) => Text(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildTabSection(BuildContext context, List<GuidanceEntity> guidances, List<LogBookEntity> logBooks) {
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
                LecturerGuidanceTab(guidances: guidances, student_id: id,),
                LecturerLogBookTab(logBooks: logBooks,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
