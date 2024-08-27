import 'package:edu_vista/pages/categories/categories_page.dart';
import 'package:edu_vista/pages/chat/chat_page.dart';
import 'package:edu_vista/pages/profile/profile_page.dart';
import 'package:edu_vista/pages/search/search_page.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/widgets/categories_widget.dart';
import 'package:edu_vista/widgets/course/courses_widget.dart';
import 'package:edu_vista/widgets/custom_navigationbar.dart';
import 'package:edu_vista/widgets/label_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _screens = [
    const HomePage(),
    const CategoriesPage(),
    const SearchPage(),
    const ChatPage(),
    const ProfilePage(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Welcome ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              (PreferencesService.authAction == 'signup') ? '' : 'Back! ',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              '${FirebaseAuth.instance.currentUser?.displayName}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ColorUtility.main),
            )
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.shopping_cart_outlined),
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        curentIndex: _selectedIndex,
        onTap: (value) => setState(() {
          _selectedIndex = value;
        }),
        children: [
          BottomNavBarItem(
            icon: Icons.home,
          ),
          BottomNavBarItem(
            icon: Icons.book,
          ),
          BottomNavBarItem(
            icon: Icons.search,
          ),
          BottomNavBarItem(
            icon: Icons.chat,
          ),
          BottomNavBarItem(
            icon: Icons.person,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              LabelWidget(
                name: 'Categories',
                onSeeAllClicked: () {},
              ),
              const CategoriesWidget(),
              const SizedBox(
                height: 20,
              ),
              LabelWidget(
                name: 'Top Rated Courses',
                onSeeAllClicked: () {},
              ),
              const CoursesWidget(
                rankValue: 'top rated',
              ),
              const SizedBox(
                height: 20,
              ),
              LabelWidget(
                name: 'Top Seller Courses',
                onSeeAllClicked: () {},
              ),
              const CoursesWidget(
                rankValue: 'top seller',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
