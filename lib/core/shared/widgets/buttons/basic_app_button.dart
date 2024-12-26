import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state_cubit.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool height;

  const BasicAppButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.height = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
        builder: (context, state) {
      if (state is ButtonLoadingState) {
        return _loading();
      }
      return _initialButton();
    });
  }

  Widget _loading() {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(55),
        ),
        minimumSize: height ? const Size.fromHeight(65) : null,
      ),
      child: const CircularProgressIndicator(),
    );
  }

  Widget _initialButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(55),
        ),
        minimumSize: height ? const Size.fromHeight(65) : null,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.lightWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
