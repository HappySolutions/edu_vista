import 'package:edu_vista/services/pref.service.dart';
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
  late String? userImage;
  String? updatedImg;

  @override
  void initState() {
    userImage = FirebaseAuth.instance.currentUser?.photoURL;
    if (userImage!.isNotEmpty) {
      print('Imge is accessed successfully');
    } else {
      userImage = 'https://i.postimg.cc/0jqKB6mS/Profile-Image.png';
    }

    super.initState();
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
          CircleAvatar(
            backgroundImage: NetworkImage(userImage!),
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
                  try {
                    var imageResult = await FilePicker.platform
                        .pickFiles(type: FileType.image, withData: true);
                    if (imageResult != null) {
                      updatedImg = imageResult.files.first.name;
                    } else {
                      print('>>>>>>>>>>error Not getting Image');
                    }
                    await FirebaseAuth.instance.currentUser
                        ?.updatePhotoURL(updatedImg);
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Image Updated successfully'),
                      ),
                    );
                  } catch (e) {
                    print('>>>>>>>>>>error $e');
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