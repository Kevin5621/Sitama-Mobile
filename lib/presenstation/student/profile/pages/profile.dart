import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/common/widgets/edit_photo_profile_pop_up.dart';
import 'package:sistem_magang/common/widgets/setting_button.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/common/widgets/log_out_alert.dart';
import 'package:sistem_magang/domain/entities/lecturer_detail_student.dart';
import 'package:sistem_magang/domain/entities/student_home_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/reset_password/pages/reset_password.dart';
import 'package:sistem_magang/presenstation/student/profile/bloc/profile_student_cubit.dart';
import 'package:sistem_magang/presenstation/student/profile/bloc/profile_student_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileStudentCubit()..displayStudent(),
      child: BlocBuilder<ProfileStudentCubit, ProfileStudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is StudentLoaded) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _header(state.studentProfileEntity),
                    SizedBox(height: 22),
                    _industry(state.studentProfileEntity.internships, context),
                    SizedBox(height: 40),
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

  Container _industry(
      List<InternshipStudentEntity>? internships, BuildContext context) {
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
              'Industri',
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 10),
          if (internships != null) ...[
            ListView.builder(
                itemCount: internships.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Industri ${index + 1}',
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Nama : ${internships[index].name}', // Replace with actual property
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Tanggal Mulai : ${DateFormat("dd-MM-yyyy").format(internships[index].start_date)}', // Replace with actual property
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Tanggal Selesai : ${DateFormat("dd-MM-yyyy").format(internships[index].start_date)}', // Replace with actual property
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                }),
          ] else ...[
            Text(
              'Tempat magang anda belum terdaftar !',
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
                  image: student.photo_profile != null
                      ? NetworkImage(student.photo_profile!)
                      : AssetImage(AppImages.photoProfile)
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
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => EditPhotoProfilePopUp());
                    },
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
