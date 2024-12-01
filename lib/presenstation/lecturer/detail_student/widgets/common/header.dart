import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';

/// [ProfileHeader] is a widget to display the student's profile header
/// with a background image, profile picture, name, username, and email.
class ProfileHeader extends StatelessWidget {
  final DetailStudentEntity detailStudent;

  const ProfileHeader({
    Key? key,
    required this.detailStudent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.homePattern),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // This section displays the profile picture in a circular shape with a white border
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: detailStudent.student.photo_profile != null
                        ? NetworkImage(detailStudent.student.photo_profile!)
                        : AssetImage(AppImages.defaultProfile) as ImageProvider,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display the student's name in bold and white color
            Text(
              detailStudent.student.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),

           // Display the username in a transparent background
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                detailStudent.student.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Email displayed with an email icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  detailStudent.student.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
