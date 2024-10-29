import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/basic_app_button.dart';
import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/domain/usecases/edit_guidance_student.dart';
import 'package:sistem_magang/presenstation/student/home/pages/home.dart';
import 'package:sistem_magang/service_locator.dart';

class EditGuidance extends StatefulWidget {
  final int id;
  final String title;
  final DateTime date;
  final String description;
  final int curentPage;

  const EditGuidance(
      {super.key,
      required this.id,
      required this.curentPage,
      required this.title,
      required this.date,
      required this.description});

  @override
  State<EditGuidance> createState() => _EditGuidanceState();
}

class _EditGuidanceState extends State<EditGuidance> {
  late DateTime _date;
  PlatformFile? _selectedFile;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _activity = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  @override
  void initState() {
    _title.text = widget.title;
    _activity.text = widget.description;
    _date = widget.date;
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _activity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) async {
          if (state is ButtonSuccessState) {
            var snackBar =
                SnackBar(content: Text('Berhasil Mengedit Bimbingan'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  currentIndex: widget.curentPage,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          }

          if (state is ButtonFailurState) {
            var snackBar = SnackBar(content: Text(state.errorMessage));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: AlertDialog(
          title: Text('Edit Bimbingan'),
          content: Form(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(
                        labelText: 'Judul',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != _date) {
                          setState(() {
                            _date = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_month),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(DateFormat('dd/MM/yyyy').format(_date)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _activity,
                      decoration: InputDecoration(
                        labelText: 'Aktivitas',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: _pickFile,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.file_upload),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(_selectedFile != null
                            ? _selectedFile!.name
                            : "Upload File (Opsional)"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Builder(builder: (context) {
              return BasicAppButton(
                onPressed: () {
                  context.read<ButtonStateCubit>().excute(
                        usecase: sl<EditGuidanceUseCase>(),
                        params: EditGuidanceReqParams(
                          id: widget.id,
                          title: _title.text,
                          activity: _activity.text,
                          date: _date,
                          file: _selectedFile,
                        ),
                      );
                },
                title: 'Edit',
                height: false,
              );
            }),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
