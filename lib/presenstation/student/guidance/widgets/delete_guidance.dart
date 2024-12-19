import 'package:Sitama/common/widgets/basic_app_button.dart';
import 'package:Sitama/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/common/bloc/button/button_state.dart';
import 'package:Sitama/presenstation/student/guidance/bloc/guidance_student_cubit.dart';
import 'package:Sitama/common/bloc/button/button_state_cubit.dart';
import 'package:Sitama/common/widgets/alert.dart';
import 'package:Sitama/core/config/themes/app_color.dart';
import 'package:Sitama/domain/usecases/student/guidances/delete_guidance_student.dart';
import 'package:Sitama/presenstation/student/home/pages/home.dart';
import 'package:Sitama/service_locator.dart';

class DeleteGuidance extends StatefulWidget {
  final int id;
  final String title;
  final int curentPage;

  const DeleteGuidance({
    super.key,
    required this.id,
    required this.curentPage,
    required this.title,
  });

  @override
  State<DeleteGuidance> createState() => _DeleteGuidanceState();
}

class _DeleteGuidanceState extends State<DeleteGuidance> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ButtonStateCubit()),
        BlocProvider.value(
          value: sl<GuidanceStudentCubit>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return CustomAlertDialog(
            title: 'Hapus Bimbingan',
            message: 'Apakah anda ingin menghapus bimbingan "${widget.title}"?',
            cancelText: 'Batal',
            confirmText: 'Hapus',
            confirmColor: AppColors.lightDanger,
            icon: Icons.delete_outline,
            iconColor: AppColors.lightDanger,
            onCancel: () {
              Navigator.of(context).pop();
            },
            confirmButton: (context) => BlocConsumer<ButtonStateCubit, ButtonState>(
              listener: (context, state) async {
                if (state is ButtonSuccessState) {
                  if (!context.mounted) return;

                  final guidanceCubit = context.read<GuidanceStudentCubit>();

                  try {
                    await guidanceCubit.displayGuidance();

                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          currentIndex: widget.curentPage,
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } catch (e) {
                    debugPrint('Error while calling displayGuidance: $e');
                  }
                }

                if (state is ButtonFailurState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar(
                      message: state.errorMessage,
                      icon: Icons.error_outline,
                      backgroundColor: Colors.red.shade800,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return BasicAppButton(
                  onPressed: () {
                    context.read<ButtonStateCubit>().excute(
                          usecase: sl<DeleteGuidanceUseCase>(),
                          params: widget.id,
                        );
                  },
                  title: 'Hapus',
                  height: false,
                );
              },
            ),
          );
        },
      ),
    );
  }
}