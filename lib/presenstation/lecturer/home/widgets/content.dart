import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/lecturer_display_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/lecturer_display_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/header.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/send_message_bottom.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/student_list.dart';

class LecturerHomeContent extends StatefulWidget {
  const LecturerHomeContent({super.key});

  @override
  _LecturerHomeContentState createState() => _LecturerHomeContentState();
}

class _LecturerHomeContentState extends State<LecturerHomeContent>
    with SingleTickerProviderStateMixin {
  String _search = '';
  late AnimationController _animationController;
  late Animation<double> _searchAnimation;

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
    _searchAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LecturerDisplayCubit()..displayLecturer()),
          BlocProvider(create: (context) => SelectionBloc()),
        ],
        child: BlocBuilder<LecturerDisplayCubit, LecturerDisplayState>(
          builder: (context, state) {
            if (state is LecturerLoading) {
              return _buildLoadingState();
            }
            if (state is LecturerLoaded) {
              return _buildLoadedState(state);
            }
            if (state is LoadLecturerFailure) {
              return _buildErrorState(context, state);
            }
            return Container();
          },
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
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
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
    List<LecturerStudentsEntity> students = _filterStudents(data.students!);

    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, selectionState) {
        return Stack(
          children: [
            _buildMainContent(data, students, selectionState),
            if (selectionState.isSelectionMode && selectionState.selectedIds.isNotEmpty)
              _buildFloatingActionButton(context),
          ],
        );
      },
    );
  }

  List<LecturerStudentsEntity> _filterStudents(List<LecturerStudentsEntity> students) {
    return students.where((student) {
      return student.name.toLowerCase().contains(_search.toLowerCase()) ||
          student.major.toLowerCase().contains(_search.toLowerCase());
    }).toList();
  }

  Widget _buildMainContent(
    LecturerHomeEntity data,
    List<LecturerStudentsEntity> students,
    SelectionState selectionState,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(AppImages.homePattern),
                fit: BoxFit.cover,
              ),
              color: AppColors.primary,
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
            students: students,
            searchAnimation: _searchAnimation,
            animationController: _animationController,
            selectionState: selectionState,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
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
              onPressed: () => showSendMessageBottomSheet(context),
              backgroundColor: AppColors.primary,
              elevation: 6,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                color: AppColors.white,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, LoadLecturerFailure state) {
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
            state.errorMessage,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<LecturerDisplayCubit>().displayLecturer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}