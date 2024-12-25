// ignore_for_file: deprecated_member_use

import 'package:Sitama/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:Sitama/common/widgets/about_app.dart';
import 'package:Sitama/common/widgets/edit_photo_profile_pop_up.dart';
import 'package:Sitama/common/widgets/log_out_alert.dart';
import 'package:Sitama/common/widgets/setting_button.dart';
import 'package:Sitama/core/config/assets/app_images.dart';
import 'package:Sitama/core/config/themes/app_color.dart';
import 'package:Sitama/core/config/themes/theme_provider.dart';
import 'package:Sitama/domain/entities/lecturer_profile_entity.dart';
import 'package:Sitama/presenstation/lecturer/profile/pages/faq.dart';
import 'package:Sitama/presenstation/lecturer/profile/bloc/profile_lecturer_cubit.dart';
import 'package:Sitama/presenstation/lecturer/profile/bloc/profile_lecturer_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturerProfilePage extends StatefulWidget {
  const LecturerProfilePage({super.key});

  @override
  State<LecturerProfilePage> createState() => _LecturerProfilePageState();
}

class _LecturerProfilePageState extends State<LecturerProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => ProfileLecturerCubit(
        prefs: sl<SharedPreferences>(),
      )..displayLecturer(),
      child: BlocBuilder<ProfileLecturerCubit, ProfileLecturerState>(
        builder: (context, state) {
          return Scaffold(
            body: _buildContent(state, colorScheme, isDarkMode),
          );
        },
      ),
    );
  }

  Widget _buildContent(ProfileLecturerState state, ColorScheme colorScheme, bool isDarkMode) {
    if (state is LecturerLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is LecturerLoaded) {
      return SingleChildScrollView(
        child: Column(
          children: [
            _header(colorScheme, state.lecturerProfileEntity),
            const SizedBox(height: 22),
            _settingsList(context, isDarkMode),
          ],
        ),
      );
    }
    if (state is LoadLecturerFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              state.errorMessage,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileLecturerCubit>().displayLecturer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Stack _header(colorScheme, LecturerProfileEntity profile) {
    return Stack(
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(AppImages.homePattern),
              fit: BoxFit.cover,
            ),
            color: colorScheme.inversePrimary,
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
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
                  image: profile.photo_profile != null
                      ? NetworkImage(profile.photo_profile!)
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
              profile.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: colorScheme.onBackground,
              ),
            ),
            Text(
              profile.username,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
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
                  builder: (context) => LecturerFAQPage(),
                ),
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
}
