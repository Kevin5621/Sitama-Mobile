import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/Models/basic_app_button.dart';
import '../../bloc/button/button_state_cubit.dart';
import '../../bloc/button/button_state.dart';
import '../../../config/assets/app_images.dart';
import '../../../config/theme/theme.dart';
import '../../../data/models/signin_req_params.dart';
import '../../../domain/usecase/signin.dart';
import '../Mahasiswa/home.dart';
import '../../../config/routes.dart';

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
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (BuildContext context) => const HomePage())
              );
            }
            if (state is ButtonFailurState) {
              var snackBar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 312,
                  color: AppTheme.primary500,
                  child: Center(
                    child: Image.asset(AppImages.loginIlustration),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 16,
                      ),
                    ),
                    const Text(
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
                        decoration: const InputDecoration(
                          labelText: 'NIM / NIP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      const Text(
                        'Lupa Kata Sandi ?',
                        style: TextStyle(
                          color: AppTheme.info,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),
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