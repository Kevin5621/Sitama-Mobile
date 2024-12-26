import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/core/shared/widgets/common/search_field.dart';
import 'package:sitama/features/student/domain/entities/guidance_entity.dart';
import 'package:sitama/features/student/ui/guidance/bloc/guidance_student_cubit.dart';
import 'package:sitama/features/student/ui/guidance/bloc/guidance_student_state.dart';
import 'package:sitama/features/student/ui/guidance/widgets/add_guidance.dart';
import 'package:sitama/features/student/ui/guidance/widgets/filter_dialog.dart';
import 'package:sitama/features/student/ui/guidance/widgets/student_guidance_card.dart';

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
      bool matchesSearch = guidance.title
          .toLowerCase()
          .contains(_search.toLowerCase());

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
    
    var blocProvider = BlocProvider(
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
                  SliverAppBar(
                    floating: false,
                    snap: false,
                    pinned: true,
                    backgroundColor: theme.colorScheme.surface,
                    elevation: 0,
                    title: Text(
                      'Bimbingan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface, 
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const AddGuidance(),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: theme.colorScheme.onSurface, 
                        ),
                      )
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(80),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  ),
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
      );
    return Scaffold(
      body: blocProvider,
    );
  }
}