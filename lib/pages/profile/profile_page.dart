import 'package:edu_vista/widgets/profile/profile_menu_widget.dart';
import 'package:edu_vista/widgets/profile/profile_pic_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const String id = 'profile';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Edit",
              press: () => {},
            ),
            ProfileMenu(
              text: "Settings",
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              press: () {},
            ),
            ProfileMenu(
              text: "Achivements",
              press: () {},
            ),
            ProfileMenu(
              text: "About Us",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}
