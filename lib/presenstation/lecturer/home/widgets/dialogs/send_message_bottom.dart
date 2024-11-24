import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/custom_snackbar.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_event.dart';

void showSendMessageBottomSheet(BuildContext context) {
  final TextEditingController messageController = TextEditingController();
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkWhite : AppColors.lightWhite,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildMessageField(messageController, context),
                  const SizedBox(height: 20),
                  _buildSendButton(context, messageController),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildHeader(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Krim Pengumuman',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.lightWhite : AppColors.lightBlack,
        ),
      ),
      IconButton(
        icon: Icon(
          Icons.close,
          color: isDark ? AppColors.lightWhite : AppColors.lightBlack,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}

Widget _buildMessageField(TextEditingController controller, BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    decoration: BoxDecoration(
      color: isDark ? AppColors.darkPrimaryDark : AppColors.lightWhite,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? AppColors.darkGray : AppColors.lightGray500,
      ),
    ),
    child: TextField(
      controller: controller,
      maxLines: 4,
      style: TextStyle(
        color: isDark ? AppColors.lightWhite : AppColors.darkPrimaryDark,
      ),
      decoration: InputDecoration(
        hintText: "Type your message here...",
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkGray : AppColors.lightGray,
        ),
        contentPadding: const EdgeInsets.all(16),
        border: InputBorder.none,
        filled: true, // Tambahan untuk memastikan latar terisi
        fillColor: isDark ? AppColors.darkGray500: AppColors.lightWhite,
      ),
    ),
  );
}

Widget _buildSendButton(BuildContext context, TextEditingController controller) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () => _handleSendMessage(context, controller),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? AppColors.darkPrimaryLight : AppColors.lightPrimary,
            foregroundColor: AppColors.lightWhite,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send, size: 20),
              SizedBox(width: 8),
              Text(
                'Krim',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

void _handleSendMessage(BuildContext context, TextEditingController controller) {
  if (controller.text.isNotEmpty) {
    context.read<SelectionBloc>().add(SendMessage(controller.text));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: 'Pesan Berhasil Terkirim 📩',
        icon: Icons.check_circle_outline,  
        backgroundColor: Colors.green.shade800,  
      ),
    );
  }
}