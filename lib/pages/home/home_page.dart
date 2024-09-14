import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/models/user_model.dart';
import 'package:edu_vista/pages/chat/chat_page.dart';
import 'package:edu_vista/pages/course/courses_page.dart';
import 'package:edu_vista/pages/home/homepage_view.dart';
import 'package:edu_vista/pages/profile/profile_page.dart';
import 'package:edu_vista/pages/search/search_page.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:edu_vista/widgets/general/custom_navigationbar.dart';
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
    const HomePageView(),
    const CoursesPage(
      showAppbar: false,
      query: '',
    ),
    const SearchPage(),
    const ChatPage(),
    const ProfilePage(),
  ];
  int _selectedIndex = 0;
  String _photoUrl = '';

  @override
  void initState() {
    getInfoFirestore();
    super.initState();
  }

  void getInfoFirestore() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _photoUrl = UserModel.fromDocument(result).photo_url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'cart');
              },
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        curentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          BottomNavBarItem(
            icon: const Icon(Icons.home_outlined),
          ),
          BottomNavBarItem(
            icon: const Icon(Icons.menu_book_outlined),
          ),
          BottomNavBarItem(
            icon: const Icon(Icons.search),
          ),
          BottomNavBarItem(
            icon: const Icon(Icons.wechat_outlined),
          ),
          BottomNavBarItem(
            icon: ClipOval(
              child: Uri.parse(_photoUrl).hasAbsolutePath
                  ? CachedNetworkImage(
                      imageUrl: _photoUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.account_circle, color: Colors.grey),
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox(
                      height: 30,
                      width: 30,
                      child: Icon(
                        Icons.account_circle,
                        color: ColorUtility.gray,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }

  Widget _buildAppBarTitle() {
    if (_selectedIndex == 0) {
      return Row(
        children: [
          const Text(
            'Welcome ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Flexible(
            child: Text(
              (PreferencesService.authAction == 'signup') ? '' : 'Back! ',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Flexible(
            child: Text(
              FirebaseAuth.instance.currentUser?.displayName ?? 'User',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: ColorUtility.main,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      );
    } else if (_selectedIndex == 1) {
      return const Center(child: Text('Courses'));
    } else if (_selectedIndex == 2) {
      return const Center(child: Text('Search'));
    } else if (_selectedIndex == 3) {
      return const Center(child: Text('Chat'));
    } else {
      return const Center(child: Text('Profile'));
    }
  }
}
