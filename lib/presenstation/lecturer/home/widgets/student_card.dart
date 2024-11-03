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

  Color _getActivityColor(String activity, bool isDark) {
    switch (activity) {
      case 'unseen':
        return isDark ? AppColors.lightGray : Colors.grey;
      case 'updated':
        return isDark ? AppColors.lightWarning : Colors.orange;
      case 'revisi':
        return isDark ? AppColors.lightDanger : Colors.red;
      default:
        return isDark ? AppColors.darkGray : Colors.grey;
    }
  }

  Color _getNotificationColor(bool isDark) {
    switch (notificationStatus) {
      case 1:
        return isDark ? AppColors.darkDanger : Colors.red;
      case 2:
        return isDark ? AppColors.darkInfo : Colors.blue;
      case 3:
        return isDark ? AppColors.darkGray : Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.darkGray500 : AppColors.lightWhite;
    final textColor = isDark ? AppColors.lightWhite : AppColors.lightBlack;
    final secondaryTextColor = isDark ? AppColors.darkGray : AppColors.lightGray;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 1,
        color: backgroundColor,
        child: Stack(
          children: [
            if (isSelected) ...[
              Positioned(
                top: 0,
                bottom: 0,
                right: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.check_circle, 
                    color: isDark ? AppColors.darkInfo : Colors.blue
                  ),
                ),
              ),
            ],
            // Activity Icons Stack
            Positioned(
              top: 8,
              right: 8,
              child: SizedBox(
                width: activities.length * 20.0,
                height: 24,
                child: Stack(
                  children: activities
                      .asMap()
                      .entries
                      .map((entry) {
                        return Positioned(
                          right: entry.key * 15.0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _getActivityColor(entry.value, isDark),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: backgroundColor,
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
                              color: backgroundColor,
                            ),
                          ),
                        );
                      })
                      .toList()
                      .reversed
                      .toList(),
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
                              ? (isDark ? AppColors.darkInfo : AppColors.lightInfo).withOpacity(0.1)
                              : backgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected 
                                ? (isDark ? AppColors.darkInfo : AppColors.lightInfo)
                                : (isDark ? AppColors.darkGray : AppColors.lightGray),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                color: secondaryTextColor,
                              );
                            },
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
                            color: _getNotificationColor(isDark),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: backgroundColor,
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nim,
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              jurusan,
                              style: TextStyle(
                                fontSize: 14,
                                color: secondaryTextColor,
                              ),
                            ),
                            Text(
                              '($kelas)',
                              style: TextStyle(
                                fontSize: 14,
                                color: secondaryTextColor,
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