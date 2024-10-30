import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';

class InternshipBox extends StatelessWidget {
  final int index;
  final InternshipStudentEntity internship;

  const InternshipBox({
    Key? key,
    required this.index,
    required this.internship,
  }) : super(key: key);

  Widget _buildInternshipInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primary,
        ),
        SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Industri ${index + 1}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildInternshipInfo(
            Icons.business,
            'Nama',
            internship.name,
          ),
          SizedBox(height: 8),
          _buildInternshipInfo(
            Icons.calendar_today,
            'Tanggal Mulai',
            DateFormat('dd MMMM yyyy').format(internship.start_date),
          ),
          SizedBox(height: 8),
          _buildInternshipInfo(
            Icons.event,
            'Tanggal Selesai',
            internship.end_date != null
                ? DateFormat('dd MMMM yyyy').format(internship.end_date!)
                : "Belum selesai",
          ),
        ],
      ),
    );
  }
}
