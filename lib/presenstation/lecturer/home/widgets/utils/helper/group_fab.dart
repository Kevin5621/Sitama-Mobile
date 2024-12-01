import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/utils/dialogs/send_message_bottom.dart';

class GroupFAB extends StatelessWidget {
  const GroupFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        if (!state.isSelectionMode || state.selectedIds.isEmpty) {
          return const SizedBox.shrink();
        }

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: FloatingActionButton(
                onPressed: () => showSendMessageBottomSheet(
                  context,
                  state.selectedIds,
                ),
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
        );
      },
    );
  }
}