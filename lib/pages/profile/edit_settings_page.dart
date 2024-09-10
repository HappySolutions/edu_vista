// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/user_model.dart';
import 'package:edu_vista/models/user_image.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/widgets/general/custom_elevated_button.dart';
import 'package:edu_vista/widgets/general/custom_text_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EditSettings extends StatefulWidget {
  static const String id = 'edit_settings';

  const EditSettings({super.key});

  @override
  State<EditSettings> createState() => _EditSettingsState();
}

class _EditSettingsState extends State<EditSettings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  String _photoUrl = '';
  String _uid = '';
  UserModel? _user;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    _uid = FirebaseAuth.instance.currentUser!.uid;
    _user = await getInfoFirestore(_uid);
    _photoUrl = _user?.photo_url ?? '';
    _nameController.text = _user?.name ?? '';
    _emailController.text = _user?.email ?? '';
    _phoneNumController.text = _user?.phone_number ?? '';
    setState(() {
      _isLoading = false;
    });
  }

  Future<UserModel> getInfoFirestore(String uid) async {
    DocumentSnapshot result =
        await firestore.collection('users').doc(uid).get();
    return UserModel.fromDocument(result);
  }

  Future<String?> uploadFile(String fileName, String filePath) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    File file = File(filePath);
    try {
      await firebaseStorage.ref('images/$fileName').putFile(file);
      return await firebaseStorage.ref('images/$fileName').getDownloadURL();
    } on FirebaseException catch (e) {
      print(e.message ?? '');
      return null;
    }
  }

  Future<UserImage> getFile() async {
    final filePicker = await FilePicker.platform.pickFiles();
    final path = filePicker?.files.single.path ?? '';
    final fileName = filePicker?.files.single.name ?? '';

    return UserImage(path: path, file_name: fileName);
  }

  Future<void> uploadDataFirestore(
    String collectionPath,
    String path,
    Map<String, dynamic> dataNeedUpdate,
  ) async {
    return firestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate)
        .then((value) {
      const snackBar = SnackBar(
        content: Text('Updated Successfuly'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((e) {
      const snackBar = SnackBar(
        content: Text('Error Happend'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Align(
                  child: GestureDetector(
                    onTap: () async {
                      final getImage = await getFile();
                      if (getImage.path.isNotEmpty) {
                        _photoUrl = await uploadFile(
                                getImage.file_name, getImage.path) ??
                            '';
                      }
                      setState(() {});
                      if (_photoUrl.isNotEmpty) {
                        await uploadDataFirestore('users', _uid, {
                          'photo_url': _photoUrl,
                        });
                      }
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (_photoUrl.isNotEmpty) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: CachedNetworkImage(
                              imageUrl: _photoUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return const SizedBox(
                            height: 140,
                            width: 140,
                            child: Icon(
                              Icons.account_circle,
                              size: 140,
                              color: ColorUtility.gray,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                CustomTextFormField(
                  hintText: 'Full Name',
                  labelText: 'Name',
                  controller: _nameController,
                ),
                CustomTextFormField(
                  hintText: 'Email',
                  labelText: 'Email',
                  controller: _emailController,
                ),
                CustomTextFormField(
                  hintText: 'Phone Number',
                  labelText: 'Phone',
                  controller: _phoneNumController,
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    uploadDataFirestore('users', _uid, {
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'phone_number': _phoneNumController.text
                    });
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
    );
  }
}
