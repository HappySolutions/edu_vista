// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:edu_vista/blocs/theme/theme_bloc.dart';
import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/widgets/profile/profile_menu_widget.dart';
import 'package:edu_vista/widgets/profile/profile_pic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, bool> _expandedSections = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildExpandedSection('Settings'),
            _buildExpandedSection('About Us'),
            ProfileMenu(
              text: "Log Out",
              backgroundColor: Colors.transparent,
              textColor: Colors.red,
              iconColor: Colors.red,
              press: () async {
                await context.read<AuthCubit>().logout();
                Navigator.popAndPushNamed(context, 'LoginPage');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedSection(String title) {
    bool isExpanded = _expandedSections[title] ?? false;

    Widget sectionContent;
    switch (title) {
      case 'Settings':
        sectionContent = Container(
          padding: const EdgeInsets.all(20),
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Change Theme Mode',
              ),
              Switch(
                activeColor: ColorUtility.deepYellow,
                // activeTrackColor: ColorUtility.deepYellow,
                value: context.watch<ThemeBloc>().state == ThemeMode.dark,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(ThemeChanged(isDark: value));
                },
              ),
            ],
          ),
        );

        break;

      case 'About Us':
        sectionContent = const Column(
          children: [
            Text('Eduvista App is an Educational App'),
            Text('All Rights reserved @'),
          ],
        );

        break;
      default:
        sectionContent = const Text('No content available');
    }

    return ExpansionTile(
      showTrailingIcon: false,
      title: Container(
        decoration: BoxDecoration(
          border: isExpanded
              ? Border.all(
                  color: ColorUtility.deepYellow,
                  width: 2.0,
                )
              : null,
          borderRadius: BorderRadius.circular(6),
          color: isExpanded ? Colors.transparent : ColorUtility.grayExtraLight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isExpanded
                    ? ColorUtility.deepYellow
                    : ColorUtility.mediumlBlack,
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_down : Icons.double_arrow,
              color: isExpanded
                  ? ColorUtility.deepYellow
                  : ColorUtility.mediumlBlack,
            ),
          ],
        ),
      ),
      iconColor: ColorUtility.deepYellow,
      maintainState: true,
      collapsedBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide.none,
      ),
      onExpansionChanged: (expanded) {
        setState(() {
          _expandedSections[title] = expanded;
        });
      },
      children: [
        SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [sectionContent],
            ),
          ),
        ),
      ],
    );
  }
}
