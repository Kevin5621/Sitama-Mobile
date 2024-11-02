import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistem_magang/common/widgets/log_out_alert.dart';
import 'package:sistem_magang/common/widgets/setting_button.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/core/config/themes/theme_provider.dart';

class LecturerProfilePage extends StatelessWidget {
  const LecturerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(colorScheme),
            const SizedBox(height: 26),
            _about(colorScheme),
            const SizedBox(height: 100),
            _settingsList(context, isDarkMode),
          ],
        ),
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
              // Handle help and support
            },
          ),
          SettingButton(
            icon: Icons.info_outline,
            title: 'About App',
            onTap: () {
              // Handle about app
            },
          ),
          SettingButton(
            icon: Icons.logout,
            title: 'Log Out',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return LogOutAlert();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Stack _header(ColorScheme colorScheme) {
    return Stack(
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(AppImages.homePattern),
              fit: BoxFit.cover,
            ),
            color: colorScheme.primary,
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
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.background,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage(AppImages.photoProfile),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 36,
                  height: 36,
                  transform: Matrix4.translationValues(5, 5, 0),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      color: colorScheme.onPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'AMRAN YOBIOKTABERA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: colorScheme.onBackground,
              ),
            ),
            Text(
              'lucasScott@polines.com',
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

  Container _about(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 8,
          )
        ],
        color: colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'About',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          InfoRow(
            icon: Icons.person_outline,
            label: 'Nama',
            value: 'Amran Yobioktabera',
            colorScheme: colorScheme,
          ),
          InfoRow(
            icon: Icons.badge_outlined,
            label: 'NIP',
            value: '332221123456',
            colorScheme: colorScheme,
          ),
          InfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: 'Yobioktaberann@polines.com',
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const InfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.onSurface,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: colorScheme.onBackground,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
