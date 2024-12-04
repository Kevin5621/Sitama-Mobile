import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/custom_snackbar.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/data/models/score_request.dart';
import 'package:sistem_magang/domain/entities/assessment_entity.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/bloc/assessment_cubit.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/bloc/assessment_state.dart';
import 'package:sistem_magang/presenstation/lecturer/input_score/widgets/expandable_section.dart';

class ScoreInputOverlay extends StatefulWidget {
  final int id;
  final Function(bool)? onSubmitSuccess;

  const ScoreInputOverlay({
    Key? key, 
    required this.id, 
    this.onSubmitSuccess
  }) : super(key: key);

  @override
  _ScoreInputOverlayState createState() => _ScoreInputOverlayState();
}

class _ScoreInputOverlayState extends State<ScoreInputOverlay> {
  late AssessmentCubit _assessmentCubit;
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _assessmentCubit = AssessmentCubit()..fetchAssessments(widget.id);
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _controllers.forEach((key, controller) => controller.dispose());
    _assessmentCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _assessmentCubit,
      child: BlocConsumer<AssessmentCubit, AssessmentState>(
        listener: (context, state) {
          if (state is AssessmentSubmittedSuccess) {
            _handleSubmitSuccess(context);
          }
        },
        builder: (context, state) {
          if (state is AssessmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is LoadAssessmentFailure) {
            return _buildErrorWidget(state.errorMessage);
          }
          
          if (state is AssessmentLoaded) {
            return _buildOverlayContent(context, state.assessments);
          }
          
          return _buildErrorWidget('Tidak ada data');
        },
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context, List<AssessmentEntity> assessments) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildAssessmentList(assessments),
              const SizedBox(height: 32.0),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Input Nilai',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildAssessmentList(List<AssessmentEntity> assessments) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: assessments.length,
      itemBuilder: (context, index) {
        return ExpandableSection(
          title: assessments[index].componentName,
          scores: assessments[index].scores,
          controllers: _controllers,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => _onSubmit(context),
        child: const Text(
          'Update',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    final List<ScoreRequest> scores = _controllers.entries.map((entry) {
      return ScoreRequest(
        detailedAssessmentComponentsId: entry.key,
        score: int.tryParse(entry.value.text) ?? 0,
      );
    }).toList();

    if (scores.any((score) => score.score < 0 || score.score > 100)) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Nilai harus antara 0 - 100',
          icon: Icons.warning_outlined,
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }

    context.read<AssessmentCubit>().submitScores(widget.id, scores);
  }

  void _handleSubmitSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: 'Berhasil Memberikan nilai',
        icon: Icons.check_circle_outline,
        backgroundColor: Colors.green.shade800,
      ),
    );

    // Notify parent about successful submission if callback is provided
    widget.onSubmitSuccess?.call(true);
    
    // Close the overlay
    Navigator.of(context).pop();
  }
}