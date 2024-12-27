import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitama/core/config/assets/app_images.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/core/shared/widgets/alert/custom_snackbar.dart';
import 'package:sitama/core/shared/widgets/buttons/basic_app_button.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state_cubit.dart';
import 'package:sitama/features/auth/data/models/signin_req_params.dart';
import 'package:sitama/features/auth/domain/usecases/signin.dart';
import 'package:sitama/features/lecturer/ui/home/pages/lecturer_home.dart';
import 'package:sitama/features/student/ui/home/pages/home.dart';
import 'package:sitama/service_locator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  late final TextEditingController _usernameController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _showErrorSnackbar(String message) {
    final snackBar = CustomSnackBar(
      message: message,
      icon: Icons.error_outline,
      backgroundColor: Colors.red.shade800,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          _scaffoldKey.currentState?.hideCurrentSnackBar();
        },
      ),
    );
    
    _scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  bool _validateInputs() {
    if (_usernameController.text.isEmpty) {
      _showErrorSnackbar('NIM/NIP tidak boleh kosong');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _showErrorSnackbar('Kata sandi tidak boleh kosong');
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: BlocProvider(
          create: (context) => ButtonStateCubit(),
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) async {
            if (state is ButtonSuccessState) {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              var role = sharedPreferences.getString('role');

              if (role == 'Student') {
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(),
                  ),
                );
              } else {
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LecturerHomePage(),
                  ),
                );
              }
            }
            if (state is ButtonFailurState) {
                String errorMessage = state.errorMessage;
                
                // Map specific error codes/messages to user-friendly messages
                if (errorMessage.contains('invalid_credentials')) {
                  errorMessage = 'NIM/NIP atau kata sandi salah';
                } else if (errorMessage.contains('network_error')) {
                  errorMessage = 'Gagal terhubung ke server. Periksa koneksi internet Anda';
                } else if (errorMessage.contains('account_locked')) {
                  errorMessage = 'Akun Anda terkunci. Silakan hubungi admin';
                } else {
                  errorMessage = 'Terjadi kesalahan. Silakan coba lagi nanti';
                }
                
                _showErrorSnackbar(errorMessage);
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
                              if (_validateInputs()) {
                                context.read<ButtonStateCubit>().excute(
                                  usecase: sl<SigninUseCase>(),
                                  params: SigninReqParams(
                                    username: _usernameController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
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
      ),
    );
  }
}
