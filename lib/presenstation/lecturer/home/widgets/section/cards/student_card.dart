import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/domain/entities/lecturer_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:sistem_magang/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:sistem_magang/presenstation/lecturer/home/widgets/utils/helper/activity_helper.dart';

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

    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        // Check if we're in selection mode with multiple items selected
        final isMultiSelect = state.isSelectionMode && state.selectedIds.length > 1;
        final selectedStudents = isMultiSelect ? state.selectedIds : {student.id};

        // Wrap with Draggable only when in multi-select mode
        if (isMultiSelect) {
          return Draggable<Set<int>>(
            data: state.selectedIds,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            
            // Feedback widget shown while dragging
            feedback: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary,
                              width: 1,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              _getProfileImage,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.person,
                                color: theme.iconTheme.color,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${selectedStudents.length} students selected',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Widget shown in place while dragging
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: Card(
                color: backgroundColor.withOpacity(0.5),
                child: _buildCardContent(context),
              ),
            ),
            
            // Main widget
            child: Card(
              elevation: theme.cardTheme.elevation ?? 1,
              color: backgroundColor,
              shape: theme.cardTheme.shape ?? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                child: _buildCardContent(context),
              ),
            ),
          );
        }

        // If not in multi-select mode, return a simple Card
        return Card(
          elevation: theme.cardTheme.elevation ?? 1,
          color: backgroundColor,
          shape: theme.cardTheme.shape ?? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: _buildCardContent(context),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final backgroundColor = isSelected 
        ? colorScheme.primary.withOpacity(0.3)
        : colorScheme.surface;
    
    final textColor = colorScheme.onSurface;
    final normal = theme.textTheme.bodySmall?.color ?? colorScheme.onSurface.withOpacity(0.6);
    final selected = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    
    final activeActivities = _getActiveActivities();

    return Stack(
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
    );
  }
}