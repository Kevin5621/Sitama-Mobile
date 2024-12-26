import 'package:flutter/material.dart';
import 'package:sitama/core/config/themes/app_color.dart';

class PasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isPasswordVisible;
  final Function(int) onToggleVisibility;
  final Function(String)? onChanged;
  final String? errorText;
  final int fieldIndex;

  const PasswordFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.isPasswordVisible,
    required this.onToggleVisibility,
    required this.fieldIndex,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = AppColors.lightDanger;
    final primaryColor = theme.primaryColor;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final fillColor = theme.inputDecorationTheme.fillColor ?? Colors.grey[50];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: !isPasswordVisible,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            labelStyle: TextStyle(
              color: errorText != null ? errorColor : onSurfaceColor,
              fontSize: 16,
            ),
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            errorStyle: TextStyle(
              color: errorColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            errorText: errorText,
            filled: true,
            fillColor: errorText != null ? errorColor.withAlpha((0.1*255).round()) : fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? errorColor : onSurfaceColor.withAlpha((0.2*255).round()),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? errorColor : onSurfaceColor.withAlpha((0.2*255).round()),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? errorColor : primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorColor,
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: errorText != null ? errorColor : onSurfaceColor.withAlpha((0.7*255).round()),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: errorText != null ? errorColor : onSurfaceColor.withAlpha((0.7*255).round()),
              ),
              onPressed: () => onToggleVisibility(fieldIndex),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: errorColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorText!,
                    style: TextStyle(
                      color: errorColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}


class PasswordStrengthIndicator extends StatelessWidget {
  final double strength;
  final String strengthText;
  final Color strengthColor;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
    required this.strengthText,
    required this.strengthColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: strength,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              strength > 0.6 ? Icons.check_circle_outline : Icons.info_outline,
              size: 16,
              color: strengthColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Kekuatan Password: $strengthText',
              style: TextStyle(
                color: strengthColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// Update the password requirements widget
class PasswordRequirements extends StatelessWidget {
  final String password;
  
  const PasswordRequirements({
    super.key,
    required this.password,
  });

  bool _checkRequirement(String pattern) {
    return RegExp(pattern).hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    final requirements = [
      {
        'text': 'Minimal 8 karakter',
        'met': password.length >= 8,
      },
      {
        'text': 'Satu huruf besar (A-Z)',
        'met': _checkRequirement(r'[A-Z]'),
      },
      {
        'text': 'Satu huruf kecil (a-z)',
        'met': _checkRequirement(r'[a-z]'),
      },
      {
        'text': 'Satu angka (0-9)',
        'met': _checkRequirement(r'[0-9]'),
      },
      {
        'text': 'Satu karakter spesial (!@#\$%^&*)',
        'met': _checkRequirement(r'[!@#$%^&*(),.?":{}|<>]'),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Password harus memiliki:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        ...requirements.map((req) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Icon(
                req['met'] as bool ? Icons.check_circle : Icons.circle_outlined,
                size: 16,
                color: req['met'] as bool ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                req['text'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: req['met'] as bool ? Colors.green : Colors.grey[600],
                  fontWeight: req['met'] as bool ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}