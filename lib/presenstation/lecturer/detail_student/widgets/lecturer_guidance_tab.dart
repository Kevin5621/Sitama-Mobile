import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/basic_app_button.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/domain/entities/guidance_entity.dart';
import 'package:sistem_magang/domain/usecases/update_status_guidance.dart';
import 'package:sistem_magang/presenstation/lecturer/detail_student/pages/detail_student.dart';
import 'package:sistem_magang/service_locator.dart';

class LecturerGuidanceTab extends StatelessWidget {
  final List<GuidanceEntity> guidances;
  final int student_id;

  const LecturerGuidanceTab({super.key, required this.guidances, required this.student_id});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: guidances.length,
      itemBuilder: (context, index) {
        return LecturerGuidanceCard(
          guidance: guidances[index],
          student_id: student_id,
        );
      },
    );
  }
}

enum LecturerGuidanceStatus { approved, rejected, inProgress, updated }

class LecturerGuidanceCard extends StatefulWidget {
  final GuidanceEntity guidance;
  final int student_id;

  const LecturerGuidanceCard({
    Key? key,
    required this.guidance,
    required this.student_id,
  }) : super(key: key);

  @override
  _LecturerGuidanceCardState createState() => _LecturerGuidanceCardState();
}

class _LecturerGuidanceCardState extends State<LecturerGuidanceCard> {
  late LecturerGuidanceStatus currentStatus;
  TextEditingController _lecturerNote = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentStatus = widget.guidance.status == 'approved'
        ? LecturerGuidanceStatus.approved
        : widget.guidance.status == 'in-progress'
            ? LecturerGuidanceStatus.inProgress
            : widget.guidance.status == 'rejected'
                ? LecturerGuidanceStatus.rejected
                : LecturerGuidanceStatus
                    .updated; // Set status from GuidanceEntity
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: currentStatus == LecturerGuidanceStatus.rejected
          ? AppColors.danger500
          : AppColors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: _buildLeadingIcon(), // Show the status icon
          title: Text(widget.guidance.title), // Use title from GuidanceEntity
          subtitle: Text(DateFormat('dd/MM/yyyy')
              .format(widget.guidance.date)), // Use date from GuidanceEntity
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Catatan Mahasiswa :'),
                  Text(widget.guidance.activity),
                  const SizedBox(height: 16),
                  if (currentStatus != LecturerGuidanceStatus.inProgress) ...[
                    Text('Catatan Anda :'),
                    Text(widget.guidance.lecturer_note),
                    const SizedBox(height: 16),
                  ],
                  if (currentStatus != LecturerGuidanceStatus.approved &&
                      currentStatus != LecturerGuidanceStatus.rejected) ...[
                    _buildRevisionField(),
                    const SizedBox(height: 16),
                    _buildActionButtons(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the leading icon based on the status
  Widget _buildLeadingIcon() {
    switch (currentStatus) {
      case LecturerGuidanceStatus.approved:
        return const Icon(Icons.check_circle, color: AppColors.success);
      case LecturerGuidanceStatus.inProgress:
        return const Icon(Icons.remove_circle, color: AppColors.gray);
      case LecturerGuidanceStatus.rejected:
        return const Icon(Icons.error, color: AppColors.danger);
      case LecturerGuidanceStatus.updated:
        return const Icon(Icons.help, color: AppColors.warning);
      default:
        return const Icon(Icons.circle, color: AppColors.gray);
    }
  }

  Widget _buildRevisionField() {
    return TextField(
      controller: _lecturerNote,
      decoration: InputDecoration(
        hintText: 'Masukkan catatan...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      maxLines: 3,
      onChanged: (value) {
        // Update revision text if necessary
      },
    );
  }

  // Action buttons to approve or reject the guidance
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          icon: const Icon(
            Icons.done,
            color: AppColors.success,
            size: 16,
          ),
          label:
              const Text('Setujui', style: TextStyle(color: AppColors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () =>
              _showConfirmationDialog(LecturerGuidanceStatus.approved),
        ),
        SizedBox(width: 10),
        ElevatedButton.icon(
          icon: const Icon(
            Icons.close,
            color: AppColors.danger,
            size: 16,
          ),
          label: const Text('Revisi', style: TextStyle(color: AppColors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () =>
              _showConfirmationDialog(LecturerGuidanceStatus.rejected),
        ),
      ],
    );
  }

  // Confirmation dialog to change the status
  void _showConfirmationDialog(LecturerGuidanceStatus newStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => ButtonStateCubit(),
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) async {
              if (state is ButtonSuccessState) {
                var snackBar = SnackBar(
                    content: Text('Berhasil mengupdate status bimbingan'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailStudentPage(id: widget.student_id),
                  ),
                );
              }
              if (state is ButtonFailurState) {
                var snackBar = SnackBar(content: Text(state.errorMessage));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: AlertDialog(
              title: const Text('Konfirmasi'),
              content: Text(
                  'Apakah Anda yakin ingin ${newStatus == LecturerGuidanceStatus.approved ? 'menyetujui' : 'merevisi'} bimbingan ini?'),
              actions: [
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Builder(builder: (context) {
                  return BasicAppButton(
                    onPressed: () {
                      context.read<ButtonStateCubit>().excute(
                            usecase: sl<UpdateStatusGuidanceUseCase>(),
                            params: UpdateStatusGuidanceReqParams(
                                id: widget.guidance.id,
                                status:
                                    newStatus == LecturerGuidanceStatus.approved
                                        ? "approved"
                                        : "rejected",
                                lecturer_note: _lecturerNote.text),
                          );
                    },
                    title: 'Konfirmasi',
                    height: false,
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}