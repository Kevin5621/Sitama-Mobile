import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/core/shared/widgets/alert/alert.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state_cubit.dart';
import 'package:sitama/features/auth/domain/usecases/log_out.dart';
import 'package:sitama/features/auth/ui/pages/welcome.dart';
import 'package:sitama/service_locator.dart';

class LogOutAlert extends StatelessWidget {
  const LogOutAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: BlocConsumer<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => WelcomePages()),
              (route) => false,
            );
          }
          if (state is ButtonFailurState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) => CustomAlertDialog(
          title: 'Konfirmasi Logout',
          message: 'Apakah Anda yakin ingin keluar dari akun ini?',
          cancelText: 'Batal',
          confirmText: 'Keluar',
          confirmColor: AppColors.lightPrimary, 
          icon: Icons.logout_outlined, 
          iconColor: AppColors.lightPrimary,
          onCancel: () {
            Navigator.of(context).pop();
          },
          onConfirm: () {
            context.read<ButtonStateCubit>().excute(usecase: sl<LogoutUseCase>());
          },
        ),
      ),
    );
  }
}