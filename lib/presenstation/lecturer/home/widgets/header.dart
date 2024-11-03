import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/search_field.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';

class Header extends StatelessWidget {
  final String name;
  final bool isSelectionMode;
  final Animation<double> searchAnimation;
  final AnimationController animationController;
  final Function(String) onSearchChanged;

  const Header({
    super.key,
    required this.name,
    required this.isSelectionMode,
    required this.searchAnimation,
    required this.animationController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNormalHeader(),
          const SizedBox(height: 26),
          if (isSelectionMode)
            _buildSelectionModeHeader(context)
          else
            _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildSelectionModeHeader(BuildContext context) {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.lightWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBlack.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Select Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.lightGray,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.lightBlack),
            onPressed: () {
              context.read<SelectionBloc>().add(ToggleSelectionMode());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNormalHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HELLO,',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return FadeTransition(
      opacity: searchAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(animationController),
        child: SearchField(
          onChanged: onSearchChanged,
          onFilterPressed: () {},
        ),
      ),
    );
  }
}
