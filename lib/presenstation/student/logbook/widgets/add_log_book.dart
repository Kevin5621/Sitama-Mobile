import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/basic_app_button.dart';
import 'package:sistem_magang/data/models/log_book.dart';
import 'package:sistem_magang/domain/usecases/add_log_book_student.dart';
import 'package:sistem_magang/presenstation/student/home/pages/home.dart';
import 'package:sistem_magang/service_locator.dart';

class AddLogBook extends StatefulWidget {
  const AddLogBook({super.key});

  @override
  State<AddLogBook> createState() => _AddLogBookState();
}

class _AddLogBookState extends State<AddLogBook> {
  DateTime _date = DateTime.now();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _activity = TextEditingController();

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
                const SnackBar(content: Text('Berhasil Menambahkan Log Book'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(
                  currentIndex: 2,
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
                  Icons.book,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tambah Log Book',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      prefixIcon: Icon(Icons.title,
                          color: Theme.of(context).primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _activity,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Aktivitas',
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 45),
                        child: Icon(Icons.assignment,
                            color: Theme.of(context).primaryColor),
                      ),
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
                        usecase: sl<AddLogBookUseCase>(),
                        params: AddLogBookReqParams(
                          title: _title.text,
                          activity: _activity.text,
                          date: _date,
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
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
