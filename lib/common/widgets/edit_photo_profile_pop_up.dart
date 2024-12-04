import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/common/bloc/button/button_state.dart';
import 'package:sistem_magang/common/bloc/button/button_state_cubit.dart';
import 'package:sistem_magang/common/widgets/basic_app_button.dart';
import 'package:sistem_magang/common/widgets/custom_snackbar.dart';
import 'package:sistem_magang/data/models/update_profile_req_params.dart';
import 'package:sistem_magang/domain/usecases/general/update_photo_profile.dart';
import 'package:sistem_magang/presenstation/lecturer/home/pages/lecturer_home.dart';
import 'package:sistem_magang/presenstation/student/home/pages/home.dart';
import 'package:sistem_magang/service_locator.dart';

class EditPhotoProfilePopUp extends StatefulWidget {
  const EditPhotoProfilePopUp({super.key});

  @override
  State<EditPhotoProfilePopUp> createState() => _EditPhotoProfilePopUpState();
}

class _EditPhotoProfilePopUpState extends State<EditPhotoProfilePopUp> {
  PlatformFile? _selectedImage;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedImage = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) async {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          var role = sharedPreferences.getString('role');
         
          if (state is ButtonSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                message: 'Berhasil Mengubah Foto Profil 🎉',
                icon: Icons.check_circle_outline,
                backgroundColor: Colors.green.shade800,
              ),
            );
            
            Navigator.pushAndRemoveUntil(
              context,
              role == null ? 
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    currentIndex: 3,
                  ),
                )
                : MaterialPageRoute(
                  builder: (context) => LecturerHomePage(
                    currentIndex: 1,
                  )
                ),
              (Route<dynamic> route) => false,
            );
          }

          if (state is ButtonFailurState) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                message: state.errorMessage,
                icon: Icons.error_outline,
                backgroundColor: Colors.red.shade800,
              ),
            );
          }
        },
        child: AlertDialog(
          title: Text(
            'Edit Foto Profil',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Form(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _pickImage,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: _selectedImage != null
                            ? ClipOval(
                                child: Image.memory(
                                  _selectedImage!.bytes!,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.add_a_photo),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_selectedImage != null) ...[
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 3),
                          Text(
                            'Edit',
                          )
                        ],
                      ),
                    )
                  ],
                ],
              ),
            ),
          ),
          actions: [
            Builder(builder: (context) {
              return BasicAppButton(
                onPressed: () {
                  if (_selectedImage != null) {
                    context.read<ButtonStateCubit>().excute(
                          usecase: sl<UpdatePhotoProfileUseCase>(),
                          params: UpdateProfileReqParams(
                              photo_profile: _selectedImage!),
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(
                        message: 'Silakan pilih foto terlebih dahulu 😉',
                        icon: Icons.warning_outlined,
                        backgroundColor: Colors.orange.shade800,
                      ),
                    );
                  }
                },
                title: 'Save',
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