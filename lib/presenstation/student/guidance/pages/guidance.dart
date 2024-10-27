import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/student_guidance_card.dart';
import 'package:sistem_magang/common/widgets/search_field.dart';
import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/presenstation/student/guidance/bloc/guidance_student_cubit.dart';
import 'package:sistem_magang/presenstation/student/guidance/bloc/guidance_student_state.dart';
import 'package:sistem_magang/presenstation/student/guidance/widgets/add_guidance.dart';

class GuidancePage extends StatefulWidget {
  const GuidancePage({super.key});

  @override
  State<GuidancePage> createState() => _GuidancePageState();
}

class _GuidancePageState extends State<GuidancePage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: BlocProvider(
        create: (context) => GuidanceStudentCubit()..displayGuidance(),
        child: BlocBuilder<GuidanceStudentCubit, GuidanceStudentState>(
          builder: (context, state) {
            if (state is GuidanceLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is GuidanceLoaded) {
              List<GuidanceEntity> guidances =
                  state.guidanceEntity.guidances.where((guidance) {
                var search = guidance.title
                    .toLowerCase()
                    .contains(_search.toLowerCase());
                return search;
              }).toList();

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 12)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: SearchField(
                              onChanged: (value) {
                                setState(() {
                                  _search = value;
                                });
                              },
                              onFilterPressed: () {},
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.filter_list_outlined),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => GuidanceCard(
                        id: guidances[index].id,
                        title: guidances[index].title,
                        date: DateTime(2024, 1, 28 - index),
                        status: guidances[index].status == 'approved'
                            ? GuidanceStatus.approved
                            : guidances[index].status == 'in-progress'
                                ? GuidanceStatus.inProgress
                                : guidances[index].status == 'rejected'
                                    ? GuidanceStatus.rejected
                                    : GuidanceStatus.updated,
                        description: guidances[index].activity,
                        lecturerNote: guidances[index].lecturer_note,
                        nameFile: guidances[index].name_file,
                        curentPage: 1,
                      ),
                      childCount: guidances.length,
                    ),
                  ),
                ],
              );
            }
            if (state is LoadGuidanceFailure) {
              return Text(state.errorMessage);
            }
            return Container();
          },
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 80.0,
      title: Text(
        'Bimbingan',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AddGuidance();
              },
            );
          },
          icon: Icon(Icons.add),
        )
      ],
      backgroundColor: Colors.transparent,
    );
  }
}
