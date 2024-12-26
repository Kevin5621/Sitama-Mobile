import 'package:sitama/core/config/themes/app_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sitama/core/shared/widgets/alert/custom_snackbar.dart';
import 'package:sitama/core/shared/widgets/buttons/basic_app_button.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state_cubit.dart';
import 'package:sitama/features/shared/data/models/guidance.dart';
import 'package:sitama/features/student/domain/usecases/guidances/add_guidance_student.dart';
import 'package:sitama/features/student/ui/home/pages/home.dart';
import 'package:sitama/service_locator.dart';

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

  bool _titleError = false;
  bool _activityError = false;

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
              CustomSnackBar(
                message: 'Berhasil Menambahkan Bimbingan 🥸',
                icon: Icons.check_circle_outline,  
                backgroundColor: Colors.green.shade800,  
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
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha((0.1*255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.add_task_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: const Text(
                  'Tambah Bimbingan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Form(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _title,
                    decoration: InputDecoration(
                      labelText: 'Judul',
                      labelStyle: TextStyle(
                        color: _titleError ? AppColors.lightDanger : Theme.of(context).primaryColor
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _titleError ? AppColors.lightDanger : Theme.of(context).primaryColor
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _titleError ? AppColors.lightDanger : Colors.grey
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _titleError ? AppColors.lightDanger : Theme.of(context).primaryColor,
                          width: 2
                        ),
                      ),
                      errorText: _titleError ? 'Judul tidak boleh kosong' : null,
                      errorStyle: TextStyle(
                        color: AppColors.lightDanger,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).primaryColor.withAlpha((0.05*255).round()),
                    ),
                    onChanged: (value) {
                      // Clear error when user starts typing
                      if (_titleError) {
                        setState(() {
                          _titleError = false;
                        });
                      }
                    },
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
                          // Get the current brightness
                          final isDark = Theme.of(context).brightness == Brightness.dark;
                          
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: isDark 
                                ? ColorScheme.dark(
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.white,
                                    surface: Theme.of(context).colorScheme.surfaceContainer,
                                    onSurface: Theme.of(context).colorScheme.onSurface,
                                  )
                                : ColorScheme.light(
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.white,
                                    surface: Theme.of(context).colorScheme.surfaceContainer,
                                    onSurface: Theme.of(context).colorScheme.onSurface,
                                  ),
                              dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).primaryColor,
                                ),
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
                        fillColor: Theme.of(context).primaryColor.withAlpha((0.05).round()),
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
                      labelStyle: TextStyle(
                        color: _activityError ? AppColors.lightDanger : Theme.of(context).primaryColor
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _activityError ? AppColors.lightDanger : Colors.grey
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _activityError ? AppColors.lightDanger : Theme.of(context).primaryColor,
                          width: 2
                        ),
                      ),
                      errorText: _activityError ? 'Aktivitas tidak boleh kosong' : null,
                      errorStyle: TextStyle(
                        color: AppColors.lightDanger,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).primaryColor.withAlpha((0.05).round()),
                    ),
                    onChanged: (value) {
                      // Clear error when user starts typing
                      if (_activityError) {
                        setState(() {
                          _activityError = false;
                        });
                      }
                    },
                  ),

                  //upload pdf
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: _pickFile,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedFile != null
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _selectedFile != null
                            ? Theme.of(context).primaryColor.withAlpha((0.05).round())
                            : null,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.file_upload,
                            color: _selectedFile != null
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          SizedBox(width: 12),
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
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(minWidth: 40),
                              icon: const Icon(Icons.clear, color: AppColors.lightDanger),
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
                ],
              ),
            ),
          ),
          actions: [
            Builder(builder: (context) {
              return BasicAppButton(
                onPressed: () {
                  // Update validation state
                  setState(() {
                    _titleError = _title.text.trim().isEmpty;
                    _activityError = _activity.text.trim().isEmpty;
                  });

                  // Only proceed if there are no errors
                  if (!_titleError && !_activityError) {
                    context.read<ButtonStateCubit>().excute(
                      usecase: sl<AddGuidanceUseCase>(),
                      params: AddGuidanceReqParams(
                        title: _title.text.trim(),
                        activity: _activity.text.trim(),
                        date: _date,
                        file: _selectedFile
                      ),
                    );
                  }
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