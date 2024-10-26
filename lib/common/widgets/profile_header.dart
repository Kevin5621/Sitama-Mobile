import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';
import 'package:sistem_magang/core/service/secure_api.dart';
import 'package:sistem_magang/core/service/security_utils.dart';


class UserProfile {
  String? name;
  String? nim;
  String? email;
  String? profileImage;

  UserProfile({
    this.name,
    this.nim,
    this.email,
    this.profileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      nim: json['nim'],
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }
}

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final ImagePicker _picker = ImagePicker();
  final SecureApiClient _apiClient = SecureApiClient(
    baseUrl: 'http://192.168.36.1:8000/api/',
    secretKey: 'YOUR_SECRET_KEY', // Store this securely
  );
  
  bool _isLoading = true;
  bool _isUploading = false;
  String? _errorMessage;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _apiClient.get('/user/profile');
      
      if (response.statusCode == 200) {
        // Validate response data
        final validatedData = _validateProfileData(response.data);
        
        setState(() {
          _userProfile = UserProfile.fromJson(validatedData);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat profil: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _validateProfileData(Map<String, dynamic> data) {
    // Sanitize and validate all input data
    return {
      'name': SecurityUtils.sanitizeInput(data['name'] ?? ''),
      'nim': SecurityUtils.sanitizeInput(data['nim'] ?? ''),
      'email': SecurityUtils.sanitizeInput(data['email'] ?? ''),
      'profileImage': SecurityUtils.sanitizeInput(data['profileImage'] ?? ''),
    };
  }

  Future<void> _pickAndUploadImage() async {
    try {
      setState(() {
        _isUploading = true;
        _errorMessage = null;
      });

      // Pick image with security constraints
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile == null) {
        setState(() => _isUploading = false);
        return;
      }

      final imageFile = File(pickedFile.path);
      
      // Upload using secure client
      final response = await _apiClient.uploadImage(imageFile);

      if (response.statusCode == 200) {
        // Validate response URL
        final imageUrl = SecurityUtils.sanitizeInput(
          response.data['profile_image_url'] ?? ''
        );
        
        setState(() {
          if (_userProfile != null) {
            _userProfile!.profileImage = imageUrl;
          }
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e is SecurityException 
            ? e.toString()
            : 'Gagal mengunggah foto';
        _isUploading = false;
      });
    } finally {
      // Cleanup temporary files
      try {
        final tempDir = Directory.systemTemp;
        final tempFiles = tempDir.listSync();
        for (var file in tempFiles) {
          if (file is File && 
              file.path.contains('image_picker')) {
            file.deleteSync();
          }
        }
      } catch (e) {
        print('Error cleaning temp files: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Pattern
        Container(
          height: 160,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.homePattern),
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Profile Content
        Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 45),
            
            // Profile Image Section
            _buildProfileImage(),
            
            const SizedBox(height: 16),
            
            // Profile Info
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              )
            else
              _buildProfileInfo(),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.background),
            borderRadius: BorderRadius.circular(32),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: _userProfile?.profileImage != null
                      ? CachedNetworkImage(
                          imageUrl: _userProfile!.profileImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => 
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Image.asset(AppImages.photoProfile),
                        )
                      : Image.asset(AppImages.photoProfile),
                ),
        ),
        
        // Edit Button
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _isUploading ? null : _pickAndUploadImage,
              icon: _isUploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Text(
          _userProfile?.name ?? 'N/A',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          _userProfile?.nim ?? 'N/A',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: AppColors.gray,
          ),
        ),
        Text(
          _userProfile?.email ?? 'N/A',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: AppColors.gray,
          ),
        ),
      ],
    );
  }
}
