// ignore_for_file: avoid_print

import 'package:edu_vista/pages/auth/login_page.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/widgets/profile/profile_menu_widget.dart';
import 'package:edu_vista/widgets/profile/profile_pic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';

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
              press: () {
                Navigator.pushNamed(context, 'edit_settings');
              },
            ),
            ProfileMenu(
              text: "Settings",
              press: () {},
            ),
            ProfileMenu(
              text: "About Us",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              press: () {
                PreferencesService.clearData();
                Navigator.popAndPushNamed(context, 'LoginPage');
              },
            ),
          ],
        ),
      ),
    );
  }
}
