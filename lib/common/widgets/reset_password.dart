import 'package:flutter/material.dart';
import 'package:sistem_magang/common/widgets/reset_password_field.dart';
import 'package:sistem_magang/data/models/reset_password_req_params.dart';
import 'package:sistem_magang/domain/usecases/general/reset_password.dart';
import 'package:sistem_magang/service_locator.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;
  
  // Track password strength
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.red;

  // Password validation patterns
  final RegExp _hasUpperCase = RegExp(r'[A-Z]');
  final RegExp _hasLowerCase = RegExp(r'[a-z]');
  final RegExp _hasNumbers = RegExp(r'\d');
  final RegExp _hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  String? _validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi lama tidak boleh kosong';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }

    List<String> requirements = [];

    if (value.length < 8) {
      requirements.add('minimal 8 karakter');
    }
    if (!_hasUpperCase.hasMatch(value)) {
      requirements.add('satu huruf besar');
    }
    if (!_hasLowerCase.hasMatch(value)) {
      requirements.add('satu huruf kecil');
    }
    if (!_hasNumbers.hasMatch(value)) {
      requirements.add('satu angka');
    }
    if (!_hasSpecialCharacters.hasMatch(value)) {
      requirements.add('satu karakter spesial');
    }

    if (requirements.isNotEmpty) {
      return 'Password harus memiliki ${requirements.join(", ")}';
    }

    return null;
  }

  void _updatePasswordStrength(String password) {
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (_hasUpperCase.hasMatch(password)) strength++;
    if (_hasLowerCase.hasMatch(password)) strength++;
    if (_hasNumbers.hasMatch(password)) strength++;
    if (_hasSpecialCharacters.hasMatch(password)) strength++;

    setState(() {
      _passwordStrength = strength / 6;
      
      if (_passwordStrength <= 0.3) {
        _passwordStrengthText = 'Lemah';
        _passwordStrengthColor = Colors.red;
      } else if (_passwordStrength <= 0.6) {
        _passwordStrengthText = 'Sedang';
        _passwordStrengthColor = Colors.orange;
      } else {
        _passwordStrengthText = 'Kuat';
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  void _togglePasswordVisibility(int fieldIndex) {
    setState(() {
      switch (fieldIndex) {
        case 1:
          _isOldPasswordVisible = !_isOldPasswordVisible;
          break;
        case 2:
          _isNewPasswordVisible = !_isNewPasswordVisible;
          break;
        case 3:
          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
          break;
      }
    });
  }

  bool _preventReusedPassword() {
    return _oldPasswordController.text != _newPasswordController.text;
  }

  void _validateForm() {
    setState(() {
      _oldPasswordError = _validateOldPassword(_oldPasswordController.text);
      _newPasswordError = _validateNewPassword(_newPasswordController.text);
      _confirmPasswordError = _validateNewPassword(_confirmPasswordController.text);
      
      if (_newPasswordController.text != _confirmPasswordController.text) {
        _confirmPasswordError = 'Kata sandi baru dan konfirmasi tidak cocok';
      }
      
      if (!_preventReusedPassword()) {
        _newPasswordError = 'Kata sandi baru tidak boleh sama dengan kata sandi lama';
      }
    });
  }

  Future<void> _handleResetPassword() async {
    _validateForm();
    
    if (_oldPasswordError != null || _newPasswordError != null || _confirmPasswordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = ResetPasswordReqParams(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      final result = await sl<ResetPasswordUseCase>().execute(request);

      if (!mounted) return;

      result.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red,
            ),
          );
        },
        (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password berhasil diubah. Silakan login kembali.'),
              backgroundColor: Colors.green,
            ),
          );
          // Clear sensitive data
          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          
          // Navigate to login page
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                PasswordFormField(
                  controller: _oldPasswordController,
                  labelText: 'Kata sandi lama',
                  hintText: 'Masukkan kata sandi lama',
                  isPasswordVisible: _isOldPasswordVisible,
                  onToggleVisibility: _togglePasswordVisibility,
                  fieldIndex: 1,
                  errorText: _oldPasswordError,
                ),
                const SizedBox(height: 20),
                PasswordFormField(
                  controller: _newPasswordController,
                  labelText: 'Kata sandi baru',
                  hintText: 'Masukkan kata sandi baru',
                  isPasswordVisible: _isNewPasswordVisible,
                  onToggleVisibility: _togglePasswordVisibility,
                  fieldIndex: 2,
                  errorText: _newPasswordError,
                  onChanged: (value) {
                    _updatePasswordStrength(value);
                  },
                ),
                PasswordStrengthIndicator(
                  strength: _passwordStrength,
                  strengthText: _passwordStrengthText,
                  strengthColor: _passwordStrengthColor,
                ),
                PasswordRequirements(
                  password: _newPasswordController.text,
                ),
                const SizedBox(height: 20),
                PasswordFormField(
                  controller: _confirmPasswordController,
                  labelText: 'Konfirmasi kata sandi baru',
                  hintText: 'Masukkan ulang kata sandi baru',
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: _togglePasswordVisibility,
                  fieldIndex: 3,
                  errorText: _confirmPasswordError,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Ganti Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clear sensitive data
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}