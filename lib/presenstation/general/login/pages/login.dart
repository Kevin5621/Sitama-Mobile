import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/basic_app_button.dart';
import 'package:sistem_magang/common/widgets/custom_snackbar.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/data/models/signin_req_params.dart';
import 'package:sistem_magang/domain/usecases/general/signin.dart';
import 'package:sistem_magang/presenstation/lecturer/home/pages/lecturer_home.dart';
import 'package:sistem_magang/presenstation/student/home/pages/home.dart';
import 'package:sistem_magang/service_locator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) async {
            if (state is ButtonSuccessState) {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              var role = sharedPreferences.getString('role');

              if (role == 'Student') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LecturerHomePage(),
                  ),
                );
              }
            }
            if (state is ButtonFailurState) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                  message: state.errorMessage,
                  icon: Icons.error_outline,
                  backgroundColor: Colors.red.shade800,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 312,
                  color: AppColors.lightPrimary500,
                  child: Center(
                    child: Image.asset(AppImages.loginvektor),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 16,
                      ),
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'NIM / NIP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Kata sandi',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          // showDialog(
                          //   context: context,
                          //   barrierDismissible: true, 
                          //   builder: (BuildContext context) {
                          //     return ForgotPassword();
                          //   },
                          // );
                        },
                        child: Text(
                          'Lupa Kata Sandi ?',
                          style: TextStyle(
                            color: AppColors.lightInfo,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Builder(builder: (context) {
                        return BasicAppButton(
                          onPressed: () {
                            context.read<ButtonStateCubit>().excute(
                                  usecase: sl<SigninUseCase>(),
                                  params: SigninReqParams(
                                    username: _usernameController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          },
                          title: 'Login',
                        );
                      })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
