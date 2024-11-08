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
    required this.onTap,
    required this.onLongPress,
  });

  IconData _getactivitiesIcon(String activity) {
    switch (activity) {
      case 'in-progress':
        return Icons.visibility_off;
      case 'updated':
        return Icons.help;
      case 'rejected':
        return Icons.edit_document;
      default:
        return Icons.circle;
    }
  }

  Color _getactivitiesColor(String activity, bool isDark) {
    switch (activity) {
      case 'in-progress':
        return isDark ? AppColors.lightGray : Colors.grey;
      case 'updated':
        return isDark ? AppColors.lightWarning : Colors.orange;
      case 'rejected':
        return isDark ? AppColors.lightDanger : Colors.red;
      default:
        return isDark ? AppColors.darkGray : Colors.grey;
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
                              color: _getactivitiesColor(entry.value, isDark),
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
                              _getactivitiesIcon(entry.value),
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
                  // Profile Picture without Blue Dot
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
