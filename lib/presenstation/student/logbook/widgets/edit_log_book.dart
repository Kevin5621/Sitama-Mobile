import 'package:Sitama/core/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:Sitama/common/bloc/button/button_state.dart';
import 'package:Sitama/common/bloc/button/button_state_cubit.dart';
import 'package:Sitama/common/widgets/basic_app_button.dart';
import 'package:Sitama/common/widgets/custom_snackbar.dart';
import 'package:Sitama/data/models/log_book.dart';
import 'package:Sitama/domain/usecases/student/logbook/edit_log_book_student.dart';
import 'package:Sitama/presenstation/student/home/pages/home.dart';
import 'package:Sitama/service_locator.dart';

class EditLogBook extends StatefulWidget {
  final int id;
  final String title;
  final DateTime date;
  final String description;
  final int curentPage;

  const EditLogBook(
      {super.key,
      required this.id,
      required this.curentPage,
      required this.title,
      required this.date,
      required this.description});

  @override
  State<EditLogBook> createState() => _EditLogBookState();
}

class _EditLogBookState extends State<EditLogBook> {
  late DateTime _date;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _activity = TextEditingController();

  bool _titleError = false;
  bool _activityError = false;

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
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                message: 'Berhasil Mengedit Log Book ✍️',
                icon: Icons.check_circle_outline,  
                backgroundColor: Colors.green.shade800,  
              ),
            );
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
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'Edit Log Book',
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
                      fillColor:
                          Theme.of(context).primaryColor.withOpacity(0.05),
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

                  //upload date
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
                        prefixIcon: Icon(Icons.calendar_month,
                            color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).primaryColor.withOpacity(0.05),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy').format(_date),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.arrow_drop_down,
                              color: Theme.of(context).primaryColor),
                        ],
                      ),
                    ),
                  ),

                  //upload activity
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
                          color: _titleError ? AppColors.lightDanger : Colors.grey
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
                      fillColor:
                          Theme.of(context).primaryColor.withOpacity(0.05),
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
                      usecase: sl<EditLogBookUseCase>(),
                      params: EditLogBookReqParams(
                        id: widget.id,
                        title: _title.text.trim(),
                        activity: _activity.text.trim(),
                        date: _date,
                      ),
                    );
                  }
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
