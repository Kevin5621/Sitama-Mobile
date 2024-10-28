import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/basic_app_button.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';

class TandaiSelesaiDialog extends StatelessWidget {
  final VoidCallback onConfirm; // Callback untuk tombol Lanjut
  final VoidCallback onCancel; // Callback untuk tombol Batal

  const TandaiSelesaiDialog({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Sudut bulat
        ),
        title: Text("Apakah yakin menandai selesai?"),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Ukuran kolom mengikuti konten
          children: [
            Text(
              "Keputusan tidak bisa diubah setelah setuju.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                onCancel(); // Panggil callback Batal
                Navigator.of(context).pop(); // Tutup pop-up
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
              ),
              child: Text("Batal"),
            ),
          ),
          BasicAppButton(
            onPressed: () {
              onConfirm(); // Panggil callback Lanjut
              Navigator.of(context).pop(); // Tutup pop-up
            },
            title: "Lanjut",
            height: false,
          ),
        ],
      ),
    );
  }
}
