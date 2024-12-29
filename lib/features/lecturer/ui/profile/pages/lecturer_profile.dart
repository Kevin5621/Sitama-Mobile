import 'package:sitama/core/shared/widgets/alert/log_out_alert.dart';
import 'package:sitama/core/shared/widgets/buttons/setting_button.dart';
import 'package:sitama/core/shared/widgets/common/about_app.dart';
import 'package:sitama/features/lecturer/ui/home/bloc/helper/offline_mode_handler.dart';
import 'package:sitama/features/lecturer/ui/profile/bloc/profile_lecturer_cubit.dart';
import 'package:sitama/features/lecturer/ui/profile/bloc/profile_lecturer_state.dart';
import 'package:sitama/features/lecturer/ui/profile/pages/faq.dart';
import 'package:sitama/features/shared/ui/widgets/edit_photo_profile_pop_up.dart';
import 'package:sitama/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sitama/core/config/assets/app_images.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/core/config/themes/theme_provider.dart';
import 'package:sitama/features/lecturer/domain/entities/lecturer_profile_entity.dart';
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
      child: ConnectivityHandler(
        child: BlocBuilder<ProfileLecturerCubit, ProfileLecturerState>(
          builder: (context, state) {
            return Scaffold(
              body: Column(
                children: [
                  if (state is LecturerLoaded && state.isOffline)
                    Container(
                      width: double.infinity,
                      color: AppColors.lightGray,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Menggunakan data tersimpan Anda sedang offline',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Expanded(
                    child: _buildContent(state, colorScheme, isDarkMode),
                  ),
                ],
              ),
            );
          },
        ),
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
      if (state.isOffline && state.cachedData != null) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _header(colorScheme, state.cachedData!),
              const SizedBox(height: 22),
              _settingsList(context, isDarkMode),
            ],
          ),
        );
      }
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
                color: colorScheme.onSurface,
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