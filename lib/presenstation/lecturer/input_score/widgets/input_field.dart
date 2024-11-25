import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/score_entity.dart';

class InputField extends StatelessWidget {
  final ScoreEntity score;
  final TextEditingController? controller;

  const InputField({Key? key, required this.score, this.controller })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller?.text = score.score.toString() ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(score.name, style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightPrimary),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}