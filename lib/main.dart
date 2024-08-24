import 'package:device_preview/device_preview.dart';
import 'package:edu_vista/cubit/auth_cubit.dart';
import 'package:edu_vista/firebase_options.dart';
import 'package:edu_vista/pages/categories/categories_page.dart';
import 'package:edu_vista/pages/chat/chat_page.dart';
import 'package:edu_vista/pages/course/course_details_apge.dart';
import 'package:edu_vista/pages/onboarding/onboarding_page.dart';
import 'package:edu_vista/pages/onboarding/splash_page.dart';
import 'package:edu_vista/pages/profile/profile_page.dart';
import 'package:edu_vista/pages/search/search_page.dart';
import 'package:edu_vista/services/pref.service.dart';
import 'package:edu_vista/utils/color.utility.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:ui';

import 'package:edu_vista/pages/home/home_page.dart';
import 'package:edu_vista/pages/auth/login_page.dart';
import 'package:edu_vista/pages/auth/reset_password_page.dart';
import 'package:edu_vista/pages/auth/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }

  runApp(MultiBlocProvider(
    providers: [BlocProvider(create: (ctx) => AuthCubit())],
    child: const MyApp(),
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) {
    //     return const MyApp();
    //   },
    // ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: _CustomScrollBehaviour(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorUtility.gbScaffold,
        fontFamily: ' PlusJakartaSans',
        colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        final String routeName = settings.name ?? '';
        final Map? data = settings.arguments as Map?;
        switch (routeName) {
          case LoginPage.id:
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case SignUpPage.id:
            return MaterialPageRoute(builder: (context) => const SignUpPage());
          case ResetPasswordPage.id:
            return MaterialPageRoute(
                builder: (context) => const ResetPasswordPage());
          case OnBoardingPage.id:
            return MaterialPageRoute(
                builder: (context) => const OnBoardingPage());
          case HomePage.id:
            return MaterialPageRoute(builder: (context) => const HomePage());
          case CategoriesPage.id:
            return MaterialPageRoute(
                builder: (context) => const CategoriesPage());
          case ChatPage.id:
            return MaterialPageRoute(builder: (context) => const ChatPage());
          case ProfilePage.id:
            return MaterialPageRoute(builder: (context) => const ProfilePage());
          case SearchPage.id:
            return MaterialPageRoute(builder: (context) => const SearchPage());
          case CourseDetailsPage.id:
            return MaterialPageRoute(
                builder: (context) => const CourseDetailsPage());

          default:
            return MaterialPageRoute(builder: (context) => const SplashPage());
        }
      },
      initialRoute: SplashPage.id,
    );
  }
}

class _CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
