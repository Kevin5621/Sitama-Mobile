import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/helper/activity_helper.dart';

class StudentCard extends StatelessWidget {
  final LecturerStudentsEntity student;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const StudentCard({
    super.key,
    required this.student,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  List<String> _getActiveActivities() {
    return ActivityHelper.getActiveActivities(student.activities);
  }

  String get _getProfileImage {
    return student.photo_profile ?? AppImages.defaultProfile;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final backgroundColor = isSelected 
        ? colorScheme.primary.withOpacity(0.3)
        : colorScheme.surface;
    
    final textColor = colorScheme.onSurface;
    final normal = theme.textTheme.bodySmall?.color ?? colorScheme.onSurface.withOpacity(0.6);
    final selected = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    
    final activeActivities = _getActiveActivities();

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
            if (activeActivities.isNotEmpty)
              ActivityHelper.buildActivityIconsStack(
                activities: activeActivities,
                context: context,
                isSelected: isSelected,
                borderColor: isSelected 
                  ? colorScheme.onPrimary.withOpacity(0.8)
                  : backgroundColor,
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
                            : normal,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        _getProfileImage,
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
                          student.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          student.username,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected 
                              ? selected
                              : normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              student.major,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isSelected 
                                  ? selected
                                  : normal,
                              ),
                            ),
                            Text(
                              student.the_class,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isSelected 
                                  ? selected
                                  : normal,
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