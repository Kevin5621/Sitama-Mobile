import 'package:Sitama/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/common/bloc/button/button_state.dart';
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
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                message: state.errorMessage,
                icon: Icons.error_outline,  
                backgroundColor: Colors.red.shade800,  
              ),
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