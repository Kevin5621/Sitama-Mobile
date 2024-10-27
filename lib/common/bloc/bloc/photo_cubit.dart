import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/common/bloc/bloc/photo_state.dart';
import 'package:sistem_magang/core/service/secure_api.dart';
import 'package:sistem_magang/core/service/security_utils.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SecureApiClient _apiClient;
  final SharedPreferences _prefs;
  final ImagePicker _imagePicker = ImagePicker();
  
  ProfileCubit({
    required SecureApiClient apiClient,
    required SharedPreferences prefs,
  }) : _apiClient = apiClient,
       _prefs = prefs,
       super(ProfileInitial());

  Future<void> loadProfile() async {
    try {
      emit(ProfileLoading());
      
      final response = await _apiClient.get('/student/profile');
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        emit(ProfileLoaded(
          photoUrl: data['photo_profile'] ?? '',
          name: data['name'] ?? '',
          username: data['username'] ?? '',
          email: data['email'] ?? '',
        ));
        
        // Cache photo URL
        await _prefs.setString('cached_photo_url', data['photo_profile'] ?? '');
      } else {
        emit(const ProfileError('Failed to load profile'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      // Get current state for preserving data
      final currentState = state;
      String? currentPhotoUrl;
      if (currentState is ProfileLoaded) {
        currentPhotoUrl = currentState.photoUrl;
      }

      emit(ProfileUploading(currentPhotoUrl ?? ''));

      final file = File(image.path);
      final response = await _apiClient.uploadImage(file);

      if (response.statusCode == 200) {
        final newPhotoUrl = response.data['data']['photo_profile'];
        
        if (state is ProfileLoaded) {
          final loadedState = state as ProfileLoaded;
          emit(ProfileLoaded(
            photoUrl: newPhotoUrl,
            name: loadedState.name,
            username: loadedState.username,
            email: loadedState.email,
          ));
          
          // Update cached URL
          await _prefs.setString('cached_photo_url', newPhotoUrl);
        }
      } else {
        emit(const ProfileError('Failed to upload image'));
      }
    } on SecurityException catch (e) {
      emit(ProfileError(e.toString()));
    } catch (e) {
      emit(ProfileError('Error uploading image: ${e.toString()}'));
    }
  }
}