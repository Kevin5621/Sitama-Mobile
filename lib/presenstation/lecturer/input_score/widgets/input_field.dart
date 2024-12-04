import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sistem_magang/domain/entities/score_entity.dart';

class InputField extends StatelessWidget {
  final ScoreEntity score;
  final TextEditingController? controller;

  const InputField({Key? key, required this.score, this.controller })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller?.text = score.score != null ? score.score.toString() : '';
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
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: InputBorder.none, 
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}