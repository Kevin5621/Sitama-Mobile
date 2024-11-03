import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';

class AddIndustryButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddIndustryButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.lightPrimary),
              SizedBox(width: 8),
              Text('Tambah Nilai Industri',
                  style: TextStyle(color: AppColors.lightPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}