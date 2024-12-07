import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/bloc/bloc/forgot_password_cubit.dart';
import 'package:sistem_magang/common/bloc/bloc/forgot_password_state.dart';
import 'package:sistem_magang/data/repository/auth.dart';
import 'package:sistem_magang/domain/usecases/general/forgot_password.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final BuildContext? parentContext;

  ForgotPassword({super.key, this.parentContext});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context, theme),
    );
  }

  Widget _buildDialogContent(BuildContext context, ThemeData theme) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(
        ForgotPasswordUseCase(
          AuthRepostoryImpl(FirebaseAuth.instance)
        )
      ),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Email reset kata sandi telah dikirim'),
                backgroundColor: theme.colorScheme.secondary,
              )
            );
            Navigator.pop(context);
          }
          if (state is ForgotPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: theme.colorScheme.error,
              )
            );
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Lupa Kata Sandi',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state is! ForgotPasswordLoading
                      ? () {
                          if (_validateEmail(_emailController.text)) {
                            context
                              .read<ForgotPasswordCubit>()
                              .forgotPassword(_emailController.text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Email tidak valid'),
                                backgroundColor: theme.colorScheme.error,
                              )
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: state is ForgotPasswordLoading
                      ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                      : Text(
                          'Reset Kata Sandi',
                          style: TextStyle(
                            fontSize: 16, 
                            color: theme.colorScheme.onPrimary
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Simple email validation function
  bool _validateEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    ).hasMatch(email);
  }
}