import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/common/widgets/log_out_alert.dart';
import 'package:sistem_magang/common/widgets/reset_password.dart';

import '../../../../common/widgets/setting_button.dart';

class LecturerProfilePage extends StatelessWidget {
  const LecturerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            SizedBox(height: 26),
            _about(),
            SizedBox(height: 100),
            _settingsList(context),
          ],
        ),
      ),
    );
  }

  Padding _settingsList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
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
                  return LogOutAlert();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Stack _header() {
    return Stack(
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.homePattern),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(height: 40),
            Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 45),
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.background,
                ),
                borderRadius: BorderRadius.circular(32),
                image: DecorationImage(
                  image: AssetImage(AppImages.photoProfile),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 30,
                  height: 30,
                  transform: Matrix4.translationValues(5, 5, 0),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'AMRAN YOBIOKTABERA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'lucasScott@polines.com',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: AppColors.gray,
              ),
            ),
          ],
        )
      ],
    );
  }

  Container _about() {
    return Container(
      padding: EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray500,
            offset: Offset(0, 2),
            blurRadius: 2,
          )
        ],
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'About',
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Nama : Amran Yobioktabera',
            style: TextStyle(
              color: AppColors.gray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'NIP : 332221123456',
            style: TextStyle(
              color: AppColors.gray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Email : Yobioktaberann@polines.com',
            style: TextStyle(
              color: AppColors.gray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
