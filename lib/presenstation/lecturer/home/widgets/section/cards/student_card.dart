import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Sitama/core/config/assets/app_images.dart';
import 'package:Sitama/domain/entities/lecturer_home_entity.dart';
import 'package:Sitama/presenstation/lecturer/home/bloc/selection_bloc.dart';
import 'package:Sitama/presenstation/lecturer/home/bloc/selection_state.dart';
import 'package:Sitama/presenstation/lecturer/home/widgets/utils/helper/activity_helper.dart';

// StudentCard Widget
// This widget displays a card for each student with their profile image, name, username, major, and class.
// It supports selection and drag-and-drop functionality for multiple selections.

class StudentCard extends StatelessWidget {
  final LecturerStudentsEntity student; // Student data entity
  final bool isSelected; // Indicates if the card is selected
  final bool isFinished; // Indicates if the student has finished their activities
  final VoidCallback onTap; // Callback for tap events
  final VoidCallback onLongPress; // Callback for long press events

  const StudentCard({
    super.key,
    required this.student,
    required this.isSelected,
    required this.isFinished,
    required this.onTap,
    required this.onLongPress,
  });

  // Retrieve active activities for the student if they are not finished
  List<String> _getActiveActivities() {
    return isFinished ? [] : ActivityHelper.getActiveActivities(student.activities);
  }

  // Get the profile image URL or a default image if none is provided
  String get _getProfileImage {
    return student.photo_profile ?? AppImages.defaultProfile;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine background color based on selection state
    final backgroundColor = isSelected 
        ? colorScheme.primary.withOpacity(0.3)
        : colorScheme.surface;

    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, state) {
        // Check if multiple selections are active
        final isMultiSelect = state.isSelectionMode && state.selectedIds.isNotEmpty;
        final selectedStudents = isMultiSelect ? state.selectedIds : {student.id};

        // If multiple selection is active, create a draggable card
        if (isMultiSelect) {
          return Draggable<Set<int>>(
            data: state.selectedIds,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            
            // Feedback widget displayed while dragging
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
                        // Circle avatar for the student profile
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
                        // Display number of selected students
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
            
            // Widget displayed when the card is being dragged
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: Card(
                color: backgroundColor.withOpacity(0.5),
                child: _buildCardContent(context),
              ),
            ),
            
            // Main card widget
            child: Card(
              elevation: theme.cardTheme.elevation ?? 1,
              color: backgroundColor,
              shape: theme.cardTheme.shape ?? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: onTap, // Handle tap events
                onLongPress: onLongPress, // Handle long press events
                child: _buildCardContent(context),
              ),
            ),
          );
        }

        // If not in multi-select mode, simply display // the card for the individual student
        return Card(
          elevation: theme.cardTheme.elevation ?? 1,
          color: backgroundColor,
          shape: theme.cardTheme.shape ?? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap, // Handle tap events
            onLongPress: onLongPress, // Handle long press events
            child: _buildCardContent(context), // Build the card content
          ),
        );
      },
    );
  }

  // Build the main content of the student card
  Widget _buildCardContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine background color based on selection state
    final backgroundColor = isSelected 
        ? colorScheme.primary.withOpacity(0.3)
        : colorScheme.surface;

    final textColor = colorScheme.onSurface;
    final normal = theme.textTheme.bodySmall?.color ?? colorScheme.onSurface.withOpacity(0.6);
    final selected = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    // Get active activities for display
    final activeActivities = _getActiveActivities();

    return Stack(
      children: [
        // Display finished indicator or activity icons
        if (isFinished)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Selesai', // Indicates the student has finished
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else if (activeActivities.isNotEmpty)
          ActivityHelper.buildActivityIconsStack(
            activities: activeActivities, // Display activity icons
            context: context,
            isSelected: isSelected,
            borderColor: isSelected 
              ? colorScheme.onPrimary.withOpacity(0.8)
              : backgroundColor,
          ),
        
        // Main content of the card
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Profile image displayed in a circular container
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
                        // Display student name
                        Text(
                          student.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Display student username
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
                            // Display student major
                            Text(
                              student.major,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isSelected 
                                  ? selected
                                  : normal,
                              ),
                            ),
                            // Display student class
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
            ],
          ),
        ),
      ],
    );
  }
}