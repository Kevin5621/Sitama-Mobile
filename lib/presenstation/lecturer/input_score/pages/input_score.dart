import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/domain/entities/assessment_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/bloc/assessment_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/bloc/assessment_state.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/widgets/add_industry_button.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/widgets/expandable_section.dart';

class InputScorePage extends StatefulWidget {
  final int id;

  const InputScorePage({super.key, required this.id});

  @override
  _InputScorePageState createState() => _InputScorePageState();
}

class _InputScorePageState extends State<InputScorePage> {
  List<IndustryScore> _industryScores = [];

  void _addIndustryScore() {
    setState(() {
      _industryScores.add(IndustryScore(
        title: 'Nilai Industri ${_industryScores.length + 1}',
        companyName: '',
        startDate: null,
        endDate: null,
        score: '',
      ));
    });
  }

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
      body: BlocProvider(
        create: (context) => AssessmentCubit()..fetchAssessments(widget.id),
        child: BlocBuilder<AssessmentCubit, AssessmentState>(
          builder: (context, state) {
            if (state is AssessmentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadAssessmentFailure) {
              return Center(
                child: Text(
                  'Error: ${state.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is AssessmentLoaded) {
              return _mainContent(state.assessments);
            } else {
              return const Center(child: Text('Tidak ada data.'));
            }
          },
        ),
      ),
    );
  }

  SingleChildScrollView _mainContent(List<AssessmentEntity> assessments) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: assessments.length,
              itemBuilder: (context, index) {
                return ExpandableSection(
                  title: assessments[index].componentName,
                  scores: assessments[index].scores,
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 10),
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
                  backgroundColor: AppColors.lightPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // _onSubmitNilai
                },
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeIndustryScore(IndustryScore score) {
    setState(() {
      _industryScores.remove(score);
    });
  }
}

class IndustryScoreCard extends StatelessWidget {
  final IndustryScore score;
  final VoidCallback onRemove;

  const IndustryScoreCard({
    Key? key,
    required this.score,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.school, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      score.title,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
                const Icon(Icons.add_circle_outline, color: Colors.grey),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: score.companyName,
                        onChanged: (value) {
                          score.companyName = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Nama Perusahaan',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete_outline, color: Colors.grey),
                      onPressed: onRemove,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  context,
                  label: "Tanggal Mulai",
                  value: score.startDate,
                  onChanged: (val) => score.startDate = val,
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  context,
                  label: "Tanggal Selesai",
                  value: score.endDate,
                  onChanged: (val) => score.endDate = val,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: score.score,
                  onChanged: (value) {
                    // Ensuring only numbers are allowed
                    if (value.isNotEmpty && double.tryParse(value) != null) {
                      score.score = value;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nilai',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required DateTime? value,
    required Function(DateTime) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              onChanged(pickedDate);
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: TextEditingController(
                text:
                    value != null ? DateFormat('dd-MM-yyyy').format(value) : '',
              ),
              decoration: InputDecoration(
                hintText: 'Pilih Tanggal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class IndustryScore {
  final String title;
  String companyName;
  DateTime? startDate;
  DateTime? endDate;
  String score;

  IndustryScore({
    required this.title,
    this.companyName = '',
    this.startDate,
    this.endDate,
    this.score = '',
  });
}
