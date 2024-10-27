import 'package:flutter/material.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/widgets/add_industry_button.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/widgets/expandable_section.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/widgets/industry_score_card.dart';
import 'package:sistem_magang/domain/entities/industry_score.dart';
import 'package:sistem_magang/domain/usecases/update_scores.dart';

class InputScorePage extends StatefulWidget {
  final UpdateScoresUseCase updateScoresUseCase;

  const InputScorePage({Key? key, required this.updateScoresUseCase})
      : super(key: key);

  @override
  _InputScorePageState createState() => _InputScorePageState();
}

class _InputScorePageState extends State<InputScorePage> {
  final List<IndustryScore> _industryScores = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nilai Dosen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpandableSection(
                title: 'Proposal',
                fields: [
                  'Tujuan Sasaran',
                  'Kelengkapan Proposal',
                  'Rata - rata'
                ],
              ),
              const SizedBox(height: 16),
              ExpandableSection(
                title: 'Laporan',
                fields: ['Sistematika Penulisan', 'Bahasa', 'Isi'],
              ),
              const SizedBox(height: 16),
              ..._industryScores.map((score) => IndustryScoreCard(
                    score: score,
                    onRemove: () => _removeIndustryScore(score),
                  )),
              const SizedBox(height: 16),
              AddIndustryButton(onTap: _addIndustryScore),
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _onSubmitNilai,
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addIndustryScore() {
    setState(() {
      _industryScores.add(IndustryScore(
        title: 'Nilai Industri ${_industryScores.length + 1}',
        startDate: '',
        endDate: '',
        score: '',
      ));
    });
  }

  void _removeIndustryScore(IndustryScore score) {
    setState(() {
      _industryScores.remove(score);
    });
  }

  void _onSubmitNilai() async {
    try {
      await widget.updateScoresUseCase.execute(_industryScores);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scores updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update scores')),
      );
    }
  }
}