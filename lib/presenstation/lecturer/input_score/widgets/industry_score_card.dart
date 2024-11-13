import 'package:flutter/material.dart';
import 'package:sistem_magang/domain/entities/industry_score.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/widgets/input_field.dart';

class IndustryScoreCard extends StatelessWidget {
  final IndustryScore score;
  final VoidCallback onRemove;

  const IndustryScoreCard(
      {Key? key, required this.score, required this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: score.title),
                    onChanged: (value) => score.title = value,
                    decoration: InputDecoration(
                      hintText: 'Judul Nilai Industri',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onRemove,
                ),
              ],
            ),
            Divider(thickness: 1, height: 1),
            const SizedBox(height: 16),
            InputField(
              label: 'Tanggal Mulai',
              controller: TextEditingController(text: score.startDate),
            ),
            InputField(
              label: 'Tanggal Selesai',
              controller: TextEditingController(text: score.endDate),
            ),
            InputField(
              label: 'Nilai',
              controller: TextEditingController(text: score.score),
            ),
          ],
        ),
      ),
    );
  }
}