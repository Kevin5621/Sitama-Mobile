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
        return isDark 
          ? AppColors.lightGray 
          : const Color(0xFF757575); // Darker grey
      case 'updated':
        return isDark 
          ? AppColors.lightWarning 
          : const Color(0xFFE65100); // Darker orange
      case 'rejected':
        return isDark 
          ? AppColors.lightDanger 
          : const Color(0xFFB71C1C); // Darker red
      default:
        return isDark 
          ? AppColors.darkGray 
          : const Color(0xFF424242); // Even darker grey
    }
  }

  Color _getIconColor(String activity, bool isDark, Color backgroundColor) {
    // Kontras dengan background untuk memastikan visibility
    if (isSelected) {
      return Colors.white; // Warna icon selalu putih saat card selected
    }
    
    switch (activity) {
      case 'in-progress':
        return isDark ? Colors.black87 : Colors.white;
      case 'updated':
        return Colors.white;
      case 'rejected':
        return Colors.white;
      default:
        return isDark ? Colors.white : Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isSelected 
        ? Colors.blueAccent.withOpacity(0.3) 
        : (isDark ? AppColors.darkGray500 : AppColors.lightWhite);
    
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
                                color: isSelected 
                                  ? Colors.white.withOpacity(0.8)
                                  : backgroundColor,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                _getactivitiesIcon(entry.value),
                                size: 14,
                                color: _getIconColor(entry.value, isDark, backgroundColor),
                              ),
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
            // Main Content remains the same
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.blue.withOpacity(0.5) 
                          : backgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.blue : (isDark ? AppColors.darkGray : AppColors.lightGray),
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
                            color: isSelected 
                                  ? AppColors.lightBlack 
                                  : secondaryTextColor
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
                                color: isSelected 
                                  ? AppColors.lightBlack 
                                  : secondaryTextColor
                              ),
                            ),
                            Text(
                              kelas,
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