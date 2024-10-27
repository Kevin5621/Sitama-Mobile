import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/log_out_alert.dart';
import 'package:sistem_magang/common/widgets/profile_photo.dart';
import 'package:sistem_magang/common/widgets/reset_password.dart';
import 'package:sistem_magang/common/widgets/setting_button.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/student_home_entity.dart';
import 'package:sistem_magang/presenstation/student/profile/bloc/profile_student_cubit.dart';
import 'package:sistem_magang/presenstation/student/profile/bloc/profile_student_state.dart';
import 'package:sistem_magang/presenstation/student/profile/widgets/box_industry.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const ProfilePhoto(),
                    _header(state.studentProfileEntity),
                    const SizedBox(height: 22),
                    const IndustryCard(internship: null,),
                    const SizedBox(height: 120),
                    _settingsList(context),
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

  Padding _settingsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  image: NetworkImage(student.photo_profile),
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
              student.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              student.username,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: AppColors.gray,
              ),
            ),
            Text(
              student.email,
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
}


