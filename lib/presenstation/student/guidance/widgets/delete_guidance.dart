import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/alert.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/usecases/student/guidances/delete_guidance_student.dart';
import 'package:sistem_magang/presenstation/student/home/pages/home.dart';
import 'package:sistem_magang/service_locator.dart';

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
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) async {
          if (state is ButtonSuccessState) {
            // Tampilkan dialog sukses
            await CustomAlertDialog.showSuccess(
              context: context,
              title: 'Berhasil',
              message: 'Berhasil menghapus bimbingan',
            );
            
            // Navigate setelah menampilkan pesan sukses
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  currentIndex: widget.curentPage,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          }

          if (state is ButtonFailurState) {
            // Tampilkan dialog error
            CustomAlertDialog.showError(
              context: context,
              title: 'Gagal',
              message: state.errorMessage,
            );
          }
        },
        child: CustomAlertDialog(
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
          onConfirm: () {
            context.read<ButtonStateCubit>().excute(
              usecase: sl<DeleteGuidanceUseCase>(),
              params: widget.id,
            );
          },
        ),
      ),
    );
  }
}

// Cara penggunaan alternatif yang lebih sederhana:
void showDeleteConfirmation(BuildContext context, {
  required int id,
  required String title,
  required int currentPage,
}) {
  CustomAlertDialog.showWarning(
    context: context,
    title: 'Hapus Bimbingan',
    message: 'Apakah anda ingin menghapus bimbingan "$title"?',
    cancelText: 'Batal',
    confirmText: 'Hapus',
  ).then((confirmed) {
    if (confirmed == true) {
      final buttonCubit = ButtonStateCubit();
      
      buttonCubit.excute(
        usecase: sl<DeleteGuidanceUseCase>(),
        params: id,
      );

      buttonCubit.stream.listen((state) {
        if (state is ButtonSuccessState) {
          CustomAlertDialog.showSuccess(
            context: context,
            title: 'Berhasil',
            message: 'Berhasil menghapus bimbingan',
          ).then((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(currentIndex: currentPage),
              ),
              (Route<dynamic> route) => false,
            );
          });
        }
        
        if (state is ButtonFailurState) {
          CustomAlertDialog.showError(
            context: context,
            title: 'Gagal',
            message: state.errorMessage,
          );
        }
      });
    }
  });
}