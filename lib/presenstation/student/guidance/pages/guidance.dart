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
import 'package:sistem_magang/presenstation/student/guidance/widgets/filter_dialog.dart';

class GuidancePage extends StatefulWidget {
  const GuidancePage({super.key});

  @override
  State<GuidancePage> createState() => _GuidancePageState();
}

class _GuidancePageState extends State<GuidancePage> with AutomaticKeepAliveClientMixin {
  String _search = '';
  String _selectedFilter = 'All';

  @override
  bool get wantKeepAlive => true;  

  List<GuidanceEntity> _filterGuidances(List<GuidanceEntity> guidances) {
    return guidances.where((guidance) {
      // First apply search filter
      bool matchesSearch = guidance.title
          .toLowerCase()
          .contains(_search.toLowerCase());

      // Then apply status filter
      bool matchesStatus = _selectedFilter == 'All' ||
          (_selectedFilter == 'Approved' && guidance.status == 'approved') ||
          (_selectedFilter == 'InProgress' && guidance.status == 'in-progress') ||
          (_selectedFilter == 'Rejected' && guidance.status == 'rejected') ||
          (_selectedFilter == 'Updated' && guidance.status == 'updated');

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: _appBar(theme),
      body: BlocProvider(
        create: (context) => GuidanceStudentCubit()..displayGuidance(),
        child: BlocBuilder<GuidanceStudentCubit, GuidanceStudentState>(
          builder: (context, state) {
            if (state is GuidanceLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GuidanceLoaded) {
              List<GuidanceEntity> filteredGuidances = 
                _filterGuidances(state.guidanceEntity.guidances);

              return CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
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
                          const SizedBox(width: 10),
                          FilterDropdown(
                            onFilterChanged: (String selectedFilter) {
                              setState(() {
                                _selectedFilter = selectedFilter;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => GuidanceCard(
                        id: filteredGuidances[index].id,
                        title: filteredGuidances[index].title,
                        date: DateTime(2024, 1, 28 - index),
                        status: filteredGuidances[index].status == 'approved'
                            ? GuidanceStatus.approved
                            : filteredGuidances[index].status == 'in-progress'
                                ? GuidanceStatus.inProgress
                                : filteredGuidances[index].status == 'rejected'
                                    ? GuidanceStatus.rejected
                                    : GuidanceStatus.updated,
                        description: filteredGuidances[index].activity,
                        lecturerNote: filteredGuidances[index].lecturer_note,
                        nameFile: filteredGuidances[index].name_file,
                        curentPage: 1,
                      ),
                      childCount: filteredGuidances.length,
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

  AppBar _appBar(ThemeData theme) {
    return AppBar(
      toolbarHeight: 80.0,
      title: Text(
        'Bimbingan',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onBackground, // Mengatur warna teks sesuai theme
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
                return const AddGuidance();
              },
            );
          },
          icon: Icon(
            Icons.add,
            color: theme.colorScheme.onBackground, 
          ),
        )
      ],
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: theme.colorScheme.onBackground, 
      ),
    );
  }
}