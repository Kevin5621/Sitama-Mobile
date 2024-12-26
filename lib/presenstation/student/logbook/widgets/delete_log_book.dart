import 'package:sitama/common/widgets/alert.dart';
import 'package:sitama/common/widgets/basic_app_button.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/presenstation/student/logbook/bloc/log_book_student_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/common/bloc/button/button_state.dart';
import 'package:sitama/common/bloc/button/button_state_cubit.dart';
import 'package:sitama/common/widgets/custom_snackbar.dart';
import 'package:sitama/domain/usecases/student/logbook/delete_log_book_student.dart';
import 'package:sitama/presenstation/student/home/pages/home.dart';
import 'package:sitama/service_locator.dart';

class DeleteLogBooks extends StatefulWidget {
  final int id;
  final String title;
  final int curentPage;

  const DeleteLogBooks({
    super.key,
    required this.id,
    required this.curentPage,
    required this.title,
  });

  @override
  State<DeleteLogBooks> createState() => _DeleteLogBooksState();
}

class _DeleteLogBooksState extends State<DeleteLogBooks> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ButtonStateCubit()),
        BlocProvider.value(
          value: sl<LogBookStudentCubit>(),
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

                  final logbookCubit = context.read<LogBookStudentCubit>();

                  try {
                    await logbookCubit.displayLogBook();

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
                    // Tangani error jika terjadi
                    debugPrint('Error while calling displayLogBooks: $e');
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
                          usecase: sl<DeleteLogBookUseCase>(),
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