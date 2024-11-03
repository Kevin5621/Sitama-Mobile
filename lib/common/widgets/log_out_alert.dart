import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/basic_app_button.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/usecases/log_out.dart';
import 'package:sistem_magang/presenstation/general/welcome/pages/welcome.dart';
import 'package:sistem_magang/service_locator.dart';

class LogOutAlert extends StatelessWidget {
  const LogOutAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomePages()),
              (route) => false,
            );
          }
          if (state is ButtonFailurState) {
            print(state.errorMessage);
          }
        },
        child: Builder(
          builder: (context) => AlertDialog(
            content: const Text(
              'Apakah anda yakin ingin meninggalkan akun ini ?',
            ),
            actions: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.lightPrimary),
                  ),
                  child: const Text(
                    'Cancel',
                  ),
                ),
              ),
              BasicAppButton(
                onPressed: () {
                  final buttonCubit =
                      BlocProvider.of<ButtonStateCubit>(context);
                  buttonCubit.excute(usecase: sl<LogoutUseCase>());
                },
                title: 'Log Out',
                height: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
