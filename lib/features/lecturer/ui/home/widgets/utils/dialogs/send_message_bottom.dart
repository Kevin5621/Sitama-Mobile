import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/core/shared/widgets/alert/custom_snackbar.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/notification/notification_bloc.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/notification/notification_event.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/notification/notification_state.dart';

void showSendMessageBottomSheet(BuildContext context, List<int> selectedIds) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    useSafeArea: false,
    barrierColor: Colors.transparent,
    builder: (dialogContext) => ScaffoldMessenger(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.black54,
              child: GestureDetector(
                onTap: () {}, // Prevent tap from propagating
                child: BlocListener<NotificationBloc, NotificationState>(
                  listener: (context, state) {
                    if (state is NotificationSent) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        CustomSnackBar(
                          message: 'Pesan Berhasil Terkirim! 📩',
                          icon: Icons.check_circle_outline,
                          backgroundColor: Colors.green.shade800,
                        ),
                      );
                    } else if (state is NotificationError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBar(
                          message: 'Gagal Mengirim Pesan: ${state.errorMessage}',
                          icon: Icons.error_outline,
                          backgroundColor: Colors.red.shade800,
                        ),
                      );
                    }
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
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
                            _buildHeader(dialogContext),
                            const SizedBox(height: 20),
                            _buildTitleField(titleController, context),
                            const SizedBox(height: 20),
                            _buildMessageField(messageController, context),
                            const SizedBox(height: 20),
                            _buildSendButton(context, titleController, messageController, selectedIds),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildHeader(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Kirim Pengumuman',
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

Widget _buildTitleField(TextEditingController controller, BuildContext context) {
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
      style: TextStyle(
        color: isDark ? AppColors.lightWhite : AppColors.darkPrimaryDark,
      ),
      decoration: InputDecoration(
        hintText: "Masukkan judul",
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkGray : AppColors.lightGray,
        ),
        contentPadding: const EdgeInsets.all(16),
        border: InputBorder.none,
        filled: true,
        fillColor: isDark ? AppColors.darkGray500 : AppColors.lightWhite,
      ),
    ),
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
        hintText: "Kirim Pesan disini...",
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkGray : AppColors.lightGray,
        ),
        contentPadding: const EdgeInsets.all(16),
        border: InputBorder.none,
        filled: true,
        fillColor: isDark ? AppColors.darkGray500 : AppColors.lightWhite,
      ),
    ),
  );
}

Widget _buildSendButton(
  BuildContext context,
  TextEditingController titleController,
  TextEditingController messageController,
  List<int> selectedIds,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Row(
    children: [
      Expanded(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            final isLoading = state is NotificationLoading;
            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => _handleSendMessage(
                        context,
                        titleController,
                        messageController,
                        selectedIds,
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkPrimaryLight : AppColors.lightPrimary,
                foregroundColor: AppColors.lightWhite,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Kirim Pesan (${selectedIds.length} Pengguna)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    ],
  );
}

void _handleSendMessage(
  BuildContext context,
  TextEditingController titleController,
  TextEditingController messageController,
  List<int> selectedIds,
) {
  if (titleController.text.isEmpty || messageController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: 'Tolong Masukkan Judul dan Pesan',
        icon: Icons.error_outline,
        backgroundColor: Colors.red.shade800,
      ),
    );
    return;
  }

  final notificationData = {
    'user_id' : selectedIds,
    'message': titleController.text,
    'detailText': messageController.text,
    'category': 'general',
    'date': DateTime.now().toIso8601String().split('T').first,
  };

  context.read<NotificationBloc>().add(
    SendNotification(
      notificationData: notificationData,
    ),
  );
}