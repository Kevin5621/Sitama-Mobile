import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/bloc/bloc/photo_cubit.dart';
import 'package:sistem_magang/common/bloc/bloc/photo_state.dart';
import 'package:sistem_magang/core/config/assets/app_images.dart';
import 'package:sistem_magang/core/config/themes/app_color.dart';


class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.background),
                borderRadius: BorderRadius.circular(32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: _buildProfileImage(state),
              ),
            ),
            if (state is! ProfileLoading)
              Positioned(
                bottom: 0,
                right: 0,
                child: _buildEditButton(context, state),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProfileImage(ProfileState state) {
    if (state is ProfileLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    String? photoUrl;
    if (state is ProfileLoaded) {
      photoUrl = state.photoUrl;
    } else if (state is ProfileUploading) {
      photoUrl = state.currentPhotoUrl;
    }

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: photoUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Image.asset(
          AppImages.photoProfile,
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.asset(
      AppImages.photoProfile,
      fit: BoxFit.cover,
    );
  }

  Widget _buildEditButton(BuildContext context, ProfileState state) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: state is ProfileUploading
            ? null
            : () => context.read<ProfileCubit>().pickAndUploadImage(),
        icon: state is ProfileUploading
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
    );
  }
}