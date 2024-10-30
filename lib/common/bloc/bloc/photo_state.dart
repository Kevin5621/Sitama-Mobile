import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUploading extends ProfileState {
  final String currentPhotoUrl;
  
  const ProfileUploading(this.currentPhotoUrl);
  
  @override
  List<Object?> get props => [currentPhotoUrl];
}

class ProfileLoaded extends ProfileState {
  final String photoUrl;
  final String name;
  final String username;
  final String email;
  
  const ProfileLoaded({
    required this.photoUrl,
    required this.name,
    required this.username,
    required this.email,
  });
  
  @override
  List<Object?> get props => [photoUrl, name, username, email];
}

class ProfileError extends ProfileState {
  final String message;
  
  const ProfileError(this.message);
  
  @override
  List<Object?> get props => [message];
}
