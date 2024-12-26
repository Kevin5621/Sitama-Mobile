import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/core/config/themes/app_color.dart';
import 'package:sitama/features/lecturer/data/models/score_request.dart';
import 'package:sitama/features/lecturer/domain/entities/assessment_entity.dart';
import 'package:sitama/features/lecturer/ui/detail_student/pages/detail_student.dart';
import 'package:sitama/features/lecturer/ui/input_score/bloc/assessment_cubit.dart';
import 'package:sitama/features/lecturer/ui/input_score/bloc/assessment_state.dart';
import 'package:sitama/features/lecturer/ui/input_score/widgets/expandable_section.dart';

class InputScorePage extends StatefulWidget {
  final int id;

  const InputScorePage({super.key, required this.id});

  @override
  _InputScorePageState createState() => _InputScorePageState();
}

class _InputScorePageState extends State<InputScorePage> {

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
        backgroundColor: Colors.black,
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
            } else if (state is AssessmentSubmitting) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AssessmentSubmissionFailed) {
              return Center(
                child: Text(
                  'Error: ${state.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is AssessmentSubmittedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Berhasil Memberikan nilai'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailStudentPage(id: widget.id),
                  ));
              return Container();
            } else {
              return const Center(child: Text('Tidak ada data.'));
            }
          },
        ),
      ),
    );
  }

  void _onSubmit(
      BuildContext context, Map<int, TextEditingController> controllers) {
    final List<ScoreRequest> scores = controllers.entries.map((entry) {
      return ScoreRequest(
        detailedAssessmentComponentsId: entry.key,
        score: double.tryParse(entry.value.text) ?? 0,
      );
    }).toList();

    if (scores.any((score) => score.score < 0 || score.score > 100)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nilai harus antara 0 dan 100')),
      );
      return;
    }

    context.read<AssessmentCubit>().submitScores(widget.id, scores);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Berhasil Memberikan nilai'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailStudentPage(id: widget.id),
      ),
    );
  }

  SingleChildScrollView _mainContent(List<AssessmentEntity> assessments) {
    final Map<int, TextEditingController> controllers = {};
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
                  controllers: controllers,
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 10),
            ),
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
                onPressed: () => _onSubmit(context, controllers),
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
}