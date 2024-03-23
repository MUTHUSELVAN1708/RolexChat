import 'dart:convert';
import 'dart:io';

import 'package:firebase_integration/constants/globalVariables.dart';
import 'package:firebase_integration/homescreen/screens/homescreen.dart';
import 'package:firebase_integration/profile/cubit/profilecubit.dart';
import 'package:firebase_integration/profile/cubit/profilestate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.grey.shade200,
        title: const Text('Profile'),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.error) {
            showErrorSnackBar(context: context, message: state.errorMessage);
          }
          if (state.status == ProfileStatus.success) {
            showSuccessSnackBar(
                context: context, message: 'Profile created successfully');
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) {
            //       return const HomeScreen(userName: '');
            // }));
          }
        },
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: getImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? const Icon(Icons.camera_alt, size: 40)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(),
                    ),
                    child: TextField(
                      controller: _aboutController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'About',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: state.status == ProfileStatus.loading
                        ? CircularProgressIndicator(
                            color: Colors.purple.shade200,
                          )
                        : GestureDetector(
                            onTap: () {
                              profileCubit.createProfile(
                                  _emailController.text,
                                  _usernameController.text,
                                  _aboutController.text,
                                  _image);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.purple.shade500,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                  child: Text(
                                'Save',
                                style: TextStyle(fontSize: 18),
                              )),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: SvgPicture.asset(
                    'assets/icons/scorpion.svg',
                    height: 200,
                    width: 100,
                    color: Colors.black,
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
