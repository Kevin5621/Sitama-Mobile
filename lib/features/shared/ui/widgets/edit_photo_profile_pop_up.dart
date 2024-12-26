import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitama/core/shared/widgets/alert/custom_snackbar.dart';
import 'package:sitama/core/shared/widgets/buttons/basic_app_button.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state.dart';
import 'package:sitama/core/shared/widgets/buttons/button_state_cubit.dart';
import 'package:sitama/features/lecturer/ui/home/pages/lecturer_home.dart';
import 'package:sitama/features/shared/data/models/update_profile_req_params.dart';
import 'package:sitama/features/shared/domain/usecases/update_photo_profile.dart';
import 'package:sitama/features/student/ui/home/pages/home.dart';
import 'package:sitama/service_locator.dart';

class EditPhotoProfilePopUp extends StatefulWidget {
  const EditPhotoProfilePopUp({super.key});

  @override
  State<EditPhotoProfilePopUp> createState() => _EditPhotoProfilePopUpState();
}

class _EditPhotoProfilePopUpState extends State<EditPhotoProfilePopUp> {
  PlatformFile? _selectedImage;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        if (result.files.first.bytes != null) {
          setState(() {
            _selectedImage = result.files.first;
          });
        } else {
          throw Exception('File data is null');
        }
      } else {
        throw Exception('No file selected');
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          CustomSnackBar(
            message: 'Error selecting image: $e',
            icon: Icons.error_outline,
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
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
            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                message: 'Berhasil Mengubah Foto Profil 🎉',
                icon: Icons.check_circle_outline,
                backgroundColor: Colors.green.shade800,
              ),
            );
            
            Navigator.pushAndRemoveUntil(
              context,
              role == "Student" ? 
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
            ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(  
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
            child: SizedBox(
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