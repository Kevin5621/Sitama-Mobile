import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/search_field.dart';
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
          if (isSelectionMode)
            _buildSelectionModeHeader(context)
          else
            _buildNormalHeader(),
          const SizedBox(height: 26),
          if (!isSelectionMode)
            _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildSelectionModeHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Select Items',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            context.read<SelectionBloc>().add(ToggleSelectionMode());
          },
        ),
      ],
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
