import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';

class StudentCard extends StatelessWidget {
  final int id;
  final String imageUrl;
  final String name;
  final String jurusan;
  final String kelas;
  final String nim;
  final bool isSelected;
  final List<String> activities;
  final int notificationStatus;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const StudentCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.jurusan,
    required this.kelas,
    required this.nim,
    required this.isSelected,
    this.activities = const [],
    this.notificationStatus = 0,
    required this.onTap,
    required this.onLongPress,
  });

  // Get icon based on activity type
  IconData _getActivityIcon(String activity) {
    switch (activity) {
      case 'unseen':
        return Icons.visibility_off;
      case 'updated':
        return Icons.help;
      case 'revisi':
        return Icons.edit_document;
      default:
        return Icons.circle;
    }
  }

  // Get color based on activity type
  Color _getActivityColor(String activity) {
    switch (activity) {
      case 'unseen':
        return Colors.grey;
      case 'updated':
        return Colors.orange;
      case 'revisi':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getNotificationColor() {
    switch (notificationStatus) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 1,
        color: AppColors.white,
        child: Stack(
          children: [
            if (isSelected) ...[
              Positioned(
                top: 0,
                bottom: 0,
                right: 8,
                child: Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(Icons.check_circle, color: Colors.blue),
                ),
              ),
            ],
            // Activity Icons Stack
            Positioned(
              top: 8,
              right: 8,
              child: SizedBox(
                width: activities.length *
                    20.0, // Adjust width based on number of activities
                height: 24,
                child: Stack(
                  children: activities
                      .asMap()
                      .entries
                      .map((entry) {
                        // Calculate position for overlapping effect
                        return Positioned(
                          right: entry.key * 15.0, // Adjust overlap distance
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _getActivityColor(entry.value),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              _getActivityIcon(entry.value),
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        );
                      })
                      .toList()
                      .reversed
                      .toList(), // Reverse to show first item on top
                ),
              ),
            ),
            // Main Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.info.withOpacity(0.1)
                              : AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.info : AppColors.gray,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getNotificationColor(),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nim,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.gray,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              jurusan,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.gray,
                              ),
                            ),
                            Text(
                              '($kelas)',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
