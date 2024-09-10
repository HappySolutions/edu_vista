import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/user_image.dart';
import 'package:edu_vista/models/user_model.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/utils/image_utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    super.key,
  });

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  String _photoUrl = '';
  UserModel? _user;
  String _uid = '';

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    _uid = FirebaseAuth.instance.currentUser!.uid;
    _user = await getInfoFirestore(_uid);
    _photoUrl = _user?.photo_url ?? '';
  }

  Future<UserModel> getInfoFirestore(String uid) async {
    DocumentSnapshot result =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
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
    return FirebaseFirestore.instance
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: CachedNetworkImage(
              imageUrl: _photoUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 140,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: ColorUtility.main),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () async {
                  final getImage = await getFile();
                  if (getImage.path.isNotEmpty) {
                    _photoUrl =
                        await uploadFile(getImage.file_name, getImage.path) ??
                            '';
                  }
                  setState(() {});
                  if (_photoUrl.isNotEmpty) {
                    await uploadDataFirestore('users', _uid, {
                      'photo_url': _photoUrl,
                    });
                  }
                },
                child: SvgPicture.string(ImageUtility.picIcon),
              ),
            ),
          )
        ],
      ),
    );
  }
}
// var imageResult = await FilePicker.platform
                  //     .pickFiles(type: FileType.image, withData: true);
                  // if (imageResult != null) {
                  //   var storageRef = FirebaseStorage.instance
                  //       .ref('images/${imageResult.files.first.name}');
                  //   var uploadResult = await storageRef.putData(
                  //       imageResult.files.first.bytes!,
                  //       SettableMetadata(
                  //         contentType:
                  //             'image/${imageResult.files.first.name.split('.').last}',
                  //       ));

                  //   if (uploadResult.state == TaskState.success) {
                  //     String downloadUrl =
                  //         await uploadResult.ref.getDownloadURL();
                  //     PreferencesService.userImage = downloadUrl;
                  //     setState(() {});
                  //     print('>>>>>Image upload ${downloadUrl}');
                  //   }
                  // } else {
                  //   print('No file selected');
                  // }