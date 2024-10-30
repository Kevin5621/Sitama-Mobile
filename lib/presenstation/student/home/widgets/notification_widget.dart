import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';

class NotificationWidget extends StatelessWidget {
  final VoidCallback onClose;

  const NotificationWidget({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info,
              color: AppColors.white,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Anda belum dijadwalkan seminar',
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: AppColors.white,
              ),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}