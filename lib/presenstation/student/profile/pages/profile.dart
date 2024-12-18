import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:Sitama/common/widgets/about_app.dart';
import 'package:Sitama/common/widgets/edit_photo_profile_pop_up.dart';
import 'package:Sitama/common/widgets/reset_password.dart';
import 'package:Sitama/common/widgets/setting_button.dart';
import 'package:Sitama/core/config/assets/app_images.dart';
import 'package:Sitama/core/config/themes/app_color.dart';
import 'package:Sitama/common/widgets/log_out_alert.dart';
import 'package:Sitama/core/config/themes/theme_provider.dart';
import 'package:Sitama/domain/entities/student_home_entity.dart';
import 'package:Sitama/presenstation/student/faq/pages/faq.dart';
import 'package:Sitama/presenstation/student/profile/bloc/profile_student_cubit.dart';
import 'package:Sitama/presenstation/student/profile/bloc/profile_student_state.dart';
import 'package:Sitama/presenstation/student/profile/widgets/box_industry.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;  

  @override
  Widget build(BuildContext context) {
    super.build(context);  
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return BlocProvider(
      create: (context) => ProfileStudentCubit()..displayStudent(),
      child: BlocBuilder<ProfileStudentCubit, ProfileStudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is StudentLoaded) {

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _header(state.studentProfileEntity),
                    const SizedBox(height: 22),
                    IndustryCard(internships: state.studentProfileEntity.internships),
                    const SizedBox(height: 40),
                    _settingsList(context, isDarkMode),
                  ],
                ),
              ),
            );
          }
          if (state is LoadStudentFailure) {
            return Text(state.errorMessage);
          }
          return Container();
        },
      ),
    );
  }

  Padding _settingsList(BuildContext context, bool isDarkMode) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SettingButton(
            icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
            title: isDarkMode ? 'Light Mode' : 'Dark Mode',
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          SettingButton(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FAQPage()),
              );
            },
          ),
          SettingButton(
            icon: Icons.info_outline,
            title: 'About App',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutAppPage(),
                ),
              );
            },
          ),
          SettingButton(
            icon: Icons.lock_reset,
            title: 'Reset Password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ResetPasswordPage()),
              );
            },
          ),
          SettingButton(
            icon: Icons.logout,
            title: 'Log Out',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const LogOutAlert();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  
  Stack _header(StudentProfileEntity student) {
    return Stack(
      children: [
        Container(
          height: 160,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.homePattern),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 45),
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.lightBackground,
                ),
                borderRadius: BorderRadius.circular(32),
                image: DecorationImage(
                  image: student.photo_profile != null
                      ? NetworkImage(student.photo_profile!)
                      : const AssetImage(AppImages.defaultProfile)
                          as ImageProvider<Object>,
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 30,
                  height: 30,
                  transform: Matrix4.translationValues(5, 5, 0),
                  decoration: const BoxDecoration(
                    color: AppColors.lightPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => const EditPhotoProfilePopUp());
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: AppColors.lightWhite,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              student.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              student.username,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: AppColors.lightGray,
              ),
            ),
            Text(
              student.email,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: AppColors.lightGray,
              ),
            ),
          ],
        )
      ],
    );
  }
}


