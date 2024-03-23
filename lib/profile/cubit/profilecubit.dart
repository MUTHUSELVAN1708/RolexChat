import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_integration/profile/cubit/profilestate.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(const ProfileState(
            image: '',
            username: '',
            email: '',
            about: '',
            status: ProfileStatus.initial));
  final fireStore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  void setError(String? message) {
    emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: message ?? 'Something went wrong. Please Try again.'));
  }

  void setLoading() {
    emit(state.copyWith(status: ProfileStatus.loading));
  }

  Future<void> createProfile(
    String email,
    String userName,
    String about,
    File? image,
  ) async {
    String imageUrl = '';
    setLoading();
    try {
      if (validateFields(email, userName, about)) {
        if (EmailValidator.validate(email)) {
          if (image != null) {
            final storedImage =
                storage.ref().child('profile/${DateTime.now()}.png');
            await storedImage.putFile(image);
            final downloadUrl = await storedImage.getDownloadURL();
            imageUrl = downloadUrl;
          }
          await fireStore.collection('profile').doc(email).set({
            'userName': userName,
            'email': email,
            'about': about,
            'imageUrl': imageUrl,
          });
          emit(state.copyWith(
            status: ProfileStatus.success,
            username: userName,
            email: email,
            about: about,
          ));
        } else {
          setError('Please Enter valid Email');
        }
      } else {
        setError('Please fill all fields');
      }
    } catch (error) {
      setError('Failed to create profile: $error');
    }
  }

  Future<void> updateProfile() async {
    setLoading();
    emit(state.copyWith(status: ProfileStatus.success));
  }

  bool validateFields(String email, String userName, String about) {
    if (email.isNotEmpty && userName.isNotEmpty && about.isNotEmpty) {
      return true;
    }
    return false;
  }
}
