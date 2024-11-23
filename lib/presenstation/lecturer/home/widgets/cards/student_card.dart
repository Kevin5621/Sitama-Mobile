import 'dart:math';
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

  Color _getactivitiesColor(String activity) {
    switch (activity) {
      case 'in-progress':
        return AppColors.lightGray;
      case 'updated':
        return AppColors.lightWarning;
      case 'rejected':
        return AppColors.lightDanger;
      default:
        return AppColors.lightGray;
    }
  }

   @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final backgroundColor = isSelected 
        ? colorScheme.primary.withOpacity(0.3)
        : colorScheme.surface;
    
    final textColor = colorScheme.onSurface;
    final secondaryTextColor = theme.textTheme.bodySmall?.color ?? colorScheme.onSurface.withOpacity(0.6);

    return Card(
      elevation: theme.cardTheme.elevation ?? 1,
      color: backgroundColor,
      shape: theme.cardTheme.shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            // Activity Icons Stack
            Positioned(
              top: 8,
              right: 8,
              child: SizedBox(
                width: max(24.0, activities.length * 20.0),
                height: 24,
                child: Stack(
                  alignment: Alignment.centerRight,
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
                              color: _getactivitiesColor(entry.value),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected 
                                  ? colorScheme.onPrimary.withOpacity(0.8)
                                  : backgroundColor,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.onSurface.withOpacity(0.2),
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
                                color: colorScheme.onPrimary,
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
            // Main Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? colorScheme.primary.withOpacity(0.5)
                          : backgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected 
                            ? colorScheme.primary
                            : secondaryTextColor,
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
                            color: theme.iconTheme.color,
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nim,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected 
                              ? Colors.black
                              : secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              jurusan,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isSelected 
                              ? Colors.black
                              : secondaryTextColor,
                              ),
                            ),
                            Text(
                              kelas,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isSelected 
                              ? Colors.black
                              : secondaryTextColor,
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