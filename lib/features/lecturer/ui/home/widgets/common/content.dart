// ignore_for_file: library_private_types_in_public_api

import 'package:sitama/features/lecturer/ui/home/bloc/helper/offline_mode_handler.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_bloc.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_event.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/selection/selection_state.dart';
import 'package:sitama/features/lecturer/ui/home/widgets/common/header.dart';
import 'package:sitama/features/lecturer/ui/home/widgets/section/student_list.dart';
import 'package:sitama/features/lecturer/ui/home/widgets/utils/dialogs/send_message_bottom.dart';
import 'package:sitama/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/core/config/assets/app_images.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/features/lecturer/domain/entities/lecturer_home_entity.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/display/lecturer_display_cubit.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/display/lecturer_display_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturerHomeContent extends StatefulWidget {
  const LecturerHomeContent({super.key});

  @override
  _LecturerHomeContentState createState() => _LecturerHomeContentState();
}

class _LecturerHomeContentState extends State<LecturerHomeContent>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String _search = '';
  late AnimationController _animationController;
  late Animation<double> _searchAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  Future<void> _refreshData(BuildContext context) async {
    // Trigger data refresh using LecturerDisplayCubit
    context.read<LecturerDisplayCubit>().displayLecturer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ConnectivityHandler(
      child: RepaintBoundary(
        child: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SelectionBloc()..add(LoadArchivedItems()),
              ),
              BlocProvider(
                create: (context) => LecturerDisplayCubit(
                  selectionBloc: context.read<SelectionBloc>(),
                  prefs: sl<SharedPreferences>(),
                )..displayLecturer(),
                lazy: false,
              ),
            ],
            child: BlocListener<SelectionBloc, SelectionState>(
              listenWhen: (previous, current) => 
                  previous.archivedIds != current.archivedIds,
              listener: (context, state) {
                context.read<LecturerDisplayCubit>().displayLecturer();
              },
              child: BlocBuilder<LecturerDisplayCubit, LecturerDisplayState>(
                builder: (context, state) {
                  if (state is LecturerLoading) {
                    return _buildLoadingState();
                  }
                  if (state is LecturerLoaded) {
                    return _buildLoadedState(state);
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightPrimary),
          ),
          SizedBox(height: 16),
          Text(
            'Loading data...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(LecturerLoaded state) {
    LecturerHomeEntity data = state.lecturerHomeEntity;
    Set<LecturerStudentsEntity> students = _filterStudents(data.students!.toSet());

    return BlocBuilder<SelectionBloc, SelectionState>( 
      builder: (context, selectionState) {
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => _refreshData(context),
              color: AppColors.lightPrimary,
              child: Column(
                children: [
                  if (state.isOffline)
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
                    child: _buildMainContent(data, students, selectionState),
                  ),
                ],
              ),
            ),
            if (selectionState.isSelectionMode && 
                selectionState.selectedIds.isNotEmpty)
              _buildFloatingActionButton(context, selectionState.selectedIds),
          ],
        );
      },
    );
  }

  Set<LecturerStudentsEntity> _filterStudents(Set<LecturerStudentsEntity> students) {
    return students.where((student) {
      return student.name.toLowerCase().contains(_search.toLowerCase()) ||
          student.major.toLowerCase().contains(_search.toLowerCase());
    }).toSet();
  }

  Widget _buildMainContent(
    LecturerHomeEntity data,
    Set<LecturerStudentsEntity> students,
    SelectionState selectionState,
  ) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(AppImages.homePattern),
                fit: BoxFit.cover,
              ),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Header(
              name: data.name,
              isSelectionMode: selectionState.isSelectionMode,
              searchAnimation: _searchAnimation,
              animationController: _animationController,
              onSearchChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: StudentList(
            students: students.toList(), 
            searchAnimation: _searchAnimation,
            animationController: _animationController,
            selectionState: selectionState,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, List<int> selectedIds) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: FloatingActionButton(
              onPressed: () => showSendMessageBottomSheet(context, selectedIds),
              backgroundColor: AppColors.lightPrimary,
              elevation: 6,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.message,
                color: AppColors.lightWhite,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }
}
