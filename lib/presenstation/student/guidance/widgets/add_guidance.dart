import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/basic_app_button.dart';
import 'package:sistem_magang/data/models/guidance.dart';
import 'package:sistem_magang/domain/usecases/add_guidance_student.dart';
import 'package:sistem_magang/presenstation/student/home/pages/home.dart';
import 'package:sistem_magang/service_locator.dart';

class AddGuidance extends StatefulWidget {
  const AddGuidance({super.key});

  @override
  State<AddGuidance> createState() => _AddGuidanceState();
}

class _AddGuidanceState extends State<AddGuidance> {
  DateTime _date = DateTime.now();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _activity = TextEditingController();
  PlatformFile? _selectedFile;

  @override
  void dispose() {
    _title.dispose();
    _activity.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result != null){
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) async {
          if (state is ButtonSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Berhasil Menambahkan Bimbingan'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(currentIndex: 1),
              ),
              (Route<dynamic> route) => false,
            );
          }

          if (state is ButtonFailurState) {
            var snackBar = SnackBar(content: Text(state.errorMessage));
            print(state.errorMessage);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add_task_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tambah Bimbingan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Form(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _title,
                    decoration: InputDecoration(
                      labelText: 'Judul',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      prefixIcon: Icon(Icons.title, color: Theme.of(context).primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.05),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && picked != _date) {
                        setState(() {
                          _date = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.05),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy').format(_date),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColor),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _activity,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Aktivitas',
                      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 45),
                        child: Icon(Icons.assignment, color: Theme.of(context).primaryColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.05),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: _pickFile,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedFile != null 
                              ? Theme.of(context).primaryColor 
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _selectedFile != null
                            ? Theme.of(context).primaryColor.withOpacity(0.05)
                            : null,
                      ),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.file_upload,
                            color: _selectedFile != null
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedFile != null
                                    ? _selectedFile!.name
                                    : "Upload File (Opsional)",
                                style: TextStyle(
                                  color: _selectedFile != null
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (_selectedFile != null)
                              IconButton(
                                icon: const Icon(Icons.clear, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _selectedFile = null;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Builder(builder: (context) {
              return BasicAppButton(
                onPressed: () {
                  context.read<ButtonStateCubit>().excute(
                        usecase: sl<AddGuidanceUseCase>(),
                        params: AddGuidanceReqParams(
                          title: _title.text,
                          activity: _activity.text,
                          date: _date,
                          file: _selectedFile
                        ),
                      );
                },
                title: 'Add',
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