import 'package:equatable/equatable.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  error,
}

class ProfileState extends Equatable {
  final String image;
  final String username;
  final String email;
  final String about;
  final ProfileStatus status;
  final String? errorMessage;

  const ProfileState({
    required this.image,
    required this.username,
    required this.email,
    required this.about,
    required this.status,
    this.errorMessage
  });

  @override
  List<Object?> get props => [
    image,
    username,
    email,
    about,
    status,
    errorMessage
  ];

  ProfileState copyWith({
    String? image,
    String? username,
    String? email,
    String? about,
    ProfileStatus? status,
    String? errorMessage
  }) {
    return ProfileState(
      image: image ?? this.image,
      username: username ?? this.username,
      email: email ?? this.email,
      about: about ?? this.about,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
}
